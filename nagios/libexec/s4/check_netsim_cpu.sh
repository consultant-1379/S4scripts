#!/bin/bash

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1

cluster_id=$(get_deployment_id_from_ms_ip $lms_ip)

config_file="${cluster_id}_configuration.sh"
tmp_file="/home/nagios/cpuidle.tmp"

source /usr/local/nagios/libexec/s4/$config_file

start_time=$(date -d '-20 min' +"%T")
end_time=$(date +"%T")

#netsims="ieatnetsimv5116-01 ieatnetsimv5116-118"


for netsim in $netsims;do
   sshpass -p 12shroot ssh -q nagios@$1 "sudo sshpass -p shroot ssh root@$netsim 'sar -u -s $start_time -e $end_time'" > $tmp_file
#  netsim_cpuidle=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo sshpass -p shroot ssh root@$netsim 'sar -u -s $start_time -e $end_time'" | tail -1 | awk '{print $8}')
#  netsim_cpuidle=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo sshpass -p shroot ssh root@$netsim sar -u 10 3 | tail -1" | awk '{print $8}')
#  netsim_cpuused=$((100-$netsim_cpuidle))

  cmd_status=$?


  #cat /tmp/cpuidle.tmp


  case "$cmd_status" in

    0)  
#     echo "sar command successful"
      netsim_cpuidle=$(cat $tmp_file | tail -1 | awk '{print $8}')
      netsim_cpuused=$(echo - | awk "{print 100 - $netsim_cpuidle}")
#     echo $netsim $netsim_cpuused
      if [[ "$netsim_cpuused" == 9[0-9]* ]] || [[ "$netsim_cpuused" == 100 ]];then
        netsims_cpuused="$netsims_cpuused $netsim: cpu $netsim_cpuused"
      fi 
      ;;
    127)
#     echo  "sar command not found"
      netsims_cpuused="$netsims_cpuused $netsim: Error sar command not found!"
      ;;
    *) 
#     echo "Error during execution of ssh command to $netsim $cmd_status"
      netsims_cpuused="$netsims_cpuused $netsim: Error ssh command to $netsim report code $cmd_status"
      ;;
  esac

done

#echo $netsims_cpuused

#netsims_cpuused="ieatnetsimv5116-01 95 ieatnetsimv5116-118 100"

    
if [[ "$netsims_cpuused" == *100* ]] || [[ "$netsims_cpuused" == *"Error"* ]];then
  echo "CRITICAL- CPU IS USED 100% OR ERROR WITH NETSIM IS PRESENT! | $netsims_cpuused"
  rm -rf $tmp_file
  exit 1
else
  if [[ "$netsims_cpuused" == *9[0-9]* ]];then
    echo "WARNING- CPU IS USED >90% | $netsims_cpuused"
    rm -rf $tmp_file
    exit 2
  else
   echo "OK- CPU IS USED $netsim_cpuused%"
   rm -rf $tmp_file
   exit 0
  fi
fi
