#!/bin/bash

#. ${BASEDIR}/../functions

BASEDIR=`dirname $0`
NETSIM=$1
NODES=$NETSIM-nodes
NODES_FILE=/opt/ericsson/enmutils/etc/nodes/$NODES
NETSIM_CMD="/opt/ericsson/nssutils/bin/netsim"
NODE_POPULATOR_CMD="/opt/ericsson/nssutils/bin/node_populator"

delete_network() {
    echo "$FUNCNAME - $(date)"
    echo "Deleting nodes in ENM for Netsim $NETSIM"
    $NODE_POPULATOR_CMD delete $NODES_FILE --verbose
}

set -ex

#random sleep for concurrent execution
sleep $[ ( $RANDOM % 100 )  + 1 ]s

delete_network
echo "Operations Completed - $(date)"


