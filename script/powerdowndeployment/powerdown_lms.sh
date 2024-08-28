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

echo "INFO: Download SED file from DMT"
downloadSedFile

"INFO: Get ilo ip address of LMS" 
lms_ilo_ip=$(getDataFromSed LMS_ilo_IP)

if [ -z "$lms_ilo_ip" ];then
  echo "ERROR: LMS ilo ip not found in sed file !"
  exit 1
fi

echo "INFO: Get ip address of LMS"
lms_ip=$(getDataFromSed LMS_IP)
if [ -z "$lms_ip" ];then
  echo "ERROR: LMS ip not found in sed file !"
  exit 1
fi

echo "INFO: LMS ilo ip: $lms_ilo_ip"
echo "INFO: LMS ip: $lms_ip"

if [ "$COLD_POWERDOWN" == "no" ];then
  echo "INFO: Shutdown of LMS host $lms_ip"
  echo "sshpass -p 12shroot ssh root@$lms_ip 'shutdown -h now'"
  sshpass -p 12shroot ssh root@$lms_ip 'shutdown -h now'
fi

echo "INFO: Power off LMS host $lms_ip (ilo ip -> $lms_ilo_ip)"
echo "curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"ForceOff\"}' -X POST https://$lms_ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
curl -s -L -k --user root:shroot12 -H "Content-Type: application/json" -d '{"ResetType": "ForceOff"}' -X POST https://$lms_ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset

checkNodeIsPowered $lms_ip $lms_ilo_ip

echo "INFO: Powerdown completed"
