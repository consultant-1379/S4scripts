#!/bin/bash

cluster_id=$1

ms_ip() {

  msip=$(wget -q -O - --no-check-certificate "https://ci-portal.seli.wh.rnd.internal.ericsson.com/generateTAFHostPropertiesJSON/?clusterId=${cluster_id}&tunnel=true" | awk -F',' '{print $5}' | awk -F':' '{print $2}' | sed -e "s/\"//g" -e "s/ //g")

}


ms_ip

if [[ $msip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];then
  echo $msip
else
  echo "FAIL"
fi
