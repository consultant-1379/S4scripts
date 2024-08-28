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

. ./functions_lib.sh

CheckNASHostStatus(){
logOut "INFO" "Check that nas host $nas_host ($nas_ip) is alive"
if ! check_nas_host_alive $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip;then
  logOut "ERROR" "Host $nas_host ($nas_ip) did not startup within 10 minutes!"
  exit 1
else
  logOut "INFO" "Host $nas_host ($nas_ip) is alive"
fi
logOut "INFO" "Check that nas host $nas_host ($nas_ip) has joined the cluster"
until [[ "$nas_slave_state" == "RUNNING" ]];do
  nas_slave_state=$(check_nas_host_state $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP $nas_host)
  sleep 20
  ((counter++))
  if [ $counter -gt 30 ];then
    logOut "INFO" "Host $nas_host did not rejoin cluster within 10 minutes!"
    exit 1
  fi
done
logOut "INFO" "Host $nas_host has joined the cluster"
cluster_status=$(show_cluster_summary $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP)
echo "$cluster_status"

if ! postUpgradeNASChecks $nas_ip;then
  logOut "ERROR" "Check of NAS services failed on host $nas_ip"
else
  logOut "INFO" "Check of NAS services successfully passed on host $nas_ip"
fi

}

upgrade_nas_host(){
local nas_patch_ip_type=$1
logOut "INFO" "${GREEN}Execute upgrade of host $nas_host ($nas_ip)$NC"
if cat nas_upgrade_tasks | grep $nas_ip | grep -q $ERICNASCONFIG;then
  logOut "INFO" "Install $ERICNASCONFIG-$NAS_CONFIG_VERSION_EXPECTED.tar.gz on host $nas_host ($nas_ip)"
  if install_nas_config $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip;then
    logOut "INFO" "$ERICNASCONFIG-$NAS_CONFIG_VERSION_EXPECTED.tar.gz on host has been successfully installed on host $nas_host ($nas_ip)"
  else
    logOut "INFO" "Installation of $ERICNASCONFIG-$NAS_CONFIG_VERSION_EXPECTED.tar.gz on host $nas_host ($nas_ip) has failed!"
    exit 1
  fi
fi

logOut "INFO" "Summary of network interfaces status"
nas_interfaces_status=$(show_nas_ip_config $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP)
echo "$nas_interfaces_status"
logOut "INFO" "Identify vip interfaces on host $nas_host ($nas_ip)"
vip_interfaces=$(identify_nas_vip_interface $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP $nas_host)
logOut "INFO" "Vip interfaces of host $nas_host ($nas_ip): $vip_interfaces"
logOut "INFO" "Move vip interfaces from host $nas_host ($nas_ip) to $nas_other_host"
for vip_interface in $vip_interfaces;do
  if ! move_nas_vip_interfaces $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP $vip_interface $nas_other_host;then
    logOut "ERROR" "Error while moving vip interface $vip_interface of host $nas_host"
    exit 1
  fi
  logOut "INFO" "Check that no vip interfaces are present on host $nas_host"
  vip_interfaces_after_move=$(identify_nas_vip_interface $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP $nas_host)
  if [ -n "$vip_interfaces_after_move" ];then
    logOut "INFO" "Vip interfaces are still present on host $nas_host"
    exit 1
  fi
done
logOut "INFO" "Summary of network interfaces status"
nas_interfaces_status=$(show_nas_ip_config $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP)
echo "$nas_interfaces_status"

logOut "INFO" "Install rhel nas patch on host $nas_host ($nas_ip)"
if [[ $nas_patch_ip_type == "ilo" ]];then
  logOut "INFO" "Opening a ILO console session on ip $NAS_ILO_IP"
  if ! install_nas_patchrhel_ilo root shroot12 $NAS_ILO_IP $SFSSETUP_PASSWORD;then
    logOut "ERROR" "Installation of rhel nas patches on host $nas_host ($nas_ip) failed!"
    exit 1
  fi
fi

if [[ $nas_patch_ip_type == "host" ]];then
  logOut "INFO" "Opening a ssh session on ip $nas_ip"
  if ! install_nas_patchrhel $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip;then
    logOut "ERROR" "Installation of rhel nas patches on host $nas_host ($nas_ip) failed!"
    exit 1
  fi
fi

logOut "INFO" "Reboot nas host $nas_host ($nas_ip)"
shutdown_nas_host $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP $nas_host

#EXITING HERE AS FIRST TEST OF THE SCRIPT
exit


CheckNASHostStatus

logOut "INFO" "Check that vip interfaces are balanced in the cluster"
until check_nas_vip_balanced $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP;do
  sleep 20
  ((counter++))
  if [ $counter -gt 30 ];then
    logOut "INFO" "Vip interfaces are not balanced between nas hosts!"
    exit 1
  fi
done
logOut "INFO" "Vip interfaces are correctly balanced"
logOut "INFO" "Summary of network interfaces status"
nas_interfaces_status=$(show_nas_ip_config $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP)
echo "$nas_interfaces_status"

}


##MAIN

#DEPLOYMENT_ID=$1
#NAS_PATCH_VERSION_EXPECTED=$2
#NAS_CONFIG_VERSION_EXPECTED=$3

