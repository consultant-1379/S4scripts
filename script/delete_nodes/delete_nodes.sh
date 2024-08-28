#!/bin/bash

NE_TYPE=$1

node_list=$(/opt/ericsson/enmutils/bin/cli_app "cmedit get * NetworkElement -neType=$NE_TYPE -t")

if [[ "$node_list" == *Error* ]];then
  echo $node_list
  exit 1
fi

node_list=$(echo $node_list | tr ' ' '\n' | tail -n +3 | head -n -2)

no_nodes_deleted=$(echo $node_list | wc -w)

echo "
 ============================================================================================
 SUMMARY OF NODES DELETION

 NODE TYPE: $NE_TYPE
 NUMBER OF NODES TO BE DELETED: $no_nodes_deleted
 ============================================================================================
"
#echo $node_list

sleep 10

for nodename in $node_list
do
    echo "DELETING NODE: $nodename"

        echo '/opt/ericsson/enmutils/bin/cli_app "cmedit set NetworkElement=$nodename,CmNodeHeartbeatSupervision=1 active=false"'
        echo '/opt/ericsson/enmutils/bin/cli_app "cmedit set NetworkElement=$nodename,FmAlarmSupervision=1 active=false"'
        echo '/opt/ericsson/enmutils/bin/cli_app "cmedit set NetworkElement=$nodename,InventorySupervision=1 active=false"'
        echo '/opt/ericsson/enmutils/bin/cli_app "cmedit set NetworkElement=$nodename,PmFunction=1 pmEnabled=false"'

        echo '/opt/ericsson/enmutils/bin/cli_app "cmedit action NetworkElement=$nodename,CmFunction=1 deleteNrmDataFromEnm "'
        echo '/opt/ericsson/enmutils/bin/cli_app "cmedit delete NetworkElement=$nodename -ALL"'
        echo '/opt/ericsson/enmutils/bin/cli_app "cmedit delete MeContext=$nodename -ALL"'
    echo " "
done
exit

