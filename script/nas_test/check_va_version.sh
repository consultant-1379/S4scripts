#!/bin/bash

DEPLOYMENT_ID=$1

. ./nas_functions_lib.sh


##MAIN

setVars

echo "INFO" "Check installed nas config version on host: $SFS_CONSOLE_IP"
nas_va_version=$(get_va_version $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP)
if [ -z "$nas_va_version" ];then
  echo "ERROR" "Nas VA version not properly detected!"
  exit 1
fi
echo $nas_va_version

if [[ "$nas_va_version" == *"7.4.1.200"* ]];then
  echo "INFO" "Nas VA version is correct ($nas_va_version)"
else
  echo "ERROR" "Nas VA version is wrong !"
  exit 1
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

