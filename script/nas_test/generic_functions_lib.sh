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

setVars() {
#####################################
# Function to set up global Variables
#####################################
# Inputs:       none
# Outputs:      none
# Returns:      0 or exits
#####################################

logOut "INFO" "Setting Global Variables"
DATETIME=$(date +%d-%m-%Y_%H-%M-%S)
SED_FILE=MASTER_siteEngineering.txt
NAS_CONFIG_DIR=/media/config/
NAS_PATCH_DIR=/media/patches/
CI_PORTAL_URL=https://ci-portal.seli.wh.rnd.internal.ericsson.com/
GENERATE_SED_API=api/deployment/$DEPLOYMENT_ID/sed/master/generate/
ERICRHEL7_REL="cat /etc/ericrhel7-release"
ERICNAS_CONFIG=CXP9033343
#SCRIPT_NAME=$( $BASENAME $0 )
SCRIPT_NAME=upgrade_va_rhel_patches
#SCRIPT_DIR=$( cd $( dirname $0 ); pwd )
LOG=${SCRIPT_NAME}_${DATETIME}.log
ERICNASCONFIG=ERICnasconfig_CXP9033343
NASRHEL7PATCH=nas-rhel7-os-patch-set_CXP9036738

echo "DATETIME=$DATETIME"
echo "SED_FILE=$SED_FILE"
echo "NAS_CONFIG_DIR=$NAS_CONFIG_DIR"
echo "NAS_PATCH_DIR=$NAS_PATCH_DIR"
echo "CI_PORTAL_URL=$CI_PORTAL_URL"
echo "GENERATE_SED_API=$GENERATE_SED_API"
echo "ERICRHEL7_REL=$ERICRHEL7_REL"
echo "ERICNAS_CONFIG=$ERICNAS_CONFIG"
echo "SCRIPT_NAME=$SCRIPT_NAME"
echo "LOG=$LOG"
echo "ERICNASCONFIG=$ERICNASCONFIG"
echo "NASRHEL7PATCH=$NASRHEL7PATCH"

}

########################################
# Function to download sed file from dmt 
########################################
# Inputs:       none
# Outputs:      none
# Returns:      0 File sed downloaded
#               1 Failure
########################################
generateSed(){
  logOut "INFO" "Download sed file from CI Portal"
  echo "curl -q $CI_PORTAL_URL$GENERATE_SED_API 2>/dev/null > $SED_FILE"
  curl -q $CI_PORTAL_URL$GENERATE_SED_API 2>/dev/null > $SED_FILE
  if grep -q "does not exist" $SED_FILE;then
    cat $SED_FILE
#    remove_temp_dir
    logOut "ERROR" "Sed file has not been successfully downloaded"
    return 1
  else
  #Removes carriage return
    logOut "INFO" "Sed file successfully downloaded"
    sed -i 's/\r$//g' $SED_FILE
    return 0
  fi
}

##########################################
# Function to get parameter from sed file
##########################################
# Inputs:       sed parameter to get value
# Outputs:      value of sed parameter
# Returns:      
########################################
get_info_from_sed(){
local sed_param=$1 sed_value
sed_value=$(grep -w $sed_param $SED_FILE | awk -F'=' '{print $2}')
echo $sed_value
}	

