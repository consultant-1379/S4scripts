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

#CLUSTER_ID=$1

. ./functions_lib.sh

CLUSTER_ID=$1


setVars

  echo "INFO: Download SED file from DMT"
  downloadSedFile

  echo "INFO: Checking DNS info in SED file"
  while IFS= read -r line;do
#    if [[ "$line" == *"_IP="* ]];then
#      echo $line
#    node=$(echo "$line" | awk '{print $1}')
#    ilo_ip=$(echo "$line" | awk '{print $2}')
#    echo "INFO: Power off node $node (ilo ip -> $ilo_ip)"
#    echo "curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"ForceOff\"}' -X POST https://$ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
#  fi
    line=$(echo $line | sed -e 's/^[[:space:]]*//')
    if [[ "$line" == *"_IP="* ]] || [[ "$line" == *"_IPv6="* ]] || [[ "$line" == *"_ipaddress="* ]] || [[ "$line" == *"_ipaddressv6="* ]];then
	    ip_address=$(echo $line | awk -F '=' '{print $2}')
      if [ ! -z "$ip_address" ];then 
        echo -n "   $line"
        nslookup $ip_address > /dev/null
	if [ $? -eq 0 ];then
	  echo -e " -> \033[1;30;32m[OK]\033[0m  ${@:2}"
	else
	  echo -e " -> \033[1;30;31m[NOK]\033[0m   ${@:2}"
	fi
      fi
  fi

#  if [[ "$line" == *"_ipaddress="* ]];then
#      echo $line
#  fi

#  if [[ "$line" == *"_ipaddressv6="* ]];then
#      echo $line
#  fi



  done < $SED_FILE

echo "INFO: Getting info about NAS from DMT"

nas_details=$(curl -s -L -k https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/deployment/getNasDetails/${CLUSTER_ID}/ | python -m json.tool)

echo "$nas_details" > ${CLUSTER_ID}nas_details.txt

echo "INFO: Checking DNS info for NAS"

while IFS= read -r line;do
  if [[ "$line" == *"ipAddress"* ]] || [[ "$line" == *"nasInstallIloIp"* ]] || [[ "$line" == *"nasVip"* ]];then
    line=$(echo $line | sed 's/"//g;s/,//g')
    ip_address=$(echo $line | awk '{print $2}')
    if [ ! -z "$ip_address" ];then
      echo -n "   $line"
        nslookup $ip_address > /dev/null
        if [ $? -eq 0 ];then
          echo -e " -> \033[1;30;32m[OK]\033[0m  ${@:2}"
        else
          echo -e " -> \033[1;30;31m[NOK]\033[0m   ${@:2}"
        fi
    fi
  fi
done < ${CLUSTER_ID}nas_details.txt 
      


