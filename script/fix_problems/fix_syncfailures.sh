#!/bin/bash
NE_TYPES=$1
NE_LIST=$2

CLI_CMD="/opt/ericsson/enmutils/bin/cli_app"


for ne_type in $NE_TYPES;do
  echo "EXECUTING W/A TO FIX SYNCH FAILURES PROBLEMS ON NETYPE: $ne_type"
  if [ -z "$NE_LIST" ];then
    no_unsyn_nodes=$($CLI_CMD "cmedit get * CmFunction.syncStatus!=SYNCHRONIZED --neType=$ne_type -t" | grep 'UNSYNCHRONIZED\|TOPOLOGY\|DELTA\|PENDING' | wc -l)
    echo "NUMBER OF $ne_type NODES WITH SYNCH FAILURES BEFORE EXECUTING THE W/A: $no_unsyn_nodes"
    unsyn_node_list=$($CLI_CMD "cmedit get * CmFunction.syncStatus!=SYNCHRONIZED --neType=$ne_type -t" | grep 'UNSYNCHRONIZED\|TOPOLOGY\|DELTA\|PENDING' | awk '{print $1}')
  else
    unsyn_node_list=$NE_LIST
  fi

  for unsyn_node in $unsyn_node_list;do
    echo "TOGGLING CM SUPERVISION FOR NODE: $unsyn_node"
    $CLI_CMD "cmedit set $unsyn_node CmNodeHeartbeatSupervision active=false"
    $CLI_CMD "cmedit set $unsyn_node CmNodeHeartbeatSupervision active=true"
    $CLI_CMD "cmedit action $unsyn_node CmFunction sync"
  done
  no_unsyn_nodes=$($CLI_CMD "cmedit get * CmFunction.syncStatus!=SYNCHRONIZED --neType=$ne_type -t" | grep 'UNSYNCHRONIZED\|TOPOLOGY\|DELTA\|PENDING' | wc -l)
  echo "NUMBER OF $ne_type NODES WITH SYNCH FAILURES AFTER EXECUTING THE W/A: $no_unsyn_nodes"
done
