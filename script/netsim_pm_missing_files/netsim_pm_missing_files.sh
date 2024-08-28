#!/bin/bash

#deployment_type=$1
node_list=$4
pmtype=$1
rop_date=$2
rop_time=$3


rop_date_time="${rop_date}.${rop_time}"
#echo $rop_time
pmfiles_working_dir="/tmp/netsim_pm_files/"
pmfiles_collected_15min="${pmfiles_working_dir}pm_files_collected_15min_${ne}_${pmtype}"
#nodes_pm_collected_15min="${pmfiles_working_dir}nodes_pm_collected_15min_${netype}_${pmtype}"
nodes_pm_expected_15min="${pmfiles_working_dir}nodes_pm_expected_15min_${netype}_${pmtype}"

create_pmfiles_working_dir(){
  mkdir -p $pmfiles_working_dir
  if [ $deployment_type = "cENM" ];then
    kubectl exec -i postgres-0 -c postgres -n enm1514 -- /usr/bin/mkdir -p $pmfiles_working_dir
  fi
  if [ $deployment_type = "pENM" ];then
    ssh -q -o StrictHostKeyChecking=no $lms_host "mkdir -p $pmfiles_working_dir"
  fi  
}

remove_pmfiles_working_dir(){
  if [ $deployment_type = "cENM" ];then
    kubectl exec -i postgres-0 -c postgres -n enm1514 -- /usr/bin/rm -rf ${pmfiles_working_dir}pm_collected*
  fi
  if [ $deployment_type = "pENM" ];then
    ssh -q -o StrictHostKeyChecking=no $lms_host "rm -rf ${pmfiles_working_dir}pm_collected*"
  fi
}


get_netsim_vm_from_nodes_file(){
   netsim_vm=$(grep --exclude-dir=* -w "$node" /opt/ericsson/enmutils/etc/nodes/*nodes | awk -F',' '{print $25}' | sed 's/ //g')
#   echo $netsim_vm
}

get_netsim_pm_file_by_date(){
  netsim_pm_files=$(sshpass -p netsim ssh -q -o StrictHostKeyChecking=no netsim@$netsim_vm "find /pms_tmpfs | grep A$rop_date_time | grep $node | grep xml")
#  echo "$netsim_pm_files"
  if [[ "$netsim_pm_files" == *"$node"* ]];then
    return 0
  else
    return 1
  fi

}

get_lms_host_from_workload_vm(){
  lms_host=$(env | grep LMS_HOST | awk -F'=' '{print $2}')
#  echo $lms_host
}

get_enm_pm_file_by_date(){
  enm_pm_files=$(sshpass -p 12shroot ssh -q -o StrictHostKeyChecking=no root@$lms_host "/root/rvb/bin/ssh_to_vm_and_su_root.exp svc-1 \"ls /ericsson/pmic*/XML/*$node 2> /dev/null\" | grep $rop_date_time")	
  if [[ "$enm_pm_files" == *"$node"* ]];then
    return 0
  else
    return 1
  fi

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


#      node_ip=$(grep -w "$line" /opt/ericsson/enmutils/etc/nodes/* | awk -F',' '{print $2}' | sed 's/ //g')

banner "SEARCHING NETSIM PM FILES FOR ROP $rop_date_time"

for node in $node_list;do
  get_netsim_vm_from_nodes_file
  if ! get_netsim_pm_file_by_date;then
    echo "ERROR: STATISTICAL PM FILE NOT FOUND IN NETSIM FOR NODE $node AT ROP $rop_date_time"
  else
    node_list_enm_pm="$node_list_enm_pm $node"
  fi
done

banner "SEARCHING ENM PM FILES FOR ROP $rop_date_time"

#for node in $node_list_enm_pm;do
for node in $node_list;do
    get_lms_host_from_workload_vm
    if ! get_enm_pm_file_by_date;then
      echo "ERROR: STATISTICAL PM FILE NOT FOUND IN ENM FOR NODE $node AT ROP $rop_date_time"
    fi
done


