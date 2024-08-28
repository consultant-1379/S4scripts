#!/bin/bash

WORKLOAD_COMMAND="/opt/ericsson/enmutils/bin/workload"
DELAY="60"
ITERATIONS="60"

get_workload_categories(){
  local categories
  categories=$($WORKLOAD_COMMAND category --no-ansi | tail -1 | sed 's/,//g' | sed 's/Categories: //g')
  echo "$categories"
}

stop_workload_profiles_by_category(){
  local category
  local categories=$1
  echo $categories
  echo "$FUNCNAME - $(date)"
  for category in $categories;do
    echo "Stop workload profiles of category $category on WORKLOAD_SERVER"
    stop_workload_profile_by_category $category
  done
}

stop_workload_profile_by_category(){
  local category=$1
  echo "$FUNCNAME - $(date)"
  $WORKLOAD_COMMAND stop $category --category --force-stop &
}

stop_all_workload_profiles(){

  echo "$FUNCNAME - $(date)"
  $WORKLOAD_COMMAND stop all --force-stop
}

check_running_profiles(){
  local active_profiles
  active_profiles=$($WORKLOAD_COMMAND status --no-ansi | grep "SLEEPING\|COMPLETED\|RUNNING\|STARTING\|STOPPING\|DEAD" | awk '{print $1}' | sort)
  echo $active_profiles
}

tear_down_workload_profiles(){
  echo "$FUNCNAME - $(date)"

  echo "Perform hard shutdown of workload on WORKLOAD_SERVER, in case not already done"
  echo "1. Kill all profile daemon processes running on WORKLOAD_SERVER"
  workload_pids=$(ps -ef | grep daemon | awk '{print $2}')
  kill -9 $workload_pids
  echo "2. Remove PID files associated to profiles"
  rm -rf /var/tmp/enmutils/daemon/*pid
}

set -ex
#categories=$(get_workload_categories)

#stop_workload_profiles_by_category "$categories"

stop_all_workload_profiles

count=1
total_delay_sec=$(( DELAY * ITERATIONS ))

while true;do
  echo "*********Iteration $count"
  active_profiles=$(check_running_profiles)

  if [ "$count" -gt "$ITERATIONS" ];then
    echo "Exiting after $total_delay_sec delay !"
    echo "There are profiles still active:"
    echo "$active_profiles"
    echo "Executing a forced teardown of existing workload profiles by killing processes!"
    tear_down_workload_profiles
    break
  fi
  if [ -z "$active_profiles" ];then
    echo "All workload profiles have been stopped"
    break
  else
    echo "There are workload profiles still active:"
    echo "$active_profiles"
  fi
  sleep $DELAY
  count=$(( count + 1 ))
done
exit 0
