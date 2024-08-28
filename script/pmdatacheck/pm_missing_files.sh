#!/bin/bash

deployment_type=$1
netype=$2
pmtype=$3
rop_date=$4
rop_time=$5


#netype="RadioNode"
#netype="SGSN-MME"
#netype="ERBS"
#netype="MINI-LINK-Indoor"
#pmtype="PM_STATISTICAL"
#rop_time_year="2021"
#rop_time_month="11"
#rop_time_day="07"
#rop_time_hour="16"
#rop_time_min="00"
rop_time="${rop_date}T${rop_time}:00"
#echo $rop_time
pmfiles_working_dir="/tmp/check_pm_files/"
pm_collected_15min="${pmfiles_working_dir}pm_collected_15min_${netype}_${pmtype}"
nodes_pm_collected_15min="${pmfiles_working_dir}nodes_pm_collected_15min_${netype}_${pmtype}"
nodes_pm_expected_15min="${pmfiles_working_dir}nodes_pm_expected_15min_${netype}_${pmtype}"

get_lms_host(){
  if [ $deployment_type = "pENM" ];then
    if env | grep LMS_HOST > /dev/null;then
       lms_host=$(env | grep LMS_HOST | cut -d"=" -f2)
    fi
  fi
}

get_postgres_host(){
  if [ $deployment_type = "pENM" ];then	
    postgres_host=$(ssh -q -o StrictHostKeyChecking=no $lms_host "grep postgres /etc/hosts"|awk '{print $1}')
  fi
}

create_pmfiles_working_dir(){
  mkdir -p $pmfiles_working_dir
  if [ $deployment_type = "cENM" ];then
    enm_ns=$(kubectl get ns | grep enm | awk '{print $1}')
    kubectl exec -i postgres-0 -c postgres -n $enm_ns -- /usr/bin/mkdir -p $pmfiles_working_dir
  fi
  if [ $deployment_type = "pENM" ];then
    ssh -q -o StrictHostKeyChecking=no $lms_host "mkdir -p $pmfiles_working_dir"
  fi  
}

remove_pmfiles_working_dir(){
  if [ $deployment_type = "cENM" ];then
    enm_ns=$(kubectl get ns | grep enm | awk '{print $1}')
    kubectl exec -i postgres-0 -c postgres -n $enm_ns -- /usr/bin/rm -rf ${pmfiles_working_dir}pm_collected*
  fi
  if [ $deployment_type = "pENM" ];then
    ssh -q -o StrictHostKeyChecking=no $lms_host "rm -rf ${pmfiles_working_dir}pm_collected*"
  fi
}

query_pm_files_15min(){
  if [ $deployment_type = "cENM" ];then
    enm_ns=$(kubectl get ns | grep enm | awk '{print $1}')
    kubectl exec -i postgres-0 -c postgres -n $enm_ns -- /usr/bin/psql -U postgres -d flsdb -o $pm_collected_15min -q -c "select * from pm_rop_info where start_roptime_in_oss='$rop_time' and data_type='$pmtype' and node_type='$netype';"
  fi
  if [ $deployment_type = "pENM" ];then
    ssh -q -o StrictHostKeyChecking=no $lms_host "PGPASSWORD=P0stgreSQL11 /usr/bin/psql -h $postgres_host -U postgres -d flsdb -o $pm_collected_15min -q -c \"select * from pm_rop_info where start_roptime_in_oss='$rop_time' and data_type='$pmtype' and node_type='$netype';\""
  fi  
}

copy_pm_files_15min(){
  if [ $deployment_type = "cENM" ];then
    enm_ns=$(kubectl get ns | grep enm | awk '{print $1}')
    kubectl cp postgres-0:$pm_collected_15min -c postgres $pm_collected_15min -n $enm_ns
  fi
  if [ $deployment_type = "pENM" ];then
    scp -q -o StrictHostKeyChecking=no root@$lms_host:$pm_collected_15min $pm_collected_15min
  fi
}

check_pm_files_15min_empty(){
  if grep -q "(0 rows)" $pm_collected_15min;then
    echo "NO PM FILES $pmtype HAVE BEEN REPORTED FOR NETYPE $netype"
    exit
  fi
}

