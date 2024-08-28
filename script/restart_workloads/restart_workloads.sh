#!/bin/bash

WORKLOAD_TO_RESTART=$1
WORKLOAD_COMMAND="/opt/ericsson/enmutils/bin/workload"
NODE_FILES_DIR="/opt/ericsson/enmutils/etc/nodes/"

stop_workload_profile(){

  echo "$FUNCNAME - $(date)"
  $WORKLOAD_COMMAND stop $profile --force-stop

}

start_workload_profile(){

  echo "$FUNCNAME - $(date)"
  $WORKLOAD_COMMAND start $profile

}

is_profile_stopped(){

  echo "$FUNCNAME - $(date)"
  profile_stopped=$($WORKLOAD_COMMAND status $profile | grep "not running" | wc -l)

}

#set -x
#set -o functrace



for profile in $WORKLOAD_TO_RESTART;do
  echo "******** PROCESSING WORKLOAD PROFILE: $profile ****************************************************" 
  stop_workload_profile
  for ((c=1; c<24; c+=1));do
    sleep 5
    is_profile_stopped
    if [ "$profile_stopped" -eq "1" ];then
      break
    fi
    if [ "$c" -eq "23" ];then
      unstopped_profiles="$unstopped_profiles $profile"
      break
    fi
  done
  if [ "$c" -ne "23" ];then
    start_workload_profile
  fi
done
echo "The following profiles have not been started: $unstopped_profiles"
exit 0
