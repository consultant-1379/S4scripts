#!/bin/bash

#WORKLOAD_SERVER=$1
#LMS=$2
NETSIMS=$1
BASHRC="/root/.bashrc"
YUM_REPO_TORUTIL=$(/usr/bin/repoquery -a --repoid=ms_repo --qf "%{version}" ERICtorutilities_CXP9030570)
INSTALLED_LMS_TORUTIL=$(rpm -q ERICtorutilities_CXP9030570 | sed "s/-[^-]*$//" | sed "s/^.*-//g")
YUM_REPO_DDCCORE=$(/usr/bin/repoquery --qf  %{version} ERICddccore_CXP9035927)
INSTALLED_WKLVM_DDCCORE=$(rpm -q ERICddccore_CXP9035927 | sed "s/-[^-]*$//" | sed "s/^.*-//g")

NODES_DIR=/opt/ericsson/enmutils/etc/nodes/
#NODES=$NETSIM-nodes
DDP_CONFIG_FILE="/var/ericsson/ddc_data/config/server.txt"

enable_password_less_lms_workload_vm(){
  echo "$FUNCNAME - $(date)"
  echo "Enabling passwordless access from LMS to WORKLOAD_SERVER"
  /root/rvb/copy-rsa-key-to-remote-host.exp $WORKLOAD_SERVER root 12shroot
}

add_alias_to_lms(){
  echo "$FUNCNAME - $(date)"
  echo "Add alias to LMS to allow for quick connection to WORKLOAD_SERVER"
#Clear existing aliases if present
  sed -i 's/.*WORKLOAD_.*//' $BASHRC
  sed -i 's/.*connect_to_vm.*//' $BASHRC
# BR Jenkins Jobs expect WORKLOAD_VM instead of WORKLOAD_SERVER in bashrc file
  echo "WORKLOAD_VM=$WORKLOAD_SERVER" >> $BASHRC
  echo "alias connect_to_vm='ssh -o StrictHostKeyChecking=no \$WORKLOAD_VM'" >> $BASHRC
# Remove empty lines in the file
  sed -i '/^$/d' $BASHRC

}

add_workload_vm_to_ddpi(){
  echo "$FUNCNAME - $(date)"
  echo "Add WORKLOAD_SERVER to list of remotehosts that DDC will collect stats from"
#Clear existing value if present
  sed -i 's/.*WORKLOAD.*//' $DDP_CONFIG_FILE
  echo ${WORKLOAD_SERVER}.athtem.eei.ericsson.se=WORKLOAD >> $DDP_CONFIG_FILE
# Remove empty lines in the file
  sed -i '/^$/d' $DDP_CONFIG_FILE

}

enable_password_less_workload_vm_lms(){
  echo "$FUNCNAME - $(date)"
  echo "Update .bashrc file on WORKLOAD_SERVER to indicate which LMS it will be connected to"
  LMS_HOSTNAME=$(hostname)
  ssh $WORKLOAD_SERVER "sed -i 's/.*LMS_HOST.*//' $BASHRC; echo \"export LMS_HOST=$LMS_HOSTNAME\" >> $BASHRC;sed -i '/^$/d' $BASHRC"
  echo "Set up passwordless ssh access from WORKLOAD SERVER to LMS"
  WORKLOAD_PUBLIC_SSH_KEY=$(ssh $WORKLOAD_SERVER 'cat /root/.ssh/id_rsa.pub')
  echo $WORKLOAD_PUBLIC_SSH_KEY >> /root/.ssh/authorized_keys

}

