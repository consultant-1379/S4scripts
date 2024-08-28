#!/bin/bash

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1

cluster_id=$(get_deployment_id_from_ms_ip $lms_ip)

config_file="${cluster_id}_configuration.sh"

source /usr/local/nagios/libexec/s4/$config_file

start_time=$(date -d '-20 min' +"%T")
end_time=$(date +"%T")
tmp_file="/home/nagios/netsim_fs_check.tmp"

netsims="ieatnetsimv5116-15"


for netsim in $netsims;do
   sshpass -p 12shroot ssh -q nagios@$1 "sudo sshpass -p shroot ssh root@$netsim 'df -h'" > $tmp_file
#  netsim_cpuidle=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo sshpass -p shroot ssh root@$netsim 'sar -u -s $start_time -e $end_time'" | tail -1 | awk '{print $8}')
#  netsim_cpuidle=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo sshpass -p shroot ssh root@$netsim sar -u 10 3 | tail -1" | awk '{print $8}')
#  netsim_cpuused=$((100-$netsim_cpuidle))

  cmd_status=$?


  #cat /tmp/cpuidle.tmp


  case "$cmd_status" in

    0)  
#     echo "sar command successful"
      netsim_fs=$(cat $tmp_file  | awk '{print $5}')
#      echo "$netsim_fs"
#      if [[ "$netsim_fs" == *9[0-9]%* ]] || [[ "$netsim_fs" == *100%* ]];then

      if [[ "$netsim_fs" == *9[0-9]%* ]];then
      
        netsims_fs_status="$netsim_fs_status $netsim: >90%"
      fi 
      if [[ "$netsim_fs" == *100%* ]];then
        
        netsims_fs_status="$netsim_fs_status $netsim: 100%"
      fi
      ;;
    *) 
#     echo "Error during execution of ssh command to $netsim $cmd_status"
      netsims_fs_status="$netsims_fs_status $netsim: Error ssh command to $netsim report code $cmd_status"
      ;;
  esac

done

#echo $netsims_cpuused

#netsims_cpuused="ieatnetsimv5116-01 95 ieatnetsimv5116-118 100"

    
if [[ "$netsims_fs_status" == *100* ]] || [[ "$netsims_fs_status" == *"Error"* ]];then
  echo "CRITICAL- FILESYSTEM IS USED 100% OR ERROR WITH NETSIM IS PRESENT! | $netsims_fs_status"
  rm -rf $tmp_file
  exit 1
else
  if [[ "$netsims_fs_status" == *9[0-9]* ]];then
    echo "WARNING- FILESYSTEM IS USED >90% | $netsims_fs_status"
    rm -rf $tmp_file
    exit 2
  else
   echo "OK- FILESYSTEM OF ALL NETSIM VMs IS USED <90%"
   rm -rf $tmp_file
   exit 0
  fi
fi
