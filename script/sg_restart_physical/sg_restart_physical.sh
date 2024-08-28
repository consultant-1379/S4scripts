#!/bin/bash

clusterId=$1
deployment_type=$2
sg_short_names=$3
undefine_vm=$4
quick_restart=$5

date_time=$(date "+%F %T.%3N")
#$date_time" INFO  get lms info                  : Lms host $lms"       

if [ "${deployment_type}" == "Physical" ];then
#  echo $(date "+%F %T.%3N")" INFO  getting lmsGETTING REMOTE HOST (LMS) FOR DEPLOYMENT TYPE: ${deployment_type}"
  lms=$(./S4scripts/script/utilities/get_host_from_dmt.sh ${clusterId} lms ${deployment_type})
  echo $date_time" INFO  get lms info                  : Lms host $lms"
fi

vcs_cmd=$(/usr/bin/ssh -o StrictHostKeyChecking=no -q root@$lms "/opt/ericsson/enminst/bin/vcs.bsh --groups")
sg_list=$(echo "$vcs_cmd" | grep Grp_CS_..._cluster | awk '{print $2}' | sed 's/Grp_CS_..._cluster_//g' | sort | uniq)

for sg_short_name in ${sg_short_names};do
  if ! echo $sg_list | grep -q -w $sg_short_name;then
    sg_not_exist="$sg_not_exist $sg_short_name"
  fi
done
if [ ! -z "$sg_not_exist" ];then
  echo $date_time" ERROR check sg                      : These sg(s) is(are) not present $sg_not_exist"
  exit 1
else
  echo $date_time" INFO  check sg                      : All sgs are present ($sg_short_names)"
fi

for sg_short_name in ${sg_short_names};do

  #echo $(date "+%F %T.%3N")" INFO  getting list of hosts where $sg_short_name is running"
  vcs_sg=$(echo "$vcs_cmd" | grep "_$sg_short_name ")
  sg_hosts=$(echo "$vcs_sg" | awk '{print $3}' | tr '\n' ' ')
  sg_name=$(echo "$vcs_sg" | awk '{print $2}' | sort | uniq)
  echo $date_time" INFO  get sg hosts                  : $sg_name is running on $sg_hosts"
  if $quick_restart;then
    /usr/bin/ssh -o StrictHostKeyChecking=no -q root@$lms "/opt/ericsson/enminst/bin/vcs.bsh -g ${sg_name} --offline"
    for sg_host in $sg_hosts;do      
      if $undefine_vm;then
      vm=$(echo ${sg_name} | sed 's/Grp_CS_..._cluster_//g;s/_/-/g')  
      echo $date_time" INFO  undefine vm                   : Undefine vm $vm on $sg_host"
      /usr/bin/ssh -o StrictHostKeyChecking=no -q root@$lms "/root/rvb/bin/ssh_to_vm_and_su_root.exp $sg_host \"virsh undefine $vm\"" > /dev/null
      fi      
    done
    /usr/bin/ssh -o StrictHostKeyChecking=no -q root@$lms "/opt/ericsson/enminst/bin/vcs.bsh -g ${sg_name} --online"
  else
    for sg_host in $sg_hosts;do
#      echo $(date "+%F %T.%3N")" INFO  restarting $sg_name on $sg_host"
      /usr/bin/ssh -o StrictHostKeyChecking=no -q root@$lms "/opt/ericsson/enminst/bin/vcs.bsh -g ${sg_name} --offline -s $sg_host"
      if $undefine_vm;then
        vm=$(echo ${sg_name} | sed 's/Grp_CS_..._cluster_//g;s/_/-/g')  
        echo $date_time" INFO  undefine vm                   : Undefine vm $vm on $sg_host"
        /usr/bin/ssh -o StrictHostKeyChecking=no -q root@$lms "/root/rvb/bin/ssh_to_vm_and_su_root.exp $sg_host \"virsh undefine $vm\"" > /dev/null
      fi      
      /usr/bin/ssh -o StrictHostKeyChecking=no -q root@$lms "/opt/ericsson/enminst/bin/vcs.bsh -g ${sg_name} --online -s $sg_host"
    done
  fi
done

