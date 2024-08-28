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
HALT_ON_ERRORS=$2

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

echo "INFO: Power on LMS host $lms_ip (ilo ip -> $lms_ilo_ip)"
echo "sudo curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"On\"}' -X POST https://$lms_ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
#sudo curl -s -L -k --user root:shroot12 -H "Content-Type: application/json" -d '{"ResetType": "On"}' -X POST https://$lms_ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset

counter=1

echo "INFO: Checking if LMS is powered on ($counter of 3)"
echo "INFO: Waiting 10 seconds"
sleep 10

while [ $counter -le 3 ];do
  echo "INFO: Checking if LMS $lms_ip ($lms_ilo_ip) is powered on ($counter of 3)"
  power_state=$(sudo curl -s -L -k --user root:shroot12 -X GET https://$lms_ilo_ip/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
  #  echo "INFO: Node $node ($ilo_ip) $power_state"
  if [[ "$power_state" == *"On"* ]];then
    echo "INFO: LMS node $lms_ip ($lms_ilo_ip) has been powered on"
    break
  fi
  if [[ "$power_state" == *"On"* ]] && [[ $counter == '3' ]];then
    echo "ERROR: LMS node $lms_ip ($lms_ilo_ip) has not been powered on !"
  fi
  echo "INFO: Waiting 10 seconds"
  sleep 10
  ((counter++))
done

echo "INFO: Waiting 120 seconds for proper startup of LMS node"
sleep 120

counter=1
  while [ $counter -le 10 ];do
    echo "INFO: Checking status of LMS services ($counter of 10)"
    host_lms=$(sshpass -p 12shroot ssh -q root@$lms_ip "hostname")
    lms_ssh_output=$(sshpass -p 12shroot ssh -q root@$lms_ip "/opt/ericsson/enminst/bin/enm_healthcheck.sh --action system_service_healthcheck -v | grep $host_lms")
    if [ -z "$lms_ssh_output" ];then
      echo "ERROR: Command to get LMS services status failed!"
      if [ $HALT_ON_ERRORS = 'yes' ];then
        exit 1
      fi
    else
      echo "$lms_ssh_output"
    fi
    if [[ "$lms_ssh_output" != *"NOT RUNNING"* ]];then
      echo "INFO: All LMS services are started"
      break
    fi
    if [[ "$lms_ssh_output" == *"NOT RUNNING"* ]] && [[ $counter == '10' ]];then
      echo "ERROR: There are LMS services not properly started!"
      if [ $HALT_ON_ERRORS = 'yes' ];then
        exit 1
      fi
    fi
    sleep 10
    ((counter++))
  done


