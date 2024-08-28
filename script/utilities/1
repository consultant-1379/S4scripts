#!/bin/bash

#set -x

debug_mode=$4
cluster_id=$1
selection=$2
deployment_type=$3

CIFWK_URL="https://ci-portal.seli.wh.rnd.internal.ericsson.com"

lookup_host_from_ip() {
  local ipaddr=$1
  local host_name
  host_name=$(nslookup $ipaddr | grep name | awk '{print $4}' | awk -F'.' '{print $1}')
  echo $host_name

}

check_ip_is_valid() {
  local ipaddr=$1
  if [[ $ipaddr =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];then
    echo "true"
  else
    echo "false"
  fi
}

get_lms_host() {
  local msip
  local ip_valid
  local lms_host
  msip=$(wget -q -O - --no-check-certificate "${CIFWK_URL}/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true" | awk -F',' '{print $5}' | awk -F':' '{print $2}' | sed -e "s/\"//g" -e "s/ //g")
#  msip=$(wget -q -O - --no-check-certificate "https://cifwk-oss.lmera.ericsson.se/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true" | awk -F',' '{print $5}' | awk -F':' '{print $2}' | sed -e "s/\"//g" -e "s/ //g")
  ip_valid=$(check_ip_is_valid $msip)
#  exit_status=$?
  if [[ $ip_valid == "true" ]];then
    lms_host=$(lookup_host_from_ip $msip)
    echo $lms_host
  else
    echo "ERROR: FAILURE IN GETTING LMS HOST FROM DMT !"
  fi
}

get_workload_host_physical() {
  local wkl_vm_url
  local wkl_vm
  wkl_vm=$(wget -q -O - --no-check-certificate "${CIFWK_URL}/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true" | grep -oP "^.*workload" | tail -c 34 | awk -F "," '{print $1}' | sed -r 's/"//g' | sed 's/ //g')
#  wkl_vm=$(wget -q -O - --no-check-certificate "https://cifwk-oss.lmera.ericsson.se/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true" | grep -oP "^.*workload" | tail -c 34 | awk -F "," '{print $1}' | sed -r 's/"//g' | sed 's/ //g')
  if [[ "$wkl_vm" == *"ieatwlvm"* ]]; then
    echo $wkl_vm
  else
    echo "ERROR: FAILURE IN GETTING WORKLOAD HOST FROM DMT !"
  fi
}

get_workload_host_cloud() {
  local wklvmip
  local ip_valid
  local workload_host
  wklvmip=$(wget -q -O - --no-check-certificate "${CIFWK_URL}/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true" | awk -F',' '{print $9}' | awk -F'"' '{print $4}')
#  wklvmip=$(wget -q -O - --no-check-certificate "https://cifwk-oss.lmera.ericsson.se/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true" | awk -F',' '{print $9}' | awk -F'"' '{print $4}')
  ip_valid=$(check_ip_is_valid $wklvmip)
  if [[ $ip_valid == "true" ]];then
    workload_host=$(lookup_host_from_ip $wklvmip)
    echo $workload_host
  else
    echo "ERROR: FAILURE IN GETTING WORKLOAD HOST FROM DMT !"
  fi
}

get_all_netsim_hosts() {
  local netsims
  netsims=$(wget -q -O - --no-check-certificate "${CIFWK_URL}/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true&pretty=true&allNetsims=true" | grep netsim | grep hostname | awk -F"\"" '{print $4}')
#  netsims=$(wget -q -O - --no-check-certificate "https://cifwk-oss.lmera.ericsson.se/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true&pretty=true&allNetsims=true" | grep netsim | grep hostname | awk -F"\"" '{print $4}')
  if [[ "$netsims" == *"ieatnetsim"* ]]; then
    echo $netsims
  else
    echo "ERROR: FAILURE IN GETTING NETSIM HOSTS FROM DMT !"
  fi
}

#Main
set -e

if [[ $debug_mode == "debug" ]];then
  set -x
fi 

case "$selection" in
  lms|LMS)  
    dmt_host=$(get_lms_host)	
    ;;
  workload|WORKLOAD)  
    if [[ $deployment_type == "Cloud" ]];then
      dmt_host=$(get_workload_host_cloud)
    else
      if [[ $deployment_type == "Physical" ]];then
	dmt_host=$(get_workload_host_physical) 
      fi
    fi  
    ;;
  netsim|NETSIM) 
    dmt_host=$(get_all_netsim_hosts)  	
    ;;
  *) 
    echo "Wrong selection $selection !"
    exit 1
   ;;
esac

if [[ $dmt_host == *ERROR* ]];then
  echo $dmt_host
  exit 1
else
  echo $dmt_host
  exit 0
fi

