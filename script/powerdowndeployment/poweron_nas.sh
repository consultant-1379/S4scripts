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

. ./functions_lib.sh

#echo "INFO: Setting global variables"

setVars

## Begin of poweron NAS
echo "INFO: Download SED file from DMT"
downloadSedFile

echo "INFO: Get ILO ip addresses of NAS nodes"
nas_details=$(sudo curl -s -L -k https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/deployment/getNasDetails/${CLUSTER_ID}/ | python -m json.tool)
nas_type=$(echo "$nas_details" | grep "nasType" | awk '{print $2}' | sed 's/"//g' | sed 's/,//g')
if [ -z "$nas_type" ];then
  echo "ERROR: Problems getting NAS type from dmt !"
  exit 1
fi
if [[ "$nas_type" == *"unity"* ]];then
  echo "ERROR: NAS power on is not supported for $nas_type"
  exit 1
fi

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

echo "INFO: NAS ilo ip 1: $nas_ilo_ip1"
echo "INFO: NAS ilo ip 2: $nas_ilo_ip2"

echo "INFO: Power on NAS node 1 (ilo ip -> $nas_ilo_ip1)"
echo "sudo curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"On\"}' -X POST https://$nas_ilo_ip1/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
#sudo curl -s -L -k --user root:shroot12 -H "Content-Type: application/json" -d '{"ResetType": "On"}' -X POST https://$nas_ilo_ip1/redfish/v1/Systems/1/Actions/ComputerSystem.Reset

counter=1

echo "INFO: Checking if NAS $nas_ilo_ip1 is powered on ($counter of 3)"
echo "INFO: Waiting 10 seconds"
sleep 10
while [ $counter -le 3 ];do
  echo "INFO: Checking if NAS $nas_ilo_ip1 is powered on ($counter of 3)"
  power_state=$(sudo curl -s -L -k --user root:shroot12 -X GET https://$nas_ilo_ip1/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
  #  echo "INFO: Node $node ($ilo_ip) $power_state"
  if [[ "$power_state" == *"On"* ]];then
    echo "INFO: NAS node $nas_ilo_ip1 has been powered on"
    break
  fi
  if [[ "$power_state" == *"On"* ]] && [[ $counter == '3' ]];then
    echo "ERROR: NAS node $nas_ilo_ip1 has not been powered on !"
  fi
  echo "INFO: Waiting 10 seconds"
  sleep 10
  ((counter++))
done

echo "INFO: Power on NAS node 2 (ilo ip -> $nas_ilo_ip2)"
echo "sudo curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"On\"}' -X POST https://$nas_ilo_ip2/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
#sudo curl -s -L -k --user root:shroot12 -H "Content-Type: application/json" -d '{"ResetType": "On"}' -X POST https://$nas_ilo_ip2/redfish/v1/Systems/1/Actions/ComputerSystem.Reset
counter=1
echo "INFO: Checking if NAS $nas_ilo_ip2 is powered on ($counter of 3)"
echo "INFO: Waiting 10 seconds"
sleep 10
while [ $counter -le 3 ];do
  echo "INFO: Checking if NAS $nas_ilo_ip2 is powered on ($counter of 3)"
  power_state=$(sudo curl -s -L -k --user root:shroot12 -X GET https://$nas_ilo_ip2/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
  #  echo "INFO: Node $node ($ilo_ip) $power_state"
  if [[ "$power_state" == *"On"* ]];then
    echo "INFO: NAS node $nas_ilo_ip2 has been powered on"
    break
  fi
  if [[ "$power_state" == *"On"* ]] && [[ $counter == '3' ]];then
    echo "ERROR: NAS node $nas_ilo_ip2 has not been powered on !"
  fi
  echo "INFO: Waiting 10 seconds"
  sleep 10
  ((counter++))
done

echo "INFO: Waiting 60 seconds for proper startup of NAS nodes"
sleep 60

echo "INFO: Get ip address of LMS"
lms_ip=$(getDataFromSed LMS_IP)
if [ -z "$lms_ip" ];then
  echo "ERROR: LMS ip not found in sed file !"
  exit 1
fi

echo "INFO: LMS ip: $lms_ip"

#counter=1
#while [ $counter -le 2 ];do
  echo "INFO: Checking status of NAS"
  host_lms=$(sshpass -p 12shroot ssh -q root@$lms_ip "hostname")
  lms_ssh_output=$(sshpass -p 12shroot ssh -q root@$lms_ip "/opt/ericsson/enminst/bin/enm_healthcheck.sh --action nas_healthcheck")
  if [ -z "$lms_ssh_output" ];then
    echo "ERROR: Command to execute NAS healthchecks failed!"
  else
    echo "$lms_ssh_output"
  fi
  if [[ "$lms_ssh_output" == *"Successfully"* ]];then
    echo "INFO: NAS healthchecks have been successfully passed"
#    break
  else
    echo "ERROR: NAS healthchecks have failed!"
  fi
#  if [[ "$vcs_cmd_output" != *"Successfully"* ]] && [[ $counter == '2' ]];then
#    echo "ERROR: NAS healthchecks have failed!"
#  fi
#  sleep 10
#  ((counter++))
#done

