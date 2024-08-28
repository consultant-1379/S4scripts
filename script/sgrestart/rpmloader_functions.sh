#!/bin/bash

usage() {
  echo 'Script to deploy service rpm(s) on service group(s)'
  echo "Usage: $0 -r 'rpm_urls' -g 'service_groups' -i jira_id"
  echo
  echo ' where'
  echo '     -r    rpm_urls, a space separated list of URLs for the RPMs within quotes'
  echo '     -g    service_groups, a space separated list of service groups within quotes.'
  echo '           Full SG name or short form are both acceptable.'
  echo '           e.g. Grp_CS_svc_cluster_shmcoreserv or shmcoreserv'
  echo '     -i    jira_id, the ID of the relevant Jira Issue. e.g. CIP-12345'
  echo
  exit 1
}

get_rpm_names_from_rpm_url_list() {
  local rpm_url_list
  local rpm_names
  local rpm_url
  local rpm_name
  rpm_url_list="$1"
  for rpm_url in $rpm_url_list; do
    rpm_name=$(echo "${rpm_url}" | awk -F"/" '{print $NF}' | awk -F '-' '{print $1}')
    rpm_names="$rpm_names $rpm_name"
  done
  echo "$rpm_names"
}

create_backup_directory() {
  local jira_id
  local timestamp
  local backup_dir
  jira_id=$1
  timestamp=$(date '+%Y_%m_%d_%H:%M:%S')
  backup_dir=$RPM_BACKUP_PARENT_DIR/$jira_id/$timestamp
  mkdir -p "$backup_dir"
  echo "$backup_dir"  
}

move_old_rpms_to_backup_directory() {
  local backup_dir
  local rpm_names
  local rpm_name
  local source_file_paths
  local source_file_path
  backup_dir=$1
  rpm_names=$2
  for rpm_name in $rpm_names; do
    source_file_path="$ENM_SERVICES_DIR/$rpm_name*"
    source_file_paths="$source_file_paths $source_file_path"
  done
  mv --verbose -t $backup_dir $source_file_paths > /dev/null
}

move_old_rpms_to_enm_services_dir() {
  local backup_dir
  backup_dir=$1
  mv --verbose -t $ENM_SERVICES_DIR $backup_dir/* > /dev/null
}

load_new_rpms_into_repo() {
  cd $ENM_SERVICES_DIR
#LA VARIABILE SOTTO NON FUNZIONA
  if wget -q $RPM_URL_LIST; then
    while pgrep -f "createrepo/worker.py" >/dev/null 2>&1; do 
      echo `date "+%F %T.%3N"`" INFO  createrepo IS ALREADY RUNNING WAITING .... "
      sleep 15
    done
    createrepo . > /dev/null
    yum clean all > /dev/null
    return 0
  else
    return 1
  fi
}

backup_old_rpms_and_load_new_rpms_into_repo() {
  local url_list
  local backup_dir
  local rpm_names
  rpm_url_list="$1"
  backup_dir=$(create_backup_directory $JIRA_ID)
  rpm_names=$(get_rpm_names_from_rpm_url_list "$rpm_url_list")
  move_old_rpms_to_backup_directory $backup_dir "$rpm_names"
  if ! load_new_rpms_into_repo $rpm_url_list; then
    move_old_rpms_to_enm_services_dir $backup_dir
    return 1
  fi
  return 0
}

get_service_group_regex() {
  local short_name_service_group_list
  local service_group_list_regex
  local service_group
  short_name_service_group_list="$1"
  for service_group in $short_name_service_group_list; do
    if [ -z $service_group_list_regex ]; then
      service_group_list_regex="_$service_group "
    else
      service_group_list_regex="$service_group_list_regex|_$service_group "
    fi
  done
  echo "$service_group_list_regex"
}

get_full_name_service_group_list() {
  local short_name_service_group_list
  local service_group_regex
  local full_name_service_group_list
  short_name_service_group_list="$1"
  service_group_regex=$(get_service_group_regex "$short_name_service_group_list")
  full_name_service_group_list=$(/opt/ericsson/enminst/bin/vcs.bsh --groups | egrep "$service_group_regex" | awk '{print $2}' | sort | uniq)
  echo "$full_name_service_group_list"
}

get_list_of_blades_where_vms_must_be_undefined() {
  local short_name_service_group_list
  local service_group_regex
  local blades
  short_name_service_group_list="$1"
  service_group_regex=$(get_service_group_regex "$short_name_service_group_list")
  blades=$(/opt/ericsson/enminst/bin/vcs.bsh --groups | egrep "$service_group_regex" | awk '{print $3}' | sort | uniq)
  echo "$blades"
}

offline_service_groups() {
  local full_name_service_group_list
  local blade
  local timout
  local service_group
  full_name_service_group_list="$1"
  blade=$2
  timout=300
  for service_group in $full_name_service_group_list; do
    /opt/ericsson/enminst/bin/vcs.bsh -g $service_group -s $blade -m $timout --offline
  done
}

get_vms_to_undefine() {
  local full_name_service_group_list
  local vms_to_undefine
  local service_group
  local vm
  full_name_service_group_list="$1"
  for service_group in $full_name_service_group_list; do
    vm=$(echo $service_group | sed -e 's/Grp_CS_..._cluster_\(.*\)/\1/g')
    vms_to_undefine="$vms_to_undefine $vm"
  done
  echo "$vms_to_undefine"
}

undefine_vms() {
  local blade
  local vms_to_undefine
  local vm
  blade=$1
  vms_to_undefine="$2"
  for vm in $vms_to_undefine; do
    if [[ $vm =~ [_] ]]; then
      vm=$(echo $vm | sed 's/\_/\-/g')
    fi

    /root/rvb/bin/ssh_to_vm_and_su_root.exp $blade "virsh undefine $vm" > /dev/null
  done
}

undefine_vms_on_blades() {
  local blade
  local vm
  blade="$1"
  vm=$2
  undefine_vms $blade $vm 
}

online_service_groups() {
  local full_name_service_group_list
  local blade
  local timout
  local service_group
  full_name_service_group_list="$1"
  blade=$2
  timout=500
  for service_group in $full_name_service_group_list; do
    /opt/ericsson/enminst/bin/vcs.bsh -g $service_group -s $blade -m $timout --online
  done
}

check_rpm_url() {
  local rpm_url_list
  local rpm_url
  rpm_url_list="$1"
  for rpm_url in $rpm_url_list; do
    if ! wget -q --spider "$rpm_url"; then
      if curl --output /dev/null --silent --head --fail "$rpm_url"; then
        #echo "URL exists: $rpm_url"
        return 0
      else
        #echo " ERROR  URL DOES NOT EXIST: $rpm_url"
#        exit 1
	echo $rpm_url
        return 1
      fi
    fi
  done
}