tear_down_workload_profiles(){
  echo "$FUNCNAME - $(date)"

  echo "Perform hard shutdown of workload on WORKLOAD_SERVER, in case not already done"
  echo "1. Kill all profile daemon processes running on WORKLOAD_SERVER"
  ssh $WORKLOAD_SERVER 'P1=/opt/ericsson/enmutils; P2=/.env/bin/daemon; [[ ! -z $(pgrep -f "$P1$P2") ]] && { echo "Killing enmutil daemons on WL Server"; pkill -f "$P1$P2"; } || echo "No enmutils daemons running on WL Server" '

  echo "2. Remove PID files associated to profiles"
  rm -rf /var/tmp/enmutils/daemon/*pid
  echo "3. Clear all persisted objects on WORKLOAD_SERVER"
  ssh $WORKLOAD_SERVER "/opt/ericsson/enmutils/bin/persistence clear force --auto-confirm"
}


fetch_enmutils_rpm_from_nexus() {
    echo "$FUNCNAME - $(date)"
    nexus='https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus';
    gr='com.ericsson.dms.torutility';
    art='ERICtorutilitiesinternal_CXP9030579';
    ver=`/usr/bin/repoquery -a --repoid=ms_repo --qf "%{version}" ERICtorutilities_CXP9030570`;
    wget -O $art-$ver.rpm "$nexus/service/local/artifact/maven/redirect?r=releases&g=${gr}&a=${art}&v=${ver}&e=rpm"
}

check_torutils_lms_upgraded_iso(){
  echo "$FUNCNAME - $(date)"
  echo "Checking if enmutils installed on LMS is aligned to iso version"
  if [ "$YUM_REPO_TORUTIL" != "$INSTALLED_LMS_TORUTIL" ]; then
    echo "Enmutils installed on LMS needs to be aligned to iso version ...."
    yum remove -y ERICtorutilities_CXP9030570
    yum install -y ERICtorutilities_CXP9030570
  fi

}

upgrade_torutils_workload_vm(){
  echo "$FUNCNAME - $(date)"
  echo "Checking if enmutils installed on workload vm is aligned to iso version"
  INSTALLED_WORKLOAD_VM_TORUTIL=$(ssh $WORKLOAD_SERVER "rpm -q ERICtorutilitiesinternal_CXP9030579 | sed 's/-[^-]*$//' | sed 's/^.*-//g'")
  if [ "$INSTALLED_WORKLOAD_VM_TORUTIL" != "$YUM_REPO_TORUTIL" ]; then
    echo "Enmutils installed on $WORKLOAD_SERVER needs to be aligned to iso version ...."
    ssh $WORKLOAD_SERVER "/opt/ericsson/enmutils/.deploy/update_enmutils_rpm $YUM_REPO_TORUTIL"
  fi
}

scp_nodes_files_to_workload_vm(){
  echo "$FUNCNAME - $(date)"
  echo "Deleting existing node files"
  ssh $WORKLOAD_SERVER "rm -rf /opt/ericsson/enmutils/etc/nodes/*"
  echo "Copying node files to worload VM"
  scp -r /opt/ericsson/enmutils/etc/nodes $WORKLOAD_SERVER:/opt/ericsson/enmutils/etc/ 
}

add_nodes_to_workload_pool(){
  echo "$FUNCNAME - $(date)"
  echo "Adding nodes to worload pool"
  for NETSIM in $NETSIMS; do
     nodes=$NETSIM-nodes
     echo "Adding nodes file $nodes to worload pool"
    ssh $WORKLOAD_SERVER "/opt/ericsson/enmutils/bin/workload add $NODES_DIR$nodes"
  done
  echo "Adding nodes to worload pool has been successfully completed"

}

update_yum_configuration_to_use_proxy(){
  echo "$FUNCNAME - $(date)"
  echo "Update yum configuration of workload VM to use proxy"
  ssh $WORKLOAD_SERVER 'echo "proxy=http://atproxy1.athtem.eei.ericsson.se:3128/" >> /etc/yum.conf'
}

enable_password_less_access_workload_vm_kvm_vms(){
  echo "$FUNCNAME - $(date)"
  echo "Enable password-less ssh access to KVM VMs"
  scp /root/.ssh/vm_private_key root@$WORKLOAD_SERVER:/root/.ssh
}

check_node_files(){
  local not_existing=0
  echo "******* CHECKING PARSED NODE FILES"
  for netsim in $NETSIMS;do
    FILE=/opt/ericsson/enmutils/etc/nodes/${netsim}-nodes
    nodes_files="$nodes_files $FILE" 
    if ! test -f "$FILE";then
      echo "ERROR: $FILE does not exists!"
      not_existing=1
    fi
  done
  if [ $not_existing -eq 0 ]; then
    echo "OK: All nodes files are present"
  fi
}

get_netype_from_node_files(){
  netypes=$(cat $nodes_files | awk -F "," '{print $21}' | grep -v primary_type |  sort | uniq)
  echo "NETYPES found in node files: $netypes"
}

create_node_list_from_node_files(){
  mkdir -p /var/tmp/check_deployment_setup/
  for netype in $netypes;do
    if [ $netype == 'ERBS' ];then
      cat $nodes_files | grep -w  $netype | grep -v dg2 | awk '{print $1}' | sort | uniq | sed 's/,//g' > /var/tmp/check_deployment_setup/${netype}_node_list.txt
    else   
      cat $nodes_files | grep -w $netype | awk '{print $1}' | sort | uniq | sed 's/,//g' > /var/tmp/check_deployment_setup/${netype}_node_list.txt
    fi
  done
}

create_node_list_from_enm(){
  mkdir -p /var/tmp/check_deployment_setup/
  for netype in $netypes;do
    /opt/ericsson/enmutils/bin/cli_app "cmedit get * NetworkElement -netype=$netype -t" | grep -v instance | grep -v NetworkElement | grep -v NodeId | sort > /var/tmp/check_deployment_setup/${netype}_enm_list.txt
  done
}

remove_netsim_vm_from_node_name(){
  for netype in $netypes;do
    sed -i 's/ieatnetsimv......//g' /var/tmp/check_deployment_setup/${netype}_enm_list.txt
    sed -i 's/ieatnetsimv......//g' /var/tmp/check_deployment_setup/${netype}_node_list.txt
  done
}


find_missing_nodes(){
  for netype in $netypes;do
    echo "FIND MISSING NODES FOR NETYPE: $netype"
    diff /var/tmp/check_deployment_setup/${netype}_node_list.txt /var/tmp/check_deployment_setup/${netype}_enm_list.txt | grep "<" | sed 's/^<\ //g'
  done
}

#set -ex

rm -rf /var/tmp/check_deployment_setup/*

check_node_files
get_netype_from_node_files
create_node_list_from_node_files
create_node_list_from_enm
remove_netsim_vm_from_node_name
find_missing_nodes


#enable_password_less_lms_workload_vm
#add_alias_to_lms
#add_workload_vm_to_ddpi
#enable_password_less_workload_vm_lms
#tear_down_workload_profiles
#fetch_enmutils_rpm_from_nexus
#update_yum_configuration_to_use_proxy
#enable_password_less_access_workload_vm_kvm_vms


#check_torutils_lms_upgraded_iso
#upgrade_torutils_workload_vm


#scp_nodes_files_to_workload_vm
#add_nodes_to_workload_pool

