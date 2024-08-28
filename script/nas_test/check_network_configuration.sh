#!/bin/bash

#set -x

DEPLOYMENT_ID=$1

. ./nas_functions_lib.sh


##MAIN

setVars

echo "INFO" "Check network configuration of VA ($SFS_CONSOLE_IP)"
network_va_bonding=$(get_va_bonding $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP)

if [[ "$network_va_bonding" == *"bond"* ]];then
  echo "INFO" "Nas uses 10G network interfaces"
else
  echo "INFO" "Nas uses 1G network interfaces"
fi

#set -x
#is_version_installed $ERICNASCONFIG $nas_config_version $NAS_CONFIG_VERSION_EXPECTED
#status=$?
#if [ $status = 0 ];then
#  echo "$ERICNASCONFIG $nas_ip $nas_host $nas_config_install"
#fi
#if [ $status = 1 ];then
#  exit 0
#fi
#set +x

