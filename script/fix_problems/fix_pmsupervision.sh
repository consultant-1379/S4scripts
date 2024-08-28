#!/bin/bash
NE_TYPES=$1

CLI_CMD="/opt/ericsson/enmutils/bin/cli_app"


for ne_type in $NE_TYPES;do
  echo "TURN ON PM SUPERVISION ON NETYPE: $ne_type"
  no_pm_supervision_off=$($CLI_CMD "cmedit get * PmFunction.pmEnabled==false -neType=$ne_type --count")
  echo "NUMBER OF $ne_type NODES WITH PM SUPERVISION OFF: $no_pm_supervision_off"
  ne_pm_supervision_off_list=$($CLI_CMD "cmedit get * PmFunction.pmEnabled==false -neType=$ne_type -t" | grep false | awk '{print $1}')

  for ne_pm_supervision_off in $ne_pm_supervision_off_list;do
    echo "ENABLING PM SUPERVISION FOR NODE: $ne_pm_supervision_off"
    $CLI_CMD "cmedit set * PmFunction pmEnabled=true --force -neType=$ne_type"
  done
  no_pm_supervision_off=$($CLI_CMD "cmedit get * PmFunction.pmEnabled==false -neType=$ne_type --count")
  echo "NUMBER OF $ne_type NODES WITH PM SUPERVISION OFF: $no_pm_supervision_off"
done
