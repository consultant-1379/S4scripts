#!/bin/bash

NODES_LIST=$1
BULK_TASK=$2

CLI_APP_CMD="/opt/ericsson/enmutils/bin/cli_app"

turn_off_supervision(){
  echo "$FUNCNAME - $(date)"
  $CLI_APP_CMD "cmedit set NetworkElement=$nodename,CmNodeHeartbeatSupervision=1 active=false"
  $CLI_APP_CMD "cmedit set NetworkElement=$nodename,FmAlarmSupervision=1 active=false"
  $CLI_APP_CMD "cmedit set NetworkElement=$nodename,InventorySupervision=1 active=false"
  $CLI_APP_CMD "cmedit set NetworkElement=$nodename,PmFunction=1 pmEnabled=false"
}

delete_node(){
  echo "$FUNCNAME - $(date)"
  $CLI_APP_CMD "cmedit action NetworkElement=$nodename,CmFunction=1 deleteNrmDataFromEnm"
  $CLI_APP_CMD "cmedit delete NetworkElement=$nodename -ALL --force"
  $CLI_APP_CMD "cmedit delete MeContext=$nodename -ALL --force"
}

turn_off_supervision_bulk(){
  echo "$FUNCNAME - $(date)"
  $CLI_APP_CMD "cmedit set $nodename CmNodeHeartbeatSupervision active=false"
  $CLI_APP_CMD "fmedit set $nodename FmAlarmSupervision alarmSupervisionState=false"
  $CLI_APP_CMD "cmedit set $nodename InventorySupervision active=false"
  $CLI_APP_CMD "cmedit set $nodename PmFunction pmEnabled=false"
}

delete_node_bulk(){
  echo "$FUNCNAME - $(date)"
  $CLI_APP_CMD "cmedit action $nodename CmFunction deleteNrmDataFromEnm"
  $CLI_APP_CMD "cmedit delete $nodename NetworkElement.networkElementId==* -ALL"
  $CLI_APP_CMD "cmedit delete $nodename MeContext.meContextId==* -ALL"
}

#set -ex

if [ "$BULK_TASK" = "true" ];then
  echo "RUNNING DELETION OF NODES IN BULK MODE"
  for nodename in $NODES_LIST;do
    echo "DELETING NODES $nodename"
    turn_off_supervision_bulk
    delete_node_bulk
  done
else
  echo "RUNNING DELETION OF NODES IN NORMAL MODE"
  for nodename in $NODES_LIST;do
    echo "DELETING NODE $nodename"
    turn_off_supervision
    delete_node
  done
fi

echo "OPERATIONS COMPLETED - $(date)"
