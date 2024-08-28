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
COLD_POWERDOWN=$2


setVars

## Begin of powerdown blades

  enm_clusters=$(getEnmClusters)

  clusters_pwr_down_prio="asr_cluster ebs_cluster eba_cluster str_cluster evt_cluster scp_cluster svc_cluster db_cluster"

  if [ "$COLD_POWERDOWN" == "no" ];then
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
      if [ ! -z "$node_ilo_ip" ];then
        echo "$node $node_ilo_ip" >> ${CLUSTER_ID}_node_ilo_ip.txt
      else
	echo "$node NOT_FOUND" >> ${CLUSTER_ID}_node_ilo_ip.txt
      fi
    done
  done
  echo "INFO: Powering off nodes"
  while IFS= read -r line;do
    node=$(echo "$line" | awk '{print $1}')
    ilo_ip=$(echo "$line" | awk '{print $2}')
    if [[ "$ilo_ip" != "NOT_FOUND" ]];then
      echo "INFO: Power off node $node (ilo ip -> $ilo_ip)"
      echo "curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"ForceOff\"}' -X POST https://$ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
      curl -s -L -k --user root:shroot12 -H "Content-Type: application/json" -d '{"ResetType": "ForceOff"}' -X POST https://$ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset
    else
      echo "ERROR: ilo ip not found for node $node. Powerdown not executed !"
    fi
done < ${CLUSTER_ID}_node_ilo_ip.txt

  nodes_still_powered=""
  counter=1

    echo "INFO: Checking if nodes are powered off ($counter of 3)"
    echo "INFO: Waiting 10 seconds"
    sleep 10

    while IFS= read -r line;do
      node=$(echo "$line" | awk '{print $1}')
      ilo_ip=$(echo "$line" | awk '{print $2}')
      if [[ "$ilo_ip" != "NOT_FOUND" ]];then
	while [ $counter -le 3 ];do
	  echo "INFO: Checking if node $node ($ilo_ip) is powered off ($counter of 3)"
          power_state=$(curl -s -L -k --user root:shroot12 -X GET https://$ilo_ip/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
          #  echo "INFO: Node $node ($ilo_ip) $power_state"
          if [[ "$power_state" == *"Off"* ]];then
            echo "INFO: Node $node ($ilo_ip) has been powered off"
	    break
          fi
	  if [[ "$power_state" == *"On"* ]] && [[ $counter == '3' ]];then
            echo "ERROR: Node $node ($ilo_ip) has not been powered off !"
          fi
	  echo "INFO: Waiting 10 seconds"
          sleep 10
	  ((counter++))
        done  
      fi
#       nodes_still_powered="$nodes_still_powered $node"

    done < ${CLUSTER_ID}_node_ilo_ip.txt

 #   if [ ! -z "$nodes_still_powered" ];then
 #     echo "INFO: There are nodes still powered on -> $nodes_still_powered"
 #   fi
    nodes_still_powered=""
    counter=$(( $counter + 1 ))
    #if [ ! -z "$nodes_still_powered" ] && [ $counter -gt 3 ];then
    #  exit 1
    #fi

#  done
##end of powerdown blades