##########################################
# Function to check ip is valid address
##########################################
# Inputs:       ip address to check
# Outputs:      
# Returns:      0 ip is valid
#               1 ip is not valid
##########################################
is_ip_valid(){
local ip_to_check=$1
if [[ $ip_to_check =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];then
  return 0
else
  return 1
fi
}

#######################################
# Function to print a banner message
#######################################
# Inputs:       message to print
# Outputs:
# Returns:      
#########################################################
banner() {
    msg="# $* #"
    edge=$(echo "$msg" | sed 's/./#/g')
#    echo ""
    echo "$edge"
    echo "$msg"
    echo "$edge"
#    echo ""
}

datestamp() {
#####################################
# Function to output a formatted date
#####################################
# Inputs:       $1 [1|2|3] (optional)
#                               for 4 different output formats
# Outputs:      none
# Returns:      0 success
#####################################
[[ $1 -eq 1 ]] && date +%H:%M:%S
[[ $1 -eq 2 ]] && date +%d-%m-%Y_%H-%M-%S
[[ $1 -eq 3 ]] && date +%Y-%m-%d
[[ -z $1 ]] && date

return 0
}

logOut() {
#####################################
# Function to send formatted output to STDOUT and $LOG
#####################################
# Inputs:       $1 [DEBUG|WARN|ERROR|INFO|ECHO]
#                               for the type of formatting
#                       $2 <string>
#                               for the message
# Outputs:      none
# Returns:      0 success
#                       1 incorrect usage
#####################################
[[ "$1" == "DEBUG" ]] && {
        [[ "$DEBUG" == "y" ]] && echo -e $(datestamp 1)"   [DEBUG]\t${@:2}" |tee -a $LOG 2>&1
        return 0
        }
[[ "$1" == "WARNING" ]] && {
        echo -e $(datestamp 1)"   \033[1;30;33m[WARNING]\033[0m   ${@:2}"
        echo -e $(datestamp 1)"   [WARNING]   ${@:2}" >> $LOG 2>&1
        return 0
        }
[[ "$1" == "ERROR" ]] && {
        echo -e  $(datestamp 1)"   \033[1;30;31m[ERROR]\033[0m   ${@:2}"
        echo -e  $(datestamp 1)"   [ERROR]   ${@:2}" >> $LOG 2>&1
        return 0
        }
[[ "$1" == "INFO" ]] && {
        echo -e $(datestamp 1)"   \033[1;30;32m[INFO]\033[0m   ${@:2}"
        echo -e $(datestamp 1)"   [INFO]   ${@:2}" >> $LOG 2>&1
        return 0
        }
[[ "$1" == "ECHO" ]] && {
        echo -e "${@:2}" |tee -a $LOG 2>&1
        return 0
        }
echo -e "[WARNING: bad $FUNCNAME call]\t$@" |tee -a $LOG 2>&1
return 1
}

getNasConsoleIp(){
local nas_console_ip
nas_console_ip=$(get_info_from_sed "sfs_console_IP")
if [ -z "$nas_console_ip" ];then
  logOut "ERROR" "Nas console ip not found!"
  return 1
else
  if ( ! is_ip_valid "$nas_console_ip" );then
    logOut "ERROR" "Nas console ip not found in sed file"
    return 1
  else
    echo $nas_console_ip
  fi
fi
}

getNasConsoleSetupUsername(){
local nas_console_setup_username
nas_console_setup_username=$(get_info_from_sed "sfssetup_username")
if [ -z "$nas_console_setup_username" ];then
  logOut "ERROR" "Nas console setup username not found!"
  return 1
else
  echo $nas_console_setup_username
fi
}

getNasConsoleSetupPassword(){
local nas_console_setup_password
nas_console_setup_password=$(get_info_from_sed "sfssetup_password")
if [ -z "$nas_console_setup_password" ];then
  logOut "ERROR" "Nas console setup password not found!"
  return 1
else
  echo $nas_console_setup_password
fi
}

getLmsIp(){
local lms_ip
lms_ip=$(get_info_from_sed "LMS_IP")
if [ -z "$lms_ip" ];then
  logOut "ERROR" "LMS ip not found!"
  return 1
else
  if ( ! is_ip_valid "$lms_ip" );then
    logOut "ERROR" "LMS ip not found in sed file"
    return 1
  else
    echo $lms_ip
  fi
fi
}

getNasIloAddress(){
  local deployment_id=$1 nas_ilo_ip_1 nas_ilo_ip_2
  nas_ilo_ip_1=$(curl -s -X GET https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/deployment/getNasDetails/$deployment_id/ | python -m json.tool | grep nasInstallIloIp1 | awk -F':' '{print $2}' | sed 's/"//g;s/,//g;s/ //g')
  nas_ilo_ip_2=$(curl -s -X GET https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/deployment/getNasDetails/$deployment_id/ | python -m json.tool | grep nasInstallIloIp2 | awk -F':' '{print $2}' | sed 's/"//g;s/,//g;s/ //g')
#  nas_ilo_ip=$(curl -s -X GET http://atclvm1225.athtem.eei.ericsson.se:8000/api/deployment/getNasDetails/$deployment_id/ | python -m json.tool | grep nasInstallIloIp1 | awk -F':' '{print $2}' | sed 's/"//g;s/,//g;s/ //g')
  echo "$nas_ilo_ip_1|$nas_ilo_ip_2"
}

getSanIpA(){
local san_ip_a
san_ip_a=$(get_info_from_sed "san_spaIP")
if [ -z "$san_ip_a" ];then
  echo "ERROR" "San ip A not found!"
  return 1
else
  echo $san_ip_a
fi
}

getSanUser(){
local san_ip_a
san_user=$(get_info_from_sed "san_user")
if [ -z "$san_user" ];then
  echo "ERROR" "San user not found!"
  return 1
else
  echo $san_user
fi
}

getSanPassword(){
local san_password
san_password=$(get_info_from_sed "san_password")
if [ -z "$san_password" ];then
  echo "ERROR" "San password not found!"
  return 1
else
  echo $san_password
fi
}

getSanType(){
local san_type
san_type=$(get_info_from_sed "san_type")
if [ -z "$san_type" ];then
  echo "ERROR" "San type not found!"
  return 1
else
  echo $san_type
fi
}

getNasVipEnm1(){
local nas_vip_enm_1
nas_vip_enm_1=$(get_info_from_sed "nas_vip_enm_1")
if [ -z "$nas_vip_enm_1" ];then
  echo "ERROR" "Nas vip enm1 not found!"
  return 1
else
  echo $nas_vip_enm_1
fi
}

getNasVipEnm2(){
local nas_vip_enm_2
nas_vip_enm_2=$(get_info_from_sed "nas_vip_enm_2")
if [ -z "$nas_vip_enm_2" ];then
  echo "ERROR" "Nas vip enm2 not found!"
  return 1
else
  echo $nas_vip_enm_2
fi
}



