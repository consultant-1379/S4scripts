#!/bin/bash

#. ${BASEDIR}/../functions

BASEDIR=`dirname $0`
NETSIM=$1
#CLUSTER_ID=$2
FETCH_DIR=/var/rvb/network/$NETSIM
NODES=$NETSIM-nodes
NODES_FILE=/opt/ericsson/enmutils/etc/nodes/$NODES
NODES_DIR="/opt/ericsson/enmutils/etc/nodes/"
NETSIM_CMD="/opt/ericsson/nssutils/bin/netsim"
NODE_POPULATOR_CMD="/opt/ericsson/nssutils/bin/node_populator"

#create_network_dir_for_fetch() {
#    echo "$FUNCNAME - $(date)"
#    echo "Removing existing directory with fetched arne files ($FETCH_DIR)"
#    rm -rf $FETCH_DIR/*
#    echo "Create directory ($FETCH_DIR) for fetching arne files from Netsim simulations"
#    mkdir -p $FETCH_DIR
#    echo "Removing existing parsed nodes files ($NODES_FILE)"
#    rm -rf $NODES_FILE
#    echo "Create directory for parsed nodes files ($NODES_FILE)"
#    mkdir -p $NODES_DIR
#    rm -rf $FETCH_DIR/*
#}

#fetch_arne_xmls_from_netsim() {
#    echo "$FUNCNAME - $(date)"
#    echo "Fetching arne files for Netsim $NETSIM"
#    $NETSIM_CMD fetch -f $NETSIM $FETCH_DIR
#}

#parse_network() {
#    echo "$FUNCNAME - $(date)"
#    echo "Parsing nodes file for Netsim $NETSIM"
#    $NODE_POPULATOR_CMD parse $NODES_FILE $FETCH_DIR --skip-validation
##    $NODE_POPULATOR_CMD parse $NODES_FILE $FETCH_DIR
#}

populate_network() {
    echo "$FUNCNAME - $(date)"
    echo "Creating nodes in ENM for Netsim $NETSIM"
    $NODE_POPULATOR_CMD create $NODES_FILE --verbose
}

#add_nodes_to_workload_pool() {
#    /opt/ericsson/enmutils/bin/workload add $NODES
#}


set -ex

#random sleep for concurrent script execution
sleep $[ ( $RANDOM % 100 )  + 1 ]s

#create_network_dir_for_fetch
#fetch_arne_xmls_from_netsim
#parse_network
#get_deployment_conf $CLUSTERID
populate_network
#add_nodes_to_workload_pool


echo "Operations Completed - $(date)"


