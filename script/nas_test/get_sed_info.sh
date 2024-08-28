#!/bin/bash

DEPLOYMENT_ID=$1

. ./generic_functions_lib.sh


##MAIN

setVars



echo "INFO" "===== PHASE 1: DOWNLOAD SED FILE AND GET REQUIRED PARAMETERS ====="
if ! generateSed;then
  exit 1
fi

echo "INFO" "Get nas console info from sed file"
SFS_CONSOLE_IP=$(getNasConsoleIp)
if [[ $SFS_CONSOLE_IP == '1' ]];then
  exit 1
fi

SFSSETUP_USERNAME=$(getNasConsoleSetupUsername)
if [[ $SFS_CONSOLE_USERNAME == '1' ]];then
  exit 1
fi

SFSSETUP_PASSWORD=$(getNasConsoleSetupPassword)
if [[ $SFS_CONSOLE_PASSWORD == '1' ]];then
  exit 1
fi

LMS_IP=$(getLmsIp)
if [[ $LMS_IP == '1' ]];then
  exit 1
fi

NAS_ILO_IPS=$(getNasIloAddress $DEPLOYMENT_ID)
NAS_ILO_IP_1=$(echo $NAS_ILO_IPS | awk -F '|' '{print $1}')
NAS_ILO_IP_2=$(echo $NAS_ILO_IPS | awk -F '|' '{print $2}')

if [ -z "$NAS_ILO_IP_1" ] || [ -z "$NAS_ILO_IP_1" ];then
  echo "ERROR" "NAS ilo ip addresses have not been properly retrieved from DMT!"
  exit 1
fi

NAS_VIP_ENM_1=$(getNasVipEnm1)
if [[ $NAS_VIP_ENM_1 == '1' ]];then
  exit 1
fi

NAS_VIP_ENM_2=$(getNasVipEnm2)
if [[ $NAS_VIP_ENM_2 == '1' ]];then
  exit 1
fi


SAN_IP_A=$(getSanIpA)
if [[ $SAN_IP_A == '1' ]];then
  exit 1
fi

SAN_USER=$(getSanUser)
if [[ $SAN_USER == '1' ]];then
  exit 1
fi

SAN_PASSWORD=$(getSanPassword)
if [[ $SAN_PASSWORD == '1' ]];then
  exit 1
fi

SAN_TYPE=$(getSanType)
if [[ $SAN_TYPE == '1' ]];then
  exit 1
fi



echo "INFO" "NAS console ip: $SFS_CONSOLE_IP"
echo "INFO" "NAS console setup username: $SFSSETUP_USERNAME"
echo "INFO" "NAS console password: $SFSSETUP_PASSWORD"
echo "INFO" "LMS ip: $LMS_IP"
echo "INFO" "NAS ilo ip 1: $NAS_ILO_IP_1"
echo "INFO" "NAS ilo ip 2: $NAS_ILO_IP_2"
echo "INFO" "NAS vip enm 1: $NAS_VIP_ENM_1"
echo "INFO" "NAS vip enm 2: $NAS_VIP_ENM_2"
echo "INFO" "SAN ip A: $SAN_IP_A"
echo "INFO" "SAN user: $SAN_USER"
echo "INFO" "SAN password: $SAN_PASSWORD"
echo "INFO" "SAN type: $SAN_TYPE"
