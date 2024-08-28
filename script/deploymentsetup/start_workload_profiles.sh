#!/bin/bash

PROFILES=$1
WORKLOAD_COMMAND="/opt/ericsson/enmutils/bin/workload"

start_workload_profiles(){

  echo "$FUNCNAME - $(date)"
  echo "Start workload profiles on WORKLOAD_SERVER"
  echo $PROFILES
  $WORKLOAD_COMMAND start $PROFILES

}

set -ex
start_workload_profiles
