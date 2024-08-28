#!/bin/bash

ms_ip() {

  msip=$(wget -q -O - --no-check-certificate "https://ci-portal.seli.wh.rnd.internal.ericsson.com/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true" | awk -F',' '{print $5}' | awk -F':' '{print $2}' | sed -e "s/\"//g" -e "s/ //g")

  if [[ $msip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];then
    echo $msip
    exit 0
  else
    echo "FAILURE IN GETTING LMS ADDRESS FROM DMT !"
    exit 1
  fi
 
}

wkl_vm_host() {

  wkl_vm_url=$(wget -q -O - --no-check-certificate "https://ci-portal.seli.wh.rnd.internal.ericsson.com/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true")
  wkl_vm=$(echo $wkl_vm_url | grep -oP "^.*workload" | tail -c 34 | awk -F "," '{print $1}' | sed -r 's/"//g' | sed 's/ //g')  
  
  if [[ "$wkl_vm" == *"ieatwlvm"* ]]; then
    echo $wkl_vm
    exit 0
  else
    echo "FAILURE IN GETTING WORKLOAD VM HOSTNAME FROM DMT !"
    exit 1
  fi

}

netsim_vm_hosts() {

  netsims=$(wget -q -O - --no-check-certificate "https://ci-portal.seli.wh.rnd.internal.ericsson.com/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true&pretty=true&allNetsims=false" | grep netsim | grep hostname | awk -F"\"" '{print $4}')
  
  if [[ "$netsims" == *"ieatnetsim"* ]]; then
    echo $netsims
    exit 0
  else
    echo "FAILURE IN GETTING NETSIM VM HOSTNAMES FROM DMT !"
    exit 1
  fi

}


cluster_id=$1
selection=$2

case "$selection" in

  lms|LMS)  
    ms_ip	
    ;;
  workload|WORKLOAD)  
    wkl_vm_host
    ;;
  netsim|NETSIM) 
    netsim_vm_hosts  	
    ;;
  *) 
    echo "Wrong selection $selection !"
    exit 1
   ;;
esac
