#!/bin/bash
# NAS Upgrade Patch Script
# ********************************************************************
# Ericsson Radio Systems AB                                     SCRIPT
# ********************************************************************
#
#
# (c) Ericsson Radio Systems AB 2021 - All rights reserved.
#
# The copyright to the computer program(s) herein is the property
# of Ericsson Radio Systems AB, Sweden. The programs may be used
# and/or copied only with the written permission from Ericsson Radio
# Systems AB or in accordance with the terms and conditions stipulated
# in the agreement/contract under which the program(s) have been
# supplied.
#
# ********************************************************************
# Name    : upgrade_va_rhel_patches.bsh
# Date    : 15/12/2021
# Revision: A
# Purpose : This script performs upgrade of NAS RHEL patches
#
#
# Version Information:
#       Version Who             Date            Comment
#       0.1     estmann         15/12/2021      Initial draft
#
# Usage   : "upgrade_va_rhel_patches.bsh -h" to give usage
#
# ********************************************************************

CLUSTER_ID=$1
COLD_POWERDOWN=$2

. ./functions_lib.sh

echo "INFO: Setting global variables"

setVars

## Begin of powerdown NAS
echo "INFO: Download SED file from DMT"
downloadSedFile

echo "INFO: Get ILO ip addresses of NAS nodes"
nas_details=$(curl -s -L -k https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/deployment/getNasDetails/${CLUSTER_ID}/ | python -m json.tool)
nas_ilo_ip1=$(echo "$nas_details" | grep "nasInstallIloIp1" | awk '{print $2}' | sed 's/"//g' | sed 's/,//g')
if [ -z "$nas_ilo_ip1" ];then
  echo "ERROR: NAS ilo ip1 not found in dmt !"
  exit 1
fi
nas_ilo_ip2=$(echo "$nas_details" | grep "nasInstallIloIp2" | awk '{print $2}' | sed 's/"//g' | sed 's/,//g')
if [ -z "$nas_ilo_ip2" ];then
  echo "ERROR: NAS ilo ip1 not found in dmt !"
  exit 1
fi

echo "INFO: Get nas console info from sed file"
if ! sfs_console_ip=$(getNasConsoleIp);then
  echo "ERROR: NAS console ip not found in sed file !" 
  exit 1
fi

if ! sfssetup_username=$(getNasConsoleSetupUsername);then
  echo "ERROR: NAS console username not found in sed file !"
  exit 1
fi

if ! sfssetup_password=$(getNasConsoleSetupPassword);then
  echo "ERROR: NAS console password not found in sed file !"
  exit 1
fi

echo "INFO: NAS console ip: $sfs_console_ip"
echo "INFO: NAS console setup username: $sfssetup_username"
echo "INFO: NAS console password: $sfssetup_password"
echo "INFO: NAS ilo ip 1: $nas_ilo_ip1"
echo "INFO: NAS ilo ip 2: $nas_ilo_ip2"


echo "INFO: Identify Master and Slave roles/ips of the nas hosts"
nas_master_host=$(identify_nas_role $sfssetup_username $sfssetup_password $sfs_console_ip 'Master')
nas_slave_host=$(identify_nas_role $sfssetup_username $sfssetup_password $sfs_console_ip 'Slave')

echo "INFO: NAS master host $nas_master_host"
echo "INFO: NAS slave host $nas_slave_host"
if [ "$COLD_POWERDOWN" == "no" ];then
  echo "INFO: Shutdown nas slave host $nas_slave_host"
  shutdown_nas_host $sfssetup_username $sfssetup_password $sfs_console_ip $nas_slave_host
  echo "INFO: Waiting 60 seconds to complete shutdown of nas slave host $nas_slave_host"
  sleep 60
  echo "INFO: Shutdown nas master host $nas_master_host"
  shutdown_nas_host $sfssetup_username $sfssetup_password $sfs_console_ip $nas_master_host
  echo "INFO: Waiting 60 seconds to complete shutdown of nas master host $nas_master_host"
  sleep 60
fi

#VAR='GNU/Linux is an operating system'
if [[ $nas_master_host == *"01"* ]];then
  nas_ilo_master=$nas_ilo_ip1
  nas_ilo_slave=$nas_ilo_ip2
else
  nas_ilo_master=$nas_ilo_ip2
  nas_ilo_slave=$nas_ilo_ip1
fi  

echo "INFO: Power off Slave node $nas_slave_host (ilo ip -> $nas_ilo_slave)"
echo "curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"ForceOff\"}' -X POST https://$nas_ilo_slave/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
curl -s -L -k --user root:shroot12 -H "Content-Type: application/json" -d '{"ResetType": "ForceOff"}' -X POST https://$nas_ilo_slave/redfish/v1/Systems/1/Actions/ComputerSystem.Reset


echo "INFO: Power off Master node $nas_master_host (ilo ip -> $nas_ilo_master)"
echo "curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"ForceOff\"}' -X POST https://$nas_ilo_master/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
curl -s -L -k --user root:shroot12 -H "Content-Type: application/json" -d '{"ResetType": "ForceOff"}' -X POST https://$nas_ilo_master/redfish/v1/Systems/1/Actions/ComputerSystem.Reset


checkNodeIsPowered $nas_slave_host $nas_ilo_slave
#if [ $? -ne 0 ];then
#  echo "ERROR: $nas_slave_host is still powered !"
#fi

checkNodeIsPowered $nas_master_host $nas_ilo_master

echo "INFO: Powerdown completed"
