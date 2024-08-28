#!/bin/bash

WORKLOAD_TO_STOP="$1"
WORKLOAD_COMMAND="/opt/ericsson/enmutils/bin/workload"
NODE_FILES_DIR="/opt/ericsson/enmutils/etc/nodes/"

stop_workload_profile(){

  echo "$FUNCNAME - $(date)"
  $WORKLOAD_COMMAND stop $profile --force-stop
  return $?

}

is_profile_stopped(){

  echo "$FUNCNAME - $(date)"
  profile_stopped=$($WORKLOAD_COMMAND status $profile | grep "not running" | wc -l)

}

#set -x
#set -o functrace



for profile in $WORKLOAD_TO_STOP;do
  echo "******** PROCESSING WORKLOAD PROFILE: $profile ****************************************************" 
  stop_workload_profile
  ret_value=$?
  if [ $ret_value -ne 0 ];then
    echo "******** PROFILE $profile CANNOT BE STOPPED"
#    break
  else	  
  for ((c=1; c<24; c+=1));do
    sleep 5
    is_profile_stopped
    if [ "$profile_stopped" -eq "1" ];then
      break
    fi
    if [ "$c" -eq "23" ];then
      echo "******* PROFILE: $profile HAS NOT BEEN STOPPED WITHIN 120 SEC. CONTINUING WITH NEXT PROFILE TO STOP ...."
      unstopped_profiles="$unstopped_profiles $profile"
      break
    fi
  done
  fi
#  if [ "$c" -ne "23" ];then
#    start_workload_profile
#  fi
done

#echo "PROFILES${unstopped_profiles}UNSTOPPED"

if [ ! -z "$unstopped_profiles" ];then
  echo "******** WAITING STOPPING OF PROFILES FOR ADDITIONAL 120 SEC ..."
  sleep 120
  for profile in $unstopped_profiles;do
    is_profile_stopped
    if [ "$profile_stopped" -eq "1" ];then
      break
    else
      still_unstopped_profiles="$still_unstopped_profiles $profile"
      break
    fi
  done
fi

#echo "PROFILES${still_unstopped_profiles}STILLUNSTOPPED"

if [ -z "$still_unstopped_profiles" ];then
  echo "******** ALL WORKLOAD PROFILES HAVE BEEN SUCCESSFULLY STOPPED"
  exit 0
else
  echo "******** FOLLOWING WORKLOAD PROFILES HAVE NOT BEEN STOPPED: $still_unstopped_profiles"
  exit 1
fi