extract_nodes_from_pm_files_15min(){
  cat $pm_collected_15min | grep -v "node_name" | awk -F'|' '{print $2}' | sed 's/ManagedElement=//g' | sort | sed 's/ //g' | sed '/^$/d' > $nodes_pm_collected_15min
}

expected_files_statistical_15min(){
  if [ "$pmtype" = "PM_STATISTICAL" ];then
    /opt/ericsson/enmutils/bin/cli_app "cmedit get * PmFunction.pmEnabled==true -ne=$netype -t" | grep true | awk '{print $1}' | sort > $nodes_pm_expected_15min
    case $netype in
     SCU|Router6675|PCG|JUNIPER-MX|FRONTHAUL-6020|EPG-OI|CCDM|RadioNode|SGSN-MME|ERBS|RBS|DSC|MGW|MTAS|RNC|Router6672|MINI-LINK-6352)
        pm_files_multiplier=1
      ;;
      MINI-LINK-669x|MINI-LINK-Indoor|BSC)
        pm_files_multiplier=4
      ;;
      EPG)
        pm_files_multiplier=3
      ;;	
      SBG-IS)
        pm_files_multiplier=300
      ;;	
      *)
        echo -n "unknown"
      ;;
    esac
  fi
}  

expected_files_celltrace_15min(){  
  if [ "$pmtype" = "PM_CELLTRACE" ];then
    /opt/ericsson/enmutils/bin/cli_app "cmedit get * enodebfunction -ne=$netype -t" | awk '{print $1}' | grep -v "SubNetwork\|NodeId\|ManagedElement" | head -n-1 | sort > $nodes_pm_expected_15min	  
    pm_files_multiplier=2
  fi	
}

searching_missing_pm_files_15min(){
#  echo "SEARCHING MISSING PM FILES ....."
  while read line;do
#  echo $line
    num_files_node=$(grep $line $nodes_pm_collected_15min | wc -l)
    if [ "$num_files_node" -ne "$pm_files_multiplier" ];then
      netsim_vm=$(grep -w "$line" /opt/ericsson/enmutils/etc/nodes/* | awk -F',' '{print $25}' | sed 's/ //g')
      node_ip=$(grep -w "$line" /opt/ericsson/enmutils/etc/nodes/* | awk -F',' '{print $2}' | sed 's/ //g')
      echo "MISSING PM FILES FOR NODE $line (IP: $node_ip) --> $netsim_vm (EXPECTED: $pm_files_multiplier FOUND: $num_files_node)"
      grep "$line" $pm_collected_15min | awk -F'|' '{print $7}' | awk -F'/' '{print $6}'
      missing_pm_nodes="$missing_pm_nodes $line"
      missing_files_netsim_vm="$missing_files_netsim_vm $netsim_vm"
      is_missing_pm_files=true
    fi
  done < $nodes_pm_expected_15min
  echo ""
  if $is_missing_pm_files;then
    missing_files_netsim_vm=$(echo $missing_files_netsim_vm | tr ' ' '\n' | sort | uniq | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')
    echo "NODES WITH MISSING PM FILES: $missing_pm_nodes"
    echo ""
    echo "NETSIM VMs W/ MISSING PM FILES: $missing_files_netsim_vm"
  fi  
}

reporting_total_files(){
  tot_collected_files=$(cat $nodes_pm_collected_15min | wc -l)
  tot_expected_files=$(($(cat $nodes_pm_expected_15min | wc -l) * $pm_files_multiplier))
  echo ""
  echo "NUMBER OF PM FILES COLLECTED: $tot_collected_files NUMBER OF PM FILE EXPECTED: $tot_expected_files"
  echo ""
}

banner() {
    msg="# $* #"
    edge=$(echo "$msg" | sed 's/./#/g')
    echo ""
    echo "$edge"
    echo "$msg"
    echo "$edge"
    echo ""
}

banner "SEARCHING FOR MISSING $pmtype FILES AT $rop_time FOR $netype"

if [ $deployment_type = "pENM" ];then
  get_lms_host
  get_postgres_host
fi  
create_pmfiles_working_dir
remove_pmfiles_working_dir
query_pm_files_15min
copy_pm_files_15min
check_pm_files_15min_empty
extract_nodes_from_pm_files_15min
expected_files_statistical_15min
expected_files_celltrace_15min
searching_missing_pm_files_15min
reporting_total_files
