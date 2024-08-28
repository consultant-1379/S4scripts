#!/bin/bash
NE_TYPES=$1

CLI_CMD="/opt/ericsson/enmutils/bin/cli_app"


for ne_type in $NE_TYPES;do
  echo "TURN ON FM SUPERVISION ON NETYPE: $ne_type"
  no_fm_supervision_off=$($CLI_CMD "cmedit get * FmAlarmSupervision.active==false -neType=$ne_type --count" | awk '{print $1}')
  if [ "$no_fm_supervision_off" -eq "0" ];then
    echo "NO $ne_type WITH FM SUPERVISION OFF ARE PRESENT !" 
    exit 0
  fi
  echo "NUMBER OF $ne_type NODES WITH FM SUPERVISION OFF: $no_fm_supervision_off"
  ne_fm_supervision_off_list=$($CLI_CMD "cmedit get * FmAlarmSupervision.active -neType=$ne_type -t" | grep false | awk '{print $1}')

  for ne_fm_supervision_off in $ne_fm_supervision_off_list;do
    echo "ENABLING FM SUPERVISION FOR NODE: $ne_fm_supervision_off"
    sleep 2
    $CLI_CMD "alarm enable $ne_fm_supervision_off"
  done
  no_fm_supervision_off=$($CLI_CMD "cmedit get * FmAlarmSupervision.active==false -neType=$ne_type --count")
  echo "NUMBER OF $ne_type NODES WITH FM SUPERVISION OFF: $no_fm_supervision_off"
done
