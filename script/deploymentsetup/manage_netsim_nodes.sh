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

manage_network() {
    echo "$FUNCNAME - $(date)"
    echo "Activating Supervision of nodes in ENM for Netsim $NETSIM"
    $NODE_POPULATOR_CMD manage $NODES_FILE --verbose
}

set -ex
#random sleep for concurrent script execution
sleep $[ ( $RANDOM % 100 )  + 1 ]s

manage_network

echo "Operations Completed - $(date)"


