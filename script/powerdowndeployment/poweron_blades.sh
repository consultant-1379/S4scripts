#!/bin/bash
# Blade Power on Script
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
# Name    : poweron_blades.sh
# Date    : xx/01/2024
# Revision: A
# Purpose : This script performs power on of blades associated to a 
#           ENM physical deployment
#
#
# Version Information:
#       Version Who             Date            Comment
#       0.1     estmann         xx/01/2024      Initial draft
#
# Usage   :
#
# ********************************************************************

. ./functions_lib.sh

CLUSTER_ID=$1
HALT_ON_ERRORS=$2
FAST_POWERON=$3
SKIP_ENM_CHECKS=$4

check_sg_started(){
  counter=1
  while [ $counter -le 25 ];do
    echo "INFO: Checking status of ENM services on cluster $cluster_present ($counter of 25)"
    vcs_cmd_output=$(sshpass -p 12shroot ssh -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --groups -c $cluster_present")
    echo "$vcs_cmd_output" > vcs_checks.txt
#    if [ -z "$vcs_cmd_output" ];then
    if [ ! -s vcs_checks.txt ];then
      echo "ERROR: Command to get ENM cluster $cluster_present info failed in LMS !"
      if [ $HALT_ON_ERRORS = 'yes' ];then
        exit 1
      fi
    else
      cat vcs_checks.txt
    fi
#    vcs_sg_status=$(grep 'Invalid' vcs_checks.txt)
#    if [ -z "$vcs_sg_status" ];then
    if ! grep -q 'Invalid' vcs_checks.txt;then
      echo "INFO: All ENM services for group $cluster_present are started"
      break
    fi
#    if [ ! -z "$vcs_sg_status" ] && [[ $counter == '25' ]];then
    if grep -q 'Invalid' vcs_checks.txt && [[ $counter == '25' ]];then
      echo "ERROR: ENM services for group $cluster_present are not started"
      if [ $HALT_ON_ERRORS = 'yes' ];then
        exit 1
      fi
    fi
    sleep 300
    ((counter++))
  done
}

setVars

## Begin of poweron blades

echo "INFO: Download SED file from DMT"
downloadSedFile

clusters_pwr_on_prio="db_cluster svc_cluster scp_cluster evt_cluster str_cluster ebs_cluster asr_cluster eba_cluster"

#clusters_pwr_on_prio="db_cluster svc_cluster"

#echo "INFO: Get ip address of LMS"
lms_ip=$(getDataFromSed LMS_IP)
if [ -z "$lms_ip" ];then
  echo "ERROR: LMS ip not found in sed file !"
  exit 1
else
  echo "INFO: LMS ip: $lms_ip"
fi

echo "INFO: check that vcs.bsh script is properly running on LMS host"
vcs_script_check=$(sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --help;echo cmd_status \$?" | grep cmd_status | awk '{print $2}' | sed 's/[^0-9]*//g')
if [ $vcs_script_check -ne 0 ];then
  err_msg="ERROR: /opt/ericsson/enminst/bin/vcs.bsh script is not working"
  echo $err_msg | tee $LOG
  echo "INFO: Information about cluster configuration will be got from SED file and power on w/o ENM checks will be executed"
  SKIP_ENM_CHECKS="yes"
  clusters=$(grep hostname $SED_FILE | grep 'db\|svc\|scp\|evt\|str\|ebs\|asr\|eba' | awk -F'_' '{print $1"_cluster"}' | sort | uniq)
  if [ -z "$clusters" ];then
    err_msg="ERROR: No ENM clusters have been detected in SED file ! Powerdown cannot proceed ..."
    echo $err_msg | tee $LOG
    exit 1
  fi
else
  clusters=$(sshpass -p 12shroot ssh -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --systems" | grep cluster | awk '{print $3}' | sort | uniq | grep -v 'not\|undiscovered')
  if [ -z "$clusters" ];then
    echo "ERROR: No running ENM clusters have been detected in LMS !"
    exit 1
  else
    echo "INFO: Following ENM clusters have been found:" $clusters
  fi
fi

for cluster_pwr_on_prio in $clusters_pwr_on_prio;do
  if [[ $clusters == *"$cluster_pwr_on_prio"* ]];then
    clusters_present="$clusters_present $cluster_pwr_on_prio"
  fi
done

for cluster_present in $clusters_present;do
  echo "INFO: Power on nodes of cluster $cluster_present"
  blade_pwr_on_prio=$(echo $cluster_present | sed 's/_cluster//g')
  nodes=$(getNodesFromSed ${blade_pwr_on_prio}_node)
  echo "INFO: Following nodes have been found in SED file: $nodes"
  for node in $nodes;do
    #echo "INFO: Getting ILO ip for node $node from SED file"
    node_ilo_ip=$(getDataFromSed ${node}_ilo_IP)
    if [ ! -z "$node_ilo_ip" ];then
      echo "INFO: Checking if node $node ($node_ilo_ip) is powered on"
      power_state=$(sudo curl -s -L -k --user root:shroot12 -X GET https://$node_ilo_ip/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
      if [[ "$power_state" == *"On"* ]];then
        echo "INFO: Node $node ($node_ilo_ip) is already powered on"
	nodes_powered="$nodes_powered $node"
        continue
      else  
        echo "INFO: Power on node $node (ilo ip -> $node_ilo_ip)"
        echo "INFO: sudo curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"On\"}' -X POST https://$node_ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
        sudo curl -s -L -k --user root:shroot12 -H "Content-Type: application/json" -d '{"ResetType": "On"}' -X POST https://$node_ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset
        sleep 10
        counter=1
        while [ $counter -le 3 ];do        
	  echo "INFO: Checking if node $node ($node_ilo_ip) is powered on ($counter of 3)"
          power_state=$(sudo curl -s -L -k --user root:shroot12 -X GET https://$node_ilo_ip/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
          if [[ "$power_state" == *"On"* ]];then
            echo "INFO: Node $node ($node_ilo_ip) has been powered on"
            break
          fi
          if [[ "$power_state" != *"On"* ]] && [[ $counter == '3' ]];then
            echo "ERROR: Node $node ($node_ilo_ip) has not been powered on !"
	    if [ $HALT_ON_ERRORS = 'yes' ];then
              exit 1
	    fi
          fi
          echo "INFO: Waiting 10 seconds"
          sleep 10
          ((counter++))
        done
      fi
    else
      echo "ERROR: Node $node ILO ip has not found in SED file !"
    fi
  done
  nodes_powered="${nodes_powered##*( )}"
  if [[ $nodes_powered != $nodes ]];then
    if [[ $SKIP_ENM_CHECKS == "no" ]];then
      if [[ $FAST_POWERON == "no" ]];then
        echo "INFO: Waiting 900 seconds for nodes of cluster $cluster_present to startup"
        sleep 900
        check_sg_started
      elif [[ $FAST_POWERON == "yes" ]] && [[ $cluster_present == "db_cluster" ]];then
        echo "INFO: Waiting 900 seconds for nodes of cluster $cluster_present to startup"
        sleep 900
        check_sg_started
      else
        echo "INFO: Fast power up of cluster $cluster_present is executed (240 seconds)"
        sleep 240
      fi
    else
      echo "INFO: Waiting 240 seconds for nodes of cluster $cluster_present to startup"
      sleep 240
    fi
  fi
done

if [[ $SKIP_ENM_CHECKS == "no" ]];then
  if [[ $FAST_POWERON == "yes" ]];then
    counter=1
    while [ $counter -le 25 ];do
      echo "INFO: Checking status of ENM services ($counter of 25)"
      vcs_cmd_output=$(sshpass -p 12shroot ssh -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --groups")
      echo "$vcs_cmd_output" > vcs_checks_all_sg.txt
      if [ ! -s vcs_checks_all_sg.txt ];then
#      if [ -z "$vcs_cmd_output" ];then
        echo "ERROR: Command to get ENM SGs failed in LMS !"
        if [ $HALT_ON_ERRORS = 'yes' ];then
          exit 1
        fi
      else
        cat vcs_checks_all_sg.txt
      fi
#      vcs_sg_status=$(grep 'Invalid' vcs_checks_all_sg.txt)
#      if [ -z "$vcs_sg_status" ];then
      if ! grep -q 'Invalid' vcs_checks_all_sg.txt;then
        echo "INFO: All ENM services are started"
        break
      fi
#      if [ ! -z "$vcs_sg_status" ] && [[ $counter == '25' ]];then
      if grep -q 'Invalid' vcs_checks_all_sg.txt && [[ $counter == '25' ]];then
        echo "ERROR: ENM services are not started"
        if [ $HALT_ON_ERRORS = 'yes' ];then
          exit 1
        fi
      fi
      sleep 300
      ((counter++))
    done
  fi  
fi
