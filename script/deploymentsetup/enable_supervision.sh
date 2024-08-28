#!/bin/bash

BASEDIR=`dirname $0`


enable_cm_supervision(){

  echo "$FUNCNAME - $(date)"
  echo "Enabling CM supervision in netype: $netype"
  /opt/ericsson/enmutils/bin/cli_app "cmedit set * CmNodeHeartbeatSupervision active=true --neType=$netype"
}

enable_fm_supervision(){

  echo "$FUNCNAME - $(date)"
  echo "Enabling FM supervision in all nodes"
  /opt/ericsson/enmutils/bin/cli_app "alarm enable *"
}

enable_pm_supervision(){

  echo "$FUNCNAME - $(date)"
  echo "Enabling FM supervision in netype: $netype"
  /opt/ericsson/enmutils/bin/cli_app "cmedit set * PmFunction pmEnabled=true --force --neType=$netype"

}

get_netypes_from_enm(){

  echo "$FUNCNAME - $(date)"
  echo "Getting list of netypes from ENM"
  netypes=$(/opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType -t' | grep -v "instance\|neType" | awk '{print $2}' | sort | uniq) 
  echo "Following netypes are present in ENM: $netypes"
}


set -ex

delay=30
get_netypes_from_enm

for netype in $netypes; do
  enable_cm_supervision
  echo "Waiting $delay seconds" 
  sleep $delay
  enable_pm_supervision
  echo "Waiting $delay seconds"
  sleep $delay
done  
enable_fm_supervision

echo "Operations Completed - $(date)"


