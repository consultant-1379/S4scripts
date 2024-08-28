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
DATETIME=$(date +%d-%m-%Y_%H-%M-%S)
ENM_HC="/opt/ericsson/enminst/bin/enm_healthcheck.sh --action vcs_service_group_healthcheck vcs_cluster_healthcheck -v"
LOG=${SCRIPT_NAME}_${DATETIME}.log
SED_FILE=${CLUSTER_ID}MASTER_siteEngineering.txt

VCS_CMD="/opt/ericsson/enminst/bin/vcs.bsh"
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

executeEnmHc() {
#####################################
# Function to set up global Variables
#####################################
# Inputs:       none
# Outputs:      none
# Returns:      0 or 1
#####################################
  if $ENM_HC;then
    return 0
  else
    return 1
  fi
}

getEnmClusters() {
#####################################
# Function to set up global Variables
#####################################
# Inputs:       none
# Outputs:      none
# Returns:      0 or 1
#####################################
$VCS_CLUSTER
local vcs_clusters
vcs_clusters=$($VCS_CMD --systems | grep cluster | awk '{print $3}' | uniq)
echo $vcs_clusters
}

getSgOfCluster(){

local vcs_cluster=$1 sg

sg=$($VCS_CMD --groups -c $vcs_cluster | grep $vcs_cluster | grep -v groups | awk '{print $2}' | uniq)

echo $sg

}

stopSgOfCluster(){

local vcs_cluster=$1

echo "$VCS_CMD --offline -g $vcs_cluster" 

#if $VCS_CMD --offline -g $vcs_cluster;then
#  return 0
#else
#  return 1
#fi

}

downloadSedFile(){

  sudo curl -s https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/deployment/$CLUSTER_ID/sed/master/generate/ > $SED_FILE
  sed -i "s/^M//g" $SED_FILE

sed -i "s/\\r//g" $SED_FILE
}

getDataFromSed(){
  local sed_param=$1 sed_value
  
  sed_value=$(grep ${sed_param}= $SED_FILE | awk -F'=' '{print $2}')
  echo "$sed_value"

}

getNodesFromSed(){
  local node_type=$1 nodes
  nodes=$(grep $node_type $SED_FILE | awk -F '_' '{print $1"_"$2}' | sort | uniq)
  echo $nodes

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

###############################################
# Function to execute a command on nas via ssh
###############################################
# Inputs:       nas user,nas passw,nas ip,cmd
#               to execute
# Outputs:      output of command
# Returns:
###############################################
execute_cmd_nas(){
local cmd_out nas_user=$1 nas_password=$2 nas_ip=$3 cmd="$4"
cmd_out=$(sshpass -p $nas_password ssh -q -A -t -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $nas_user@$nas_ip "$cmd")
echo "$cmd_out"
}

#########################################
# Function to shutdown a nas host
#########################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:
# Returns:
#########################################
shutdown_nas_host(){
local nas_user=$1 nas_password=$2 nas_ip=$3 nas_host=$4
echo "INFO: Executing command 'cluster shutdown $nas_host'"
#execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/clish/bin/clish -u master -c \"cluster shutdown $nas_host\""
}

##########################################
# Function to identify roles of nas hosts
##########################################
# Inputs:       nas user,nas passw,nas ip
#               master/slave
# Outputs:      host of requested role
# Returns:
##########################################
identify_nas_role(){
local nas_user=$1 nas_password=$2 nas_ip=$3 master_slave=$4 nas_host
nas_host=$(execute_cmd_nas $nas_user $nas_password $nas_ip "vxclustadm nidmap" | grep $master_slave | awk '{print $1}')
echo $nas_host
}

getNasConsoleIp(){
local nas_console_ip
nas_console_ip=$(get_info_from_sed "sfs_console_IP")
if [ -z "$nas_console_ip" ];then
  echo "ERROR: Nas console ip not found!"
  return 1
else
  if ( ! is_ip_valid "$nas_console_ip" );then
    echo "ERROR: Nas console ip not found in sed file"
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
  echo "ERROR: Nas console setup username not found!"
  return 1
else
  echo $nas_console_setup_username
fi
}

getNasConsoleSetupPassword(){
local nas_console_setup_password
nas_console_setup_password=$(get_info_from_sed "sfssetup_password")
if [ -z "$nas_console_setup_password" ];then
  echo "ERROR: Nas console setup password not found!"
  return 1
else
  echo $nas_console_setup_password
fi
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

checkNodeIsPowered(){

local host=$1 ilo_ip=$2 counter power_state is_powered

counter=1

while [ $counter -le 3 ];do

  echo "INFO: Checking if $host is powered off ($counter of 3)"
  echo "INFO: Waiting 10 seconds"
  sleep 10

  power_state=$(curl -s -L -k --user root:shroot12 -X GET https://$ilo_ip/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
  #  echo "INFO: Node $node ($ilo_ip) $power_state"
  if [[ "$power_state" == *"Off"* ]];then
    echo "INFO: $host is powered off"
    is_powered=false
    break
  fi
  counter=$(( $counter + 1 ))
  if [ $counter -gt 3 ];then
    echo "ERROR: $host is still powered on !"
    is_powered=true
  fi
done
if $is_powered;then
  return 1
else
  return 0
fi
}

