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
COLD_POWERDOWN=$2
HALT_ON_ERRORS=$3
FAST_POWERDOWN=$4

BASEDIR=`dirname $0`

setVars

## Begin of powerdown blades

echo "INFO: Download SED file from DMT"
downloadSedFile

blades_pwr_down_prio=$(echo $clusters_pwr_down_prio | sed 's/_cluster//g')
clusters_pwr_down_prio="asr_cluster ebs_cluster eba_cluster str_cluster evt_cluster scp_cluster svc_cluster db_cluster"
#echo "INFO: Get ip address of LMS"
lms_ip=$(getDataFromSed LMS_IP)
if [ -z "$lms_ip" ];then
  err_msg="ERROR: LMS ip not found in sed file ! Powerdown cannot proceed ..."	
  echo $err_msg | tee $LOG
  exit 1
else
  echo "INFO: LMS ip: $lms_ip"
fi

echo "INFO: check that vcs.bsh script is properly running on LMS host"
vcs_script_check=$(sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --help;echo cmd_status \$?" | grep cmd_status | awk '{print $2}' | sed 's/[^0-9]*//g')
if [ $vcs_script_check -ne 0 ];then
  err_msg="ERROR: /opt/ericsson/enminst/bin/vcs.bsh script is not working"
  echo $err_msg | tee $LOG
  echo "INFO: Information about cluster configuration will be got from SED file and cold powerdown will be executed"
  COLD_POWERDOWN="yes"
  clusters=$(grep hostname $SED_FILE | grep 'db\|svc\|scp\|evt\|str\|ebs\|asr\|eba' | awk -F'_' '{print $1"_cluster"}' | sort | uniq)
  if [ -z "$clusters" ];then
    err_msg="ERROR: No ENM clusters have been detected in SED file ! Powerdown cannot proceed ..."
    echo $err_msg | tee $LOG
    exit 1
  fi
  
else
  cluster_info=$(sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --systems")

  clusters=$(echo "$cluster_info"| grep RUNNING | grep cluster | awk '{print $3}' | sort | uniq)

  if [ -z "$clusters" ];then
#   clusters=$(grep hostname $SED_FILE | grep 'db\|svc\|scp\|evt\|str\|ebs\|asr\|eba' | awk -F'_' '{print $1"_cluster"}' | sort | uniq)
    if [ -z "$clusters" ];then
      err_msg="ERROR: No running ENM clusters have been detected in LMS !"
#    err_msg="ERROR: ENM cluster not detected! Powerdown cannot proceed ..."
      echo $err_msg | tee $LOG
      exit 1
    fi
  else
    echo "INFO: Following ENM clusters have been found:" $clusters
  fi
fi

for cluster_pwr_down_prio in $clusters_pwr_down_prio;do
  if [[ $clusters == *"$cluster_pwr_down_prio"* ]];then
    clusters_present="$clusters_present $cluster_pwr_down_prio"
  fi
done

for cluster_present in $clusters_present;do
  if [ "$COLD_POWERDOWN" == "no" ];then
    faulted_sg=$(sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --groups" | grep FAULTED | awk '{print $2}' | sort | uniq)
    if [ ! -z "$faulted_sg" ];then
      err_msg="INFO: Faulted SGs have been found. Clearing them ..."
      echo $err_msg | tee $LOG
      echo $faulted_sg | tee $LOG
      for enm_sg in $faulted_sg;do
        echo "sshpass -p 12shroot ssh -q -tt root@$lms_ip \"/opt/ericsson/enminst/bin/vcs.bsh --clear -g $enm_sg\""
        sshpass -p 12shroot ssh -q -tt root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --clear -g $enm_sg"
      done
    fi
    echo "INFO: Getting ENM services of cluster $cluster_present"
    enm_sgs=$(sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --groups -c $cluster_present" | grep $cluster_present | tail -n +2 | awk '{print $2}' | sort | uniq)  
    echo "INFO: ENM services of cluster $cluster_present:"
    enm_sgs_nc=$(echo $enm_sgs | sed "s/Grp_CS_${cluster_present}_//g")
    echo $enm_sgs_nc
    enm_sgs_no_lvs_router=$(echo "$enm_sgs" | grep -v lvsrouter)
    lvs_router_sg=$(echo "$enm_sgs" | grep lvsrouter)
    enm_sgs_to_stop="$enm_sgs_no_lvs_router $lvs_router_sg"
    echo "INFO: Stopping ENM services of cluster $cluster_present"
    for enm_sg in $enm_sgs_to_stop;do
      sg_status=$(sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --groups -g $enm_sg" | grep $enm_sg | awk '{print $6}' | sort | uniq)  
      if [[ "$sg_status" == "OFFLINE" ]];then
        echo "INFO: ENM Service Group $enm_sg is already offline"
        continue
      fi
      echo "sshpass -p 12shroot ssh -q -tt root@$lms_ip \"/opt/ericsson/enminst/bin/vcs.bsh --offline -g $enm_sg\""
      sshpass -p 12shroot ssh -q -tt root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --offline -g $enm_sg"

      if [[ $FAST_POWERDOWN == "no" ]];then
        counter=1
        while [ $counter -le 3 ];do
          sg_status=$(sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --groups -g $enm_sg" | grep $enm_sg | awk '{print $6}' | sort | uniq)
          if [[ "$sg_status" != *"OFFLINE"* ]]  && [ $counter -eq 3 ];then
            err_msg="ERROR: Offline of Service Group $enm_sg has failed !"
	    echo $err_msg | tee $LOG
	    if [ $HALT_ON_ERRORS = 'yes' ];then
              exit 1
            fi
            break
          fi

          ((counter++))
        done
      fi
    done
#    lvs_router_sg=$(echo "$enm_sgs" | grep lvsrouter)
#    if [ ! -z "$lvs_router_sg" ];then
#      sg_status=$(sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --groups -g $lvs_router_sg" | grep $lvs_router_sg | awk '{print $6}' | sort | uniq)	
#      if [[ "$sg_status" == "OFFLINE" ]];then
#        echo "INFO: ENM Service Group $lvs_router_sg is already offline"
#        continue
#      fi
#      echo "sshpass -p 12shroot ssh -tt -q root@$lms_ip \"/opt/ericsson/enminst/bin/vcs.bsh --offline -g $lvs_router_sg\""

#      sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --offline -g $lvs_router_sg"
#      if [[ $FAST_POWERDOWN == "no" ]];then
#        counter=1
#        while [ $counter -le 3 ];do
#          sg_status=$(sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --groups -g $lvs_router_sg" | grep $lvs_router_sg | awk '{print $6}' | sort | uniq)
#	  if [[ "$sg_status" == *"OFFLINE"* ]];then
#            break
#          fi
#          if [[ "$sg_status" != *"OFFLINE"* ]]  && [ $counter -eq 3 ];then
#            echo "ERROR: Offline of Service Group $lvs_router_sg has failed !"
#	    if [ $HALT_ON_ERRORS = 'yes' ];then
#              exit 1
#            fi
#            break
#          fi
#          ((counter++))
#        done
#      fi
#    fi  
  fi
done

if [ "$COLD_POWERDOWN" == "no" ];then
  echo "INFO: Check that all ENM services are OFFLINE (timeout 600 sec)"
  counter=1
  set -xv
  while [ $counter -le 5 ];do
    enm_services=$(sshpass -p 12shroot ssh -tt -q root@$lms_ip "/opt/ericsson/enminst/bin/vcs.bsh --groups")
    enm_services_status=$(echo "$enm_services" | grep Grp_CS | awk '{print $6}' | sort | uniq)
    if [[ "$enm_services_status" == "OFFLINE" ]];then
      break
    fi
    sleep 120
    ((counter++))
  done

  if [[ "$enm_services_status" != "OFFLINE" ]];then
    
    db_services_status=$(echo "$enm_services" | grep db_cluster | grep Grp_CS | awk '{print $6}' | sort | uniq)
    if [ ! -z "$db_services_status" ] && [[ "$db_services_status" != "OFFLINE" ]];then
      err_msg="ERROR: There are db services which are not OFFLINE. Powerdown cannot proceed !"
      echo $err_msg | tee $LOG
      exit 1
    fi
    enm_services_not_offline=$(echo "$enm_services" | grep Grp_CS | grep -v OFFLINE | awk '{print $2}' | sort | uniq)
    err_msg="ERROR: There are ENM services which are not OFFLINE. Powerdown cannot proceed !"
    echo $err_msg | tee $LOG
    echo "$enm_services_not_offline" | tee $LOG  
    if [ $HALT_ON_ERRORS = 'yes' ];then
      exit 1
    fi
  else
    echo "INFO: All ENM services have been stopped. Proceeding with powerdown of nodes"
  fi
  set +xv
fi

for cluster_present in $clusters_present;do
  echo "INFO: Power down nodes of cluster $cluster_present"
  blade_pwr_down_prio=$(echo $cluster_present | sed 's/_cluster//g')
  nodes=$(getNodesFromSed ${blade_pwr_down_prio}_node)
  echo "INFO: Following nodes have been found in SED file: $nodes"
  for node in $nodes;do
    #echo "INFO: Getting ILO ip for node $node from SED file"
    node_ilo_ip=$(getDataFromSed ${node}_ilo_IP)
    if [ ! -z "$node_ilo_ip" ];then
      echo "INFO: Power down node $node (ilo ip -> $node_ilo_ip)"
      echo "INFO: sudo curl -s -L -k --user root:shroot12 -H \"Content-Type: application/json\" -d '{\"ResetType\": \"ForceOff\"}' -X POST https://$node_ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset"
      sudo curl -s -L -k --user root:shroot12 -H "Content-Type: application/json" -d '{"ResetType": "ForceOff"}' -X POST https://$node_ilo_ip/redfish/v1/Systems/1/Actions/ComputerSystem.Reset
      sleep 20
      counter=1
      while [ $counter -le 3 ];do
        echo "INFO: Checking if node $node ($node_ilo_ip) is powered off ($counter of 3)"
        power_state=$(sudo curl -s -L -k --user root:shroot12 -X GET https://$node_ilo_ip/redfish/v1/Systems/1 | egrep -o "PowerState.{1,7},")
        if [[ "$power_state" == *"Off"* ]];then
          echo "INFO: Node $node ($node_ilo_ip) has been powered off"
          break
        fi
        if [[ "$power_state" != *"Off"* ]] && [ $counter -eq 3 ];then
          echo "ERROR: Node $node ($node_ilo_ip) has not been powered off !"
	  if [ $HALT_ON_ERRORS = 'yes' ];then
            exit 1
          fi
        fi
        echo "INFO: Waiting 10 seconds"
        sleep 10
        ((counter++))
      done
    else
      err_msg="ERROR: Node $node ILO ip has not found in SED file !"
      echo $err_msg | tee $LOG
      if [ $HALT_ON_ERRORS = 'yes' ];then
        exit 1
      fi
    fi
  done
done
