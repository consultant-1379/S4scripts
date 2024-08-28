#!/bin/bash
NE_TYPES=$1
NE_LIST=$2

CLI_CMD="/opt/ericsson/enmutils/bin/cli_app"


for ne_type in $NE_TYPES;do
  echo "EXECUTING W/A TO FIX HEART BEAT FAILURES PROBLEMS ON NETYPE: $ne_type"
  if [ -z "$NE_LIST" ];then
    no_hb_failures=$($CLI_CMD "cmedit get * FmFunction.currentServiceState==HEART_BEAT_FAILURE --neType=$ne_type --count")
    echo "NUMBER OF $ne_type NODES WITH HEART BEAT FAILURES BEFORE EXECUTING THE W/A: $no_hb_failures"

    ne_hb_failures_list=$($CLI_CMD "cmedit get * FmFunction.currentServiceState==HEART_BEAT_FAILURE --neType=$ne_type -t" | grep HEART_BEAT_FAILURE | awk '{print $1}')
  else
    ne_hb_failures_list=$NE_LIST
  fi
 
  for ne_hb_failures in $ne_hb_failures_list;do
    echo "TOGGLING ALARM SUPERVISION FOR NODE: $ne_hb_failures"
    $CLI_CMD "alarm disable $ne_hb_failures"
    sleep 2
    $CLI_CMD "alarm enable $ne_hb_failures"
  done
  no_hb_failures=$($CLI_CMD "cmedit get * FmFunction.currentServiceState==HEART_BEAT_FAILURE --neType=$ne_type --count")
  echo "NUMBER OF $ne_type NODES WITH HEART BEAT FAILURES AFTER EXECUTING THE W/A: $no_hb_failures"
done
