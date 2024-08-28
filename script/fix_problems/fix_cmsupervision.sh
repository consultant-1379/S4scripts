#!/bin/bash
NE_TYPES=$1

CLI_CMD="/opt/ericsson/enmutils/bin/cli_app"


for ne_type in $NE_TYPES;do
  echo "TURN ON CM SUPERVISION ON NETYPE: $ne_type"
  no_cm_supervision_off=$($CLI_CMD "cmedit get * CmNodeHeartbeatSupervision.active==false -neType=$ne_type --count")
  echo "NUMBER OF $ne_type NODES WITH CM SUPERVISION OFF: $no_cm_supervision_off"
  ne_cm_supervision_off_list=$($CLI_CMD "cmedit get * CmNodeHeartbeatSupervision.active==false -neType=$ne_type -t" | grep false | awk '{print $1}')

  for ne_cm_supervision_off in $ne_cm_supervision_off_list;do
    echo "ENABLING CM SUPERVISION FOR NODE: $ne_cm_supervision_off"
    $CLI_CMD "cmedit set $ne_cm_supervision_off CmNodeHeartbeatSupervision active=true -neType=$ne_type"
  done
  no_cm_supervision_off=$($CLI_CMD "cmedit get * CmNodeHeartbeatSupervision.active==false -neType=$ne_type --count")
  echo "NUMBER OF $ne_type NODES WITH CM SUPERVISION OFF: $no_cm_supervision_off"
done
