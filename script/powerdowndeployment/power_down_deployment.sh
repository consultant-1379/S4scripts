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

while getopts "f:s:b:c:n:" option
do
  case "${option}"
  in
    c) CLUSTER_ID=${OPTARG};;
    s) SKIP_ENM_HC=${OPTARG};;
    f) COLD_POWERDOWN=${OPTARG};;
    b) POWERDOWN_BLADES=${OPTARG};;
    n) POWERDOWN_NAS=${OPTARG};;
    :) echo "Option -${OPTARG} requires an argument."; exit 1;;
    *) echo "Invalid input ${OPTARG}"; usage; exit 1 ;;
  esac
done

echo "INFO: Skip ENM hc -> $SKIP_ENM_HC"
echo "INFO: Force ENM shutdown -> $FORCE_ENM_SHUTDOWN"


echo "INFO: Setting global variables"

setVars

if [ "$SKIP_ENM_HC" == "false" ];then
  echo "INFO: Executing ENM hc"
  if executeEnmHc;then
    echo "INFO: ENM hc have been successfully completed"
  else
    echo "ERROR: ENM hc have failed !"
    exit 1
  fi
else
  echo "WARNING: ENM hc have been skipped !"
fi

## Begin of powerdown blades

if [ "$POWERDOWN_BLADES" == "true" ];then

  enm_clusters=$(getEnmClusters)

  clusters_pwr_down_prio="asr_cluster ebs_cluster eba_cluster str_cluster evt_cluster scp_cluster svc_cluster db_cluster"

  if [ "$COLD_POWERDOWN" == "false" ];then
    for cluster_pwr_down_prio in $clusters_pwr_down_prio;do
      echo "INFO: Getting list of sg associated to cluster $cluster_pwr_down_prio"
      if [[ "$enm_clusters" == *"$cluster_pwr_down_prio"* ]];then
        enm_sgs=$(getSgOfCluster $cluster_pwr_down_prio)
        enm_sgs_no_lvs=$(echo $enm_sgs | sed 's/Grp_CS_.*lvsrouter//g')
        enm_sg_lvs_router=$(echo $enm_sgs | tr " " "\n" | grep lvsrouter)
        echo "$enm_sgs_no_lvs" 
        for enm_sg_no_lvs in $enm_sgs_no_lvs;do
          echo "INFO: Stopping sg $enm_sg_no_lvs"
          if stopSgOfCluster $enm_sg_no_lvs;then
            echo "INFO: Sg $enm_sg_no_lvs has been successfully stopped"
          fi
        done
        if [ ! -z "$enm_sg_lvs_router" ];then
          echo "INFO: Stopping sg $enm_sg_lvs_router"
          if stopSgOfCluster $enm_sg_lvs_router;then
            echo "INFO: Sg $enm_sg_lvs_router has been successfully stopped"
          fi
        fi
      else
        echo "WARNING: Cluster $cluster_pwr_down_prio is not present !"
      fi
    done
  else
    echo "WARNING: Force ENM shutdown option will not stop ENM services !"
  fi

  echo "INFO: Download SED file from DMT"
  downloadSedFile

  blades_pwr_down_prio=$(echo $clusters_pwr_down_prio | sed 's/_cluster//g')

  if test -f "${CLUSTER_ID}_node_ilo_ip.txt";then
    rm -rf ${CLUSTER_ID}_node_ilo_ip.txt
  fi

  touch ${CLUSTER_ID}_node_ilo_ip.txt

  echo "INFO: Get ILO ip addresses of nodes"
  for blade_pwr_down_prio in $blades_pwr_down_prio;do
    nodes=$(getNodesFromSed ${blade_pwr_down_prio}_node)
    for node in $nodes;do
      node_ilo_ip=$(getDataFromSed ${node}_ilo_IP)
      echo "$node $node_ilo_ip" >> ${CLUSTER_ID}_node_ilo_ip.txt
    done
  done

  echo "INFO: Powering off nodes"
  while IFS= read -r line;do
    node=$(echo "$line" | awk '{print $1}')
    ilo_ip=$(echo "$line" | awk '{print $2}')
    echo "INFO: Power off node $node (ilo ip -> $ilo_ip)"
    echo "curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"ForceOff\"}' -X POST https://$ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
  done < ${CLUSTER_ID}_node_ilo_ip.txt

  nodes_still_powered=""
  counter=1

  while [ $counter -le 3 ];do

    echo "INFO: Checking if nodes are powered off ($counter of 3)"
    echo "INFO: Waiting 10 seconds"
    sleep 10

    while IFS= read -r line;do
      node=$(echo "$line" | awk '{print $1}')
      ilo_ip=$(echo "$line" | awk '{print $2}')
      power_state=$(curl -s -L -k --user root:shroot12 -X GET https://$node_ilo_ip/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
      #  echo "INFO: Node $node ($ilo_ip) $power_state"
      if [[ "$power_state" == *"On"* ]];then
        nodes_still_powered="$nodes_still_powered $node"
      fi
    done < ${CLUSTER_ID}_node_ilo_ip.txt

    if [ ! -z "$nodes_still_powered" ];then
      echo "INFO: There are nodes still powered on -> $nodes_still_powered"
    fi
    nodes_still_powered=""
    counter=$(( $counter + 1 ))
    #if [ ! -z "$nodes_still_powered" ] && [ $counter -gt 3 ];then
    #  exit 1
    #fi

  done
fi
##end of powerdown blades

## Begin of powerdown NAS
if [ "$POWERDOWN_NAS" == "true" ];then

  echo "INFO: Get ILO ip addresses of NAS nodes"

  nas_details=$(curl -s -L -k https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/deployment/getNasDetails/${CLUSTER_ID}/ | python -m json.tool)
  nas_ilo_ip1=$(echo "$nas_details" | grep "nasInstallIloIp1" | awk '{print $2}' | sed 's/"//g' | sed 's/,//g')
  nas_ilo_ip2=$(echo "$nas_details" | grep "nasInstallIloIp2" | awk '{print $2}' | sed 's/"//g' | sed 's/,//g')

  echo "nas_ilo_ip1: $nas_ilo_ip1"
  echo "nas_ilo_ip2: $nas_ilo_ip2"
  if [ "$COLD_POWERDOWN" == "false" ];then
    echo "INFO: Power off node $node (ilo ip -> $nas_ilo_ip1)"
    echo "curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"ForceOff\"}' -X POST https://$nas_ilo_ip1/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"

    echo "INFO: Power off node $node (ilo ip -> $nas_ilo_ip2)"
    echo "curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"ForceOff\"}' -X POST https://$nas_ilo_ip2/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"

    curl -s -L -k --user root:shroot12 -X GET https://$nas_ilo_ip1/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},"
    curl -s -L -k --user root:shroot12 -X GET https://$nas_ilo_ip2/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},"
  fi
  echo "INFO: Get nas console info from sed file"
  sfs_console_ip=$(getNasConsoleIp)
  if [[ $sfs_console_ip == '1' ]];then
    exit 1
  fi

  sfssetup_username=$(getNasConsoleSetupUsername)
  if [[ $sfssetup_username == '1' ]];then
    exit 1
  fi

  sfssetup_password=$(getNasConsoleSetupPassword)
  if [[ $sfssetup_password == '1' ]];then
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

  echo "INFO: Shutdown nas slave host $nas_slave_host"
  shutdown_nas_host $sfssetup_username $sfssetup_password $sfs_console_ip $nas_slave_host

  counter=0

  while [ $counter -le 3 ];do

    echo "INFO: Checking if NAS slave host is powered off ($counter of 3)"
    echo "INFO: Waiting 10 seconds"
    sleep 10

    power_state=$(curl -s -L -k --user root:shroot12 -X GET https://$nas_ilo_ip1/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
    #  echo "INFO: Node $node ($ilo_ip) $power_state"
    if [[ "$power_state" == *"Off"* ]];then
      echo "INFO: NAS slave node is powered off"
      break
    fi
    counter=$(( $counter + 1 ))
    if [ $counter -gt 3 ];then
      echo "ERROR: NAS slave node is still powered on !"
      #  exit 1
    fi
  done

  echo "INFO: Shutdown nas master host $nas_master_host"
  shutdown_nas_host $sfssetup_username $sfssetup_password $sfs_console_ip $nas_master_host

  counter=0

  while [ $counter -le 3 ];do

    echo "INFO: Checking if NAS master host is powered off ($counter of 3)"
    echo "INFO: Waiting 10 seconds"
    sleep 10

    power_state=$(curl -s -L -k --user root:shroot12 -X GET https://$nas_ilo_ip2/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
    #  echo "INFO: Node $node ($ilo_ip) $power_state"
    if [[ "$power_state" == *"Off"* ]];then
      echo "INFO: NAS master node is powered off"
      break
    fi
    counter=$(( $counter + 1 ))
    if [ $counter -gt 3 ];then
      echo "ERROR: NAS master node is still powered on !"
      #  exit 1
    fi
  done
fi
## End of powerdown NAS