GREEN='\033[0;32m'
RED='\033[0;31m'
OR='\033[0;33m'
NC='\033[0m' # No Color

while getopts "d:p:c:n:" option
do
  case "${option}"
  in
    d) DEPLOYMENT_ID=${OPTARG};;
    p) NAS_PATCH_VERSION_EXPECTED=${OPTARG};;
    c) NAS_CONFIG_VERSION_EXPECTED=${OPTARG};;
    n) NAS_HC=${OPTARG};;
    :) echo "Option -${OPTARG} requires an argument."; exit 1;;
    *) echo "Invalid input ${OPTARG}"; usage; exit 1 ;;
  esac
done

setVars

logOut "INFO" "$GREEN===== PHASE 1: DOWNLOAD SED FILE AND GET REQUIRED PARAMETERS =====$NC"
if ! generateSed;then
  exit 1
fi

logOut "INFO" "Get nas console info from sed file"
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
  logOut "ERROR" "NAS ilo ip addresses have not been properly retrieved from DMT!"
  exit 1
fi

logOut "INFO" "NAS console ip: $SFS_CONSOLE_IP"
logOut "INFO" "NAS console setup username: $SFSSETUP_USERNAME"
logOut "INFO" "NAS console password: $SFSSETUP_PASSWORD"
logOut "INFO" "LMS ip: $LMS_IP"
logOut "INFO" "NAS ilo ip 1: $NAS_ILO_IP_1"
logOut "INFO" "NAS ilo ip 2: $NAS_ILO_IP_2"

identifyMasterSlaveRoles

# echo "" > nas_upgrade_tasks

echo "" > nas_upgrade_tasks

logOut "INFO" "$GREEN===== PHASE 2: CHECK PREREQUISITES =====$NC"

nas_host=$nas_master_host
nas_ip=$nas_master_ip

checkPrerequisites $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_master_ip

nas_host=$nas_slave_host
nas_ip=$nas_slave_ip

checkPrerequisites $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_slave_ip

if [[ $NAS_HC == "yes" ]];then
  if nasHealthChecks $LMS_IP root 12shroot;then
    logOut "INFO" "NAS healthchecks have been successfully passed"
  else
    logOut "ERROR" "NAS healthchecks have failed!"
    exit 1
  fi
fi

logOut "INFO" "$GREEN===== PHASE 3: CHECK VERSIONS INSTALLED INTO NAS HOSTS =====$NC"
ERICNASCONFIG=ERICnasconfig_CXP9033343
NASRHEL7PATCH=nas-rhel7-os-patch-set_CXP9036738

nas_host=$nas_master_host
nas_ip=$nas_master_ip

check_nas_versions

nas_host=$nas_slave_host
nas_ip=$nas_slave_ip

check_nas_versions

cat nas_upgrade_tasks

nas_host=$nas_master_host
nas_ip=$nas_master_ip

logOut "INFO" "$GREEN===== PHASE 4: DOWNLOAD REQUIRED ARTIFACTS FROM NEXUS TO NAS =====$NC"

logOut "INFO" "${GREEN}Download required artifact from Nexus on host $nas_host ($nas_ip)$NC"

downloadArtifactsToNas
#  nas_hostname=$(get_nas_hostname_from_ip $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_vip_enm $nas_vip_enm)

nas_host=$nas_slave_host
nas_ip=$nas_slave_ip
nas_other_host=$nas_master_host

logOut "INFO" "${GREEN}Download required artifact from Nexus on host $nas_host ($nas_ip)$NC"

downloadArtifactsToNas

#done

logOut "INFO" "$GREEN===== PHASE 5: UPGRADE NAS =====$NC"
upgrade_nas_host "host"

nas_host=$nas_master_host
nas_ip=$nas_master_ip
nas_other_host=$nas_slave_host

upgrade_nas_host "ilo"

identifyMasterSlaveRoles

InstallAccessNASConfigurationKit root shroot12 $NAS_ILO_IP $SFSSETUP_PASSWORD

nas_host=$nas_master_host
nas_ip=$nas_master_ip
CheckNASHostStatus

nas_host=$nas_slave_host
nas_ip=$nas_slave_ip
CheckNASHostStatus

logOut "INFO" "$GREEN===== PHASE 6: POST-UPGRADE NAS CHECKS =====$NC"
logOut "INFO" "${GREEN}Check nas $nas_slave_ip$NC"
#set -x
if ! postUpgradeNASChecks $nas_slave_ip;then
  logOut "ERROR" "Check of NAS services failed on host $nas_slave_ip"
else
  logOut "INFO" "Check of NAS services successfully passed on host $nas_slave_ip"
fi

logOut "INFO" "${GREEN}Check nas $nas_master_ip$NC"

if ! postUpgradeNASChecks $nas_master_ip;then
  logOut "ERROR" "Check of NAS services failed on host $nas_master_ip"
else
  logOut "INFO" "Check of NAS services successfully passed on host $nas_master_ip"
fi

if [[ $NAS_HC == "yes" ]];then
  if nasHealthChecks $LMS_IP root 12shroot;then
    logOut "INFO" "NAS healthchecks have been successfully passed"
  else
    logOut "ERROR" "NAS healthchecks have failed!"
    exit 1
  fi
fi
