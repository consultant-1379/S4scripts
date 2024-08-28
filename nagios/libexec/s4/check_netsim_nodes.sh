#!/bin/bash -x

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1

cluster_id=$(get_deployment_id_from_ms_ip $lms_ip)

config_file="${cluster_id}_configuration.sh"

source /usr/local/nagios/libexec/s4/$config_file

start_time=$(date -d '-20 min' +"%T")
end_time=$(date +"%T")
tmp_file="/home/nagios/check_netsim_nodes.sh.tmp"

#netsims="ieatnetsimv5116-01 ieatnetsimv5116-02"

for netsim in $netsims;do
   sshpass -p 12shroot ssh -q nagios@$1 "sudo sshpass -p netsim ssh netsim@$netsim 'echo .show allsimnes | /netsim/inst/netsim_pipe'" > $tmp_file
#  netsim_cpuidle=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo sshpass -p shroot ssh root@$netsim 'sar -u -s $start_time -e $end_time'" | tail -1 | awk '{print $8}')
#  netsim_cpuidle=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo sshpass -p shroot ssh root@$netsim sar -u 10 3 | tail -1" | awk '{print $8}')
#  netsim_cpuused=$((100-$netsim_cpuidle))

  cmd_status=$?


  #cat /tmp/cpuidle.tmp


  case "$cmd_status" in

    0)  
#     echo "sar command successful"
      netsim_stopped_nodes=$(cat $tmp_file | grep "not started" | wc -l)
#     echo $netsim $netsim_cpuused
      if [[ "$netsim_stopped_nodes" != 0 ]];then
        netsims_stopped_nodes="$netsims_stopped_nodes $netsim: $netsim_stopped_nodes"
      fi 
      ;;
    *) 
#     echo "Error during execution of ssh command to $netsim $cmd_status"
      netsims_stopped_nodes="$netsims_stopped_nodes $netsim: Error ssh command to $netsim report code $cmd_status"
      ;;
  esac

done

#echo $netsims_cpuused

#netsims_cpuused="ieatnetsimv5116-01 95 ieatnetsimv5116-118 100"

    
if [[ "$netsims_stopped_nodes" == *ieatnetsim* ]] && [[ "$netsims_stopped_nodes" == *"Error"* ]];then
  echo "CRITICAL- THERE ARE STOPPED NODES OR ERROR WITH NETSIM IS PRESENT! | $netsims_stopped_nodes"
  rm -rf $tmp_file
  exit 2
else
  if [[ "$netsims_stopped_nodes" == *ieatnetsim* ]];then
    echo "WARNING- THERE ARE STOPPED NODES | $netsims_stopped_nodes"
    rm -rf $tmp_file
    exit 1
  else
   echo "OK- NO STOPPED NODES ARE PRESENT"
   rm -rf $tmp_file
   exit 0
  fi
fi
