#!/bin/bash

#. ${BASEDIR}/../functions

BASEDIR=`dirname $0`
NETSIM=$1
#CLUSTER_ID=$2
FETCH_DIR=/var/rvb/network/$NETSIM
NODES_DIR=/opt/ericsson/enmutils/etc/nodes/
NODES=$NETSIM-nodes

#get_wkl_vm() {
#  local wkl_vm
#  local wkl_vm_url

#  wkl_vm_url=$(wget -q -O - --no-check-certificate "https://cifwk-oss.lmera.ericsson.se/generateTAFHostPropertiesJSON/?clusterId=$CLUSTER_ID&tunnel=true")
#  if [[ "$wkl_vm_url" == *"Error"* ]];then
#     echo $wkl_vm_url
#     exit 1
#  else
#    WKL_VM=$(echo $wkl_vm_url | grep -oP "^.*workload" | tail -c 34 | awk -F "," '{print $1}' | sed -r 's/"//g')
#  fi
# echo $WKL_VM
#}


create_network_dir_for_fetch() {
    echo "$FUNCNAME - $(date)"
    mkdir -p $FETCH_DIR
#    rm -rf $FETCH_DIR/*
}

fetch_arne_xmls_from_netsim() {
    echo "$FUNCNAME - $(date)"
    /opt/ericsson/enmutils/bin/netsim fetch $NETSIM $FETCH_DIR
}

parse_network() {
    echo "$FUNCNAME - $(date)"
    /opt/ericsson/enmutils/bin/node_populator parse $NODES_DIR$NODES $FETCH_DIR --skip-validation
}

populate_network() {
    echo "$FUNCNAME - $(date)"
    echo "/opt/ericsson/enmutils/bin/node_populator create $NODES_DIR$NODES --verbose"
}

#add_nodes_to_workload_pool() {
#    /opt/ericsson/enmutils/bin/workload add $NODES
#}


set -ex
create_network_dir_for_fetch
fetch_arne_xmls_from_netsim
parse_network
#get_deployment_conf $CLUSTERID
populate_network
#add_nodes_to_workload_pool


echo "Operations Completed - $(date)"


