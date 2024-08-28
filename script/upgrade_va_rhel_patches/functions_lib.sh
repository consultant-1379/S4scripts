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

######################################################
# Function to get version of nas rhel patch installed
######################################################
# Inputs:       nas user,nas passw,nas ip,cmd
# Outputs:      version of nas rhel patch installed
# Returns:
######################################################
get_installed_patch_version(){
local patch_version_info patch_version nas_user=$1 nas_password=$2 nas_ip=$3 info_type=$4
if [[ $info_type == "version" ]];then
  patch_version_info=$(execute_cmd_nas $nas_user $nas_password $nas_ip "$ERICRHEL7_REL")
  patch_version=$(echo "$patch_version_info" | egrep 'nexus-version|nexus_version' | sed 's/"//g' | awk -F':' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
  echo $patch_version
fi
if [[ $info_type == "info" ]];then
  patch_version_info=$(execute_cmd_nas $nas_user $nas_password $nas_ip "$ERICRHEL7_REL")
  echo "$patch_version_info"
fi
}

######################################################
# Function to check installed versions
######################################################
# Inputs:       artifact name,version installed,version expected
# Outputs:      
# Returns:      
######################################################
check_versions(){
local version_installed=$1 version_expected=$2

if [[ $version_installed == $version_expected ]];then
  return 2
fi
local IFS=.
local i ver1=($version_installed) ver2=($version_expected)
# fill empty fields in ver1 with zeros
for ((i=${#ver1[@]}; i<${#ver2[@]}; i++));do
  ver1[i]=0
done
for ((i=0; i<${#ver1[@]}; i++));do
  if [[ -z ${ver2[i]} ]];then
    # fill empty fields in ver2 with zeros
    ver2[i]=0
  fi
  if ((10#${ver1[i]} > 10#${ver2[i]}));then
    return 1
  fi
  if ((10#${ver1[i]} < 10#${ver2[i]}));then
    return 0
  fi
done
#return 0
}

######################################################
# Function to check installed versions
######################################################
# Inputs:       artifact name,version installed,version expected
# Outputs:
# Returns:
######################################################
is_version_installed(){
local artifact_name=$1 version_installed=$2 version_expected=$3 status

check_versions $version_installed $version_expected
status=$?
if [ $status -eq 2 ];then
  logOut "WARNING" "$artifact_name $version_expected is already installed"
  return 2
fi
if [ $status -eq 0 ];then
  logOut "INFO" "$artifact_name installed ($version_installed) is lower than expected version ($version_expected)"
  return 0
fi
if [ $status -eq 1 ];then
  logOut "WARNING" "$artifact_name installed ($version_installed) is higher than expected version ($version_expected)"
  exit 1
fi
}



######################################################
# Function to get version of nas config installed
######################################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:      version of nas config installed
# Returns:      
######################################################
get_installed_nas_config_version(){
local nas_config_version nas_config_info nas_user=$1 nas_password=$2 nas_ip=$3 info_type=$4
if [[ $info_type == "version" ]];then
  nas_config_version=$(execute_cmd_nas $nas_user $nas_password $nas_ip "rpm -qa | grep $ERICNAS_CONFIG" | awk -F'-' '{print $2}')
  echo $nas_config_version
fi
if [[ $info_type == "info" ]];then
  nas_config_info=$(execute_cmd_nas $nas_user $nas_password $nas_ip "rpm -qa | grep $ERICNAS_CONFIG")
  echo $nas_config_info
fi
}

######################################################
# Function to download file from nexus to nas
######################################################
# Inputs:       nas user,nas passw,nas ip,wget cmd
# Outputs:      
# Returns:      0 successfull
#               1 failed
######################################################
download_file_from_nexus_on_nas(){
local nas_user=$1 nas_password=$2 nas_ip=$3 wget_cmd="$4"
if execute_cmd_nas $nas_user $nas_password $nas_ip "$wget_cmd";then
  return 0
else
  return 1
fi    
}

##################################################################
# Function to download ERICnasconfig_CXP9033343 from nexus to nas
##################################################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:
# Returns:      0 successfull
#               1 failed
#################################################################
download_nas_config_from_nexus(){
local nas_user=$1 nas_password=$2 nas_ip=$3
logOut "INFO" "Executing commands on nas $nas_ip: wget -e use_proxy=yes -e https_proxy=159.107.173.253:3128 --progress=bar:force -O $NAS_CONFIG_DIR/ERICnasconfig_CXP9033343-$NAS_CONFIG_VERSION_EXPECTED.tar.gz --no-check-certificate \"https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/repositories/nas-media/content/com/ericsson/oss/itpf/nas/ERICnasconfig_CXP9033343/$NAS_CONFIG_VERSION_EXPECTED/ERICnasconfig_CXP9033343-$NAS_CONFIG_VERSION_EXPECTED.tar.gz\""
if download_file_from_nexus_on_nas $nas_user $nas_password $nas_ip "wget -e use_proxy=yes -e https_proxy=159.107.173.253:3128 --progress=bar:force -O $NAS_CONFIG_DIR/ERICnasconfig_CXP9033343-$NAS_CONFIG_VERSION_EXPECTED.tar.gz --no-check-certificate \"https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/repositories/nas-media/content/com/ericsson/oss/itpf/nas/ERICnasconfig_CXP9033343/$NAS_CONFIG_VERSION_EXPECTED/ERICnasconfig_CXP9033343-$NAS_CONFIG_VERSION_EXPECTED.tar.gz\"";then
  return 0
else
  return 1
fi  
}

###########################################################################
# Function to download nas-rhel7-os-patch-set_CXP9036738 from nexus to nas
###########################################################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:
# Returns:      0 successfull
#               1 failed
###########################################################################
download_nas_patch_from_nexus(){
local nas_user=$1 nas_password=$2 nas_ip=$3
logOut "INFO" "${RED}Executing commands on nas $nas_ip: wget -e use_proxy=yes -e https_proxy=159.107.173.253:3128 --progress=bar:force -O $NAS_PATCH_DIR/nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz --no-check-certificate \"https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/repositories/nas-media/content/com/ericsson/oss/itpf/nas/nas-rhel7-os-patch-set_CXP9036738/$NAS_PATCH_VERSION_EXPECTED/nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz\"${NC}"
if download_file_from_nexus_on_nas $nas_user $nas_password $nas_ip "wget -e use_proxy=yes -e https_proxy=159.107.173.253:3128 --progress=bar:force -O $NAS_PATCH_DIR/nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz --no-check-certificate \"https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/service/local/repositories/nas-media/content/com/ericsson/oss/itpf/nas/nas-rhel7-os-patch-set_CXP9036738/$NAS_PATCH_VERSION_EXPECTED/nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz\"";then
  return 0
else
  return 1
fi  
}

######################################################
# Function to install ERICnasconfig_CXP9033343 in nas 
######################################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:
# Returns:      0 successfull
#               1 failed
#####################################################
install_nas_config(){
local nas_user=$1 nas_password=$2 nas_ip=$3
logOut "INFO" "${RED}Executing commands on nas $nas_ip: cd $NAS_CONFIG_DIR;tar xvf ERICnasconfig_CXP9033343-$NAS_CONFIG_VERSION_EXPECTED.tar.gz;yum install ERICnasconfig_CXP9033343-$NAS_CONFIG_VERSION_EXPECTED.rpm -y${NC}"
if execute_cmd_nas $nas_user $nas_password $nas_ip "cd $NAS_CONFIG_DIR;tar xvf ERICnasconfig_CXP9033343-$NAS_CONFIG_VERSION_EXPECTED.tar.gz;yum install ERICnasconfig_CXP9033343-$NAS_CONFIG_VERSION_EXPECTED.rpm -y";then
  return 0
else
  return 1
fi
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

###############################################
# Function to show a summary of nas hosts roles
###############################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:      host of requested role
# Returns:
##########################################
nas_host_roles_summary(){
local nas_user=$1 nas_password=$2 nas_ip=$3 master_slave=$4 nas_roles_summary
logOut "INFO" "${RED}Executing commands on nas $nas_ip: vxclustadm nidmap${NC}"
nas_roles_summary=$(execute_cmd_nas $nas_user $nas_password $nas_ip "vxclustadm nidmap")
echo "$nas_roles_summary"
}


####################################################
# Function to identify vip associated to a nas host
####################################################
# Inputs:       nas user,nas passw,nas ip
#               nas host
# Outputs:      vip of nas host
# Returns:
####################################################
identify_nas_vip_interface(){
local nas_user=$1 nas_password=$2 nas_ip=$3 nas_host=$4 vip_interfaces 
#vip_interfaces=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/scripts/net/net_ipconfig.sh show" | grep 'Virtual' | grep $nas_host | awk '{print $1}')
vip_interfaces=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/clish/bin/clish -u master -c 'network ip addr show'" | grep -v 'Con' | grep 'Virtual' | grep $nas_host | awk '{print $1}')
echo $vip_interfaces
}

###############################################
# Function to get vip associated to a nas host
###############################################
# Inputs:       nas user,nas passw,nas ip
#               nas host
# Outputs:      vip of nas host
# Returns:
###############################################
get_nas_ip_from_hostname(){
local nas_user=$1 nas_password=$2 nas_ip=$3 nas_hostname=$4 ip_type=$5 nas_ip_from_host nas_ip_host
nas_ip_from_host=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/scripts/net/net_ipconfig.sh show" | grep -v 'Con' | grep $ip_type | grep $nas_hostname | awk '{print $1}')
echo $nas_ip_from_host
}

###############################################
# Function to get nas host associated to a vip
###############################################
# Inputs:       nas user,nas passw,nas ip
#               vip
# Outputs:      nas host
# Returns:
###############################################
get_nas_hostname_from_ip(){
local nas_user=$1 nas_password=$2 nas_ip=$3 nas_ip_lookup=$4 nas_hostname_from_ip
nas_hostname_from_ip=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/scripts/net/net_ipconfig.sh show" | grep -v 'Con' | grep 'Virtual' | grep $nas_ip_lookup | awk '{print $4}')
echo $nas_hostname_from_ip
}

#########################################
# Function to display nas ip config info
#########################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:      nas ip config
# Returns:
#########################################
show_nas_ip_config(){
local nas_user=$1 nas_password=$2 nas_ip=$3 nas_ip_config
logOut "INFO" "${RED}Executing console command 'network ip addr show' on host $nas_ip${NC}"
#nas_ip_config=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/scripts/net/net_ipconfig.sh show")
nas_ip_config=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/clish/bin/clish -u master -c 'network ip addr show'")
echo "$nas_ip_config"
}

#########################################
# Function to move vip to nas host
#########################################
# Inputs:       nas user,nas passw,nas ip
#               vip to move
# Outputs:      
# Returns:      0 success
#               error code
#########################################
move_nas_vip_interfaces(){
local nas_user=$1 nas_password=$2 nas_ip=$3 vip_ip=$4 nas_host=$5
#if execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/scripts/net/net_ipconfig.sh online $vip_ip $nas_host";then
logOut "INFO" "${RED}Executing console command 'network ip addr online $vip_ip $nas_host' on host $nas_ip${NC}"
if execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/clish/bin/clish -u master -c \"network ip addr online $vip_ip $nas_host\"";then 
  return 0
else
  return $?
fi
}

#########################################
# Function to install nas patch ilo ip
#########################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:      
# Returns:      0 success
#               error code
#########################################
install_nas_patchrhel_ilo(){
local nas_ilo_user=$1 nas_ilo_password=$2 nas_ilo_ip=$3 nas_password=$4
logOut "INFO" "${RED}Executing command /opt/ericsson/NASconfig/bin/patchrhel.bsh -u $NAS_PATCH_DIR/nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz on host $nas_ilo_ip${NC}"
if ./nas_ilo_cmd.expect $nas_ilo_ip $nas_ilo_user $nas_ilo_password $nas_password "/opt/ericsson/NASconfig/bin/patchrhel.bsh -u $NAS_PATCH_DIR/nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz";then
   return 0
else
  return $?
fi
}

#########################################
# Function to install nas patch host ip
#########################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:
# Returns:      0 success
#               error code
#########################################
install_nas_patchrhel(){
local nas_user=$1 nas_password=$2 nas_ip=$3
logOut "INFO" "${RED}Executing command /opt/ericsson/NASconfig/bin/patchrhel.bsh -u $NAS_PATCH_DIR/nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz on host $nas_ip${NC}"
if execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/ericsson/NASconfig/bin/patchrhel.bsh -u $NAS_PATCH_DIR/nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz";then
  return 0
else
  return $?
fi
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
logOut "INFO" "${RED}Executing command 'cluster reboot $nas_host' on host $nas_ip${NC}"
execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/clish/bin/clish -u master -c \"cluster reboot $nas_host\""
}

#########################################
# Function to check nas host is alive
#########################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:
# Returns:      0 nas host is alive
#               1 nas host is not alive
#########################################
check_nas_host_alive(){
local nas_user=$1 nas_password=$2 nas_ip=$3 counter
until execute_cmd_nas $nas_user $nas_password $nas_ip "hostname";do
  echo "WAITING FOR NAS $nas_ip TO STARTUP"
  sleep 20
  ((counter++))
  if [ $counter -gt 30 ];then
    echo "HOST $nas_ip DID NOT STARTUP WITHIN 10 MINUTES"
    return 1
  fi
done
return 0
}

###########################################
# Function to check nas host cluster state
###########################################
# Inputs:       nas user,nas passw,nas ip
#               nas host
# Outputs:      nas host cluster state
# Returns:      
###########################################
check_nas_host_state(){
local nas_user=$1 nas_password=$2 nas_ip=$3 nas_hostname=$4 nas_host_state
nas_host_state=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/clish/bin/clish -u master -c \"cluster show\"" | grep $nas_hostname | awk '{print $2}') 
#nas_host_state=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/scripts/cluster/cluster_config.sh show" | grep $nas_hostname | awk '{print $2}')
echo $nas_host_state
}

###########################################
# Function to show nas cluster state
###########################################
# Inputs:       nas user,nas passw,nas ip
# Outputs:      nas cluster state
# Returns:
###########################################
show_cluster_summary(){
local nas_user=$1 nas_password=$2 nas_ip=$3 nas_cluster_summary
logOut "INFO" "${RED}Executing command 'cluster show' on host $nas_ip${NC}"
nas_cluster_summary=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/clish/bin/clish -u master -c \"cluster show\"")
#nas_cluster_summary=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/scripts/cluster/cluster_config.sh show")
echo "$nas_cluster_summary"
}

#########################################################
# Function to check that vip are balanced in the cluster
#########################################################
# Inputs:       nas user,nas passw,nas ip,nas host1, nas
#               host2
# Outputs:      
# Returns:      0 vip are balanced
#               1 vip are not balanced
#########################################################
check_nas_vip_balanced(){
local nas_user=$1 nas_password=$2 nas_ip=$3 nas_vip_state nas_hostname_1 nas_hostname_2
nas_hostname_1=$(identify_nas_role $nas_user $nas_password $nas_ip 'Master')
nas_hostname_2=$(identify_nas_role $nas_user $nas_password $nas_ip 'Slave')
#nas_vip_state=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/scripts/net/net_ipconfig.sh show" | grep 'Virtual')
nas_vip_state=$(execute_cmd_nas $nas_user $nas_password $nas_ip "/opt/VRTSnas/clish/bin/clish -u master -c 'network ip addr show'"  | grep 'Virtual')
if [[ "$nas_vip_state" == *"$nas_hostname_1"* ]] && [[ "$nas_vip_state" == *"$nas_hostname_2"* ]];then
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

InstallAccessNASConfigurationKit(){
local nas_ilo_user=$1 nas_ilo_password=$2 nas_ilo_ip=$3 nas_password=$4
logOut "INFO" "Executing commands cd /media/config;./configure_NAS.bsh -y -a rpm on host $nas_ilo_ip"
if ./nas_ilo_cmd.expect $nas_ilo_ip $nas_ilo_user $nas_ilo_password $nas_password "cd /media/config;./configure_NAS.bsh -y -a rpm";then
   return 0
else
  return $?
fi

#if execute_cmd_nas $nas_user $nas_password $nas_ip "cd /media/config;./configure_NAS.bsh -y -a rpm";then
#   return 0
#else
#  return $?
#fi
}

check_nas_versions(){
local status
logOut "INFO" "${GREEN}Check versions installed in host $nas_host ($nas_ip)$NC"
logOut "INFO" "Check installed nas rhel7 os patch version on host $nas_host ($nas_ip)"
nas_patch_info=$(get_installed_patch_version $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip "info")
nas_patch_version=$(get_installed_patch_version $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip "version")
if [ -z "$nas_patch_version" ] || [ -z "$nas_patch_info" ];then
  logOut "ERROR" "Nas patch version not properly detected!"
  exit 1
fi
echo "$nas_patch_info"
if is_version_installed $NASRHEL7PATCH $nas_patch_version $NAS_PATCH_VERSION_EXPECTED;then
  echo "$NASRHEL7PATCH $nas_ip $nas_host $nas_patch_install" >> nas_upgrade_tasks
else
  exit 0
fi
logOut "INFO" "Check installed nas config version on host: $nas_host"
nas_config_info=$(get_installed_nas_config_version $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip "info")
nas_config_version=$(get_installed_nas_config_version $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip "version")
if [ -z "$nas_config_version" ] || [ -z "$nas_config_info" ];then
  logOut "ERROR" "Nas config version not properly detected!"
  exit 1
fi
echo $nas_config_info
#set -x
is_version_installed $ERICNASCONFIG $nas_config_version $NAS_CONFIG_VERSION_EXPECTED
status=$?
if [ $status = 0 ];then
  echo "$ERICNASCONFIG $nas_ip $nas_host $nas_config_install" >> nas_upgrade_tasks
fi
if [ $status = 1 ];then
  exit 0
fi  
#set +x
}

checkCreateNASPatchesDir(){
if execute_cmd_nas $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip "[[ -d $NAS_CONFIG_DIR ]]";then
  logOut "INFO" "Directory $NAS_CONFIG_DIR is already present on host $nas_host ($nas_ip)"
else
  logOut "INFO" "Create directory $NAS_CONFIG_DIR on host $nas_host ($nas_ip)"
  if execute_cmd_nas $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip "mkdir -p $NAS_CONFIG_DIR";then
    logOut "INFO" "Directory $NAS_CONFIG_DIR has been successfully created on host $nas_host ($nas_ip)"
  else
    logOut "ERROR" "Directory $NAS_CONFIG_DIR has not been successfully created on host $nas_host ($nas_ip)!"
    exit 1
  fi
fi
}

downloadArtifactsToNas(){
if cat nas_upgrade_tasks | grep $nas_ip | grep -q $ERICNASCONFIG;then
  checkCreateNASPatchesDir
  logOut "INFO" "Download $ERICNASCONFIG-$NAS_CONFIG_VERSION_EXPECTED.tar.gz to host $nas_host ($nas_ip) in progress"
  if download_nas_config_from_nexus $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip;then
    logOut "INFO" "Download of $ERICNASCONFIG-$NAS_CONFIG_VERSION_EXPECTED.tar.gz to host $nas_host ($nas_ip) successfully completed"
  else
    logOut "ERROR" "Download of $ERICNASCONFIG-$NAS_CONFIG_VERSION_EXPECTED.tar.gz to host $nas_host ($nas_ip) has failed!"
    exit 1
  fi
fi

if cat nas_upgrade_tasks | grep $nas_ip | grep -q $NASRHEL7PATCH;then
  checkCreateNASPatchesDir
  logOut "INFO" "Download nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz to host $nas_host ($nas_ip) in progress"
  if download_nas_patch_from_nexus $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip;then
    logOut "INFO" "Download of nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz to host $nas_host ($nas_ip) successfully completed"
  else
    logOut "INFO" "Download of nas-rhel7-os-patch-set_CXP9036738-$NAS_PATCH_VERSION_EXPECTED.tar.gz to host $nas_host ($nas_ip) has failed!"
    exit 1
  fi
fi
}

identifyMasterSlaveRoles(){
logOut "INFO" "Identify Master and Slave roles/ips of the nas hosts"
nas_master_host=$(identify_nas_role $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP 'Master')
nas_slave_host=$(identify_nas_role $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP 'Slave')
if [ -z "$nas_master_host" ] || [ -z "$nas_master_host" ];then
  logOut "ERROR" "Master or Slave host not properly reported"
  exit 1
fi
nas_slave_ip=$(get_nas_ip_from_hostname $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP 'Physical' $nas_slave_host)
nas_master_ip=$(get_nas_ip_from_hostname $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP 'Physical' $nas_master_host)
if ( ! is_ip_valid "$nas_slave_ip" ) || ( ! is_ip_valid "$nas_master_ip" );then
  logOut "ERROR" "Nas master ip or slave ip are not valid!"
  exit 1
fi

nas_host_roles=$(nas_host_roles_summary $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP)
echo "$nas_host_roles"
logOut "INFO" "Master host: $nas_master_host ($nas_master_ip) Slave host: $nas_slave_host ($nas_slave_ip)"
}

rpcInfoNAS(){
local info nas_user=$1 nas_password=$2 nas_ip=$3
info=$(execute_cmd_nas $nas_user $nas_password $nas_ip "rpcinfo -p")
echo "$info"
}

postUpgradeNASChecks(){
local nas_ip=$1 PORTMAPPER_EXP=6 NFS_EXP=2 NFS_ACL_EXP=2 NLOCKMGR_EXP=6 MOUNTD_EXP=6 STATUS_EXP=2 portmapper nfs nfs_acl nlockmgr mountd status info_nas failed=false
info_nas=$(rpcInfoNAS  $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $nas_ip) 
portmapper=$(echo "$info_nas" | grep -w portmapper | wc -l)
nfs=$(echo "$info_nas" | grep -w nfs | wc -l)
nfs_acl=$(echo "$info_nas" | grep -w nfs_acl | wc -l)
nlockmgr=$(echo "$info_nas" | grep -w nlockmgr | wc -l)
mountd=$(echo "$info_nas" | grep -w mountd | wc -l)
status=$(echo "$info_nas" | grep -w status | wc -l)

if [ $portmapper = $PORTMAPPER_EXP ];then 
  logOut "INFO" "Portmapper services OK (found:$portmapper expected:$PORTMAPPER_EXP)"
else
  logOut "ERROR" "Portmapper services NOK (found:$portmapper expected:$PORTMAPPER_EXP)"
  failed=true
fi

if [ $nfs = $NFS_EXP ];then
  logOut "INFO" "Nfs services OK (found:$nfs expected:$NFS_EXP)"
else
  logOut "ERROR" "Nfs services NOK (found:$nfs expected:$NFS_EXP)"
  failed=true
fi

if [ $nfs_acl = $NFS_ACL_EXP ];then
  logOut "INFO" "Nfs-acl services OK (found:$nfs_acl expected:$NFS_ACL_EXP)"
else
  logOut "ERROR" "Nfs-acl services NOK (found:$nfs_acl expected:$NFS_ACL_EXP)"
  failed=true
fi

if [ $nlockmgr = $NLOCKMGR_EXP ];then
  logOut "INFO" "Nlockmgr services OK (found:$nlockmgr expected:$NLOCKMGR_EXP)"
else
  logOut "ERROR" "Nlockmgr services NOK (found:$nlockmgr expected:$NLOCKMGR_EXP)"
  failed=true
fi

if [ $mountd = $MOUNTD_EXP ];then
  logOut "INFO" "Mountd services OK (found:$mountd expected:$MOUNTD_EXP)"
else
  logOut "ERROR" "Mountd services NOK (found:$mountd expected:$MOUNTD_EXP)"
  failed=true
fi

if $failed;then
  return 1
else
  return 0
fi

}

checkPrerequisites(){
local nas_solution rhel_version nas_user=$1 nas_password=$2 nas_ip=$3
logOut "INFO" "${GREEN}Check Prerequisites on nas host $nas_ip$NC"
nas_solution=$(execute_cmd_nas $nas_user $nas_password $nas_ip "rpm -qa | grep VRTSnascpi")
if [[ "$nas_solution" == *"7.4.1.200"* ]];then
  logOut "INFO" "NAS Solution is Veritas Access 7.4.1.200. Upgrade can continue."
else
  logOut "ERROR" "NAS Solution is not Veritas Access 7.4.1.200. Upgrade cannot continue!"
  exit 1
fi

rhel_version=$(execute_cmd_nas $nas_user $nas_password $nas_ip "cat /etc/redhat-release")

if [[ "$rhel_version" == *"7.6"* ]];then
  logOut "INFO" "RHEL version is 7.6. Upgrade can continue"
else
  logOut "ERROR" "RHEL version is not 7.6. Upgrade cannot continue!"
  exit 1
fi
}

nasHealthChecks(){
  local lms_ip=$1 lms_user=$2 lms_password=$3 cmd
  cmd="/opt/ericsson/enminst/bin/enm_healthcheck.sh --action nas_healthcheck"
  logOut "INFO" "Executing NAS healthchecks"
  if sshpass -p 12shroot ssh -q -A -t -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$lms_ip "$cmd";then
    return 0
  else
    return 1
  fi
}

getNasIloAddress(){
  local deployment_id=$1 nas_ilo_ip_1 nas_ilo_ip_2
  nas_ilo_ip_1=$(curl -s -X GET https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/deployment/getNasDetails/$deployment_id/ | python -m json.tool | grep nasInstallIloIp1 | awk -F':' '{print $2}' | sed 's/"//g;s/,//g;s/ //g')
  nas_ilo_ip_2=$(curl -s -X GET https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/deployment/getNasDetails/$deployment_id/ | python -m json.tool | grep nasInstallIloIp2 | awk -F':' '{print $2}' | sed 's/"//g;s/,//g;s/ //g')
#  nas_ilo_ip=$(curl -s -X GET http://atclvm1225.athtem.eei.ericsson.se:8000/api/deployment/getNasDetails/$deployment_id/ | python -m json.tool | grep nasInstallIloIp1 | awk -F':' '{print $2}' | sed 's/"//g;s/,//g;s/ //g')
  echo "$nas_ilo_ip_1|$nas_ilo_ip_2"
}

