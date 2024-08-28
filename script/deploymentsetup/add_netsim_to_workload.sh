#!/bin/bash

NETSIM=$1
WORKLOAD_COMMAND="/opt/ericsson/enmutils/bin/workload"
NODE_FILES_DIR="/opt/ericsson/enmutils/etc/nodes/"
NODES=$NETSIM-nodes
NODES_FILE=/opt/ericsson/enmutils/etc/nodes/$NODES

add_nodes_to_workload_pool(){
  
  echo "$FUNCNAME - $(date)"
  echo "Add nodes to workload pool on WORKLOAD_SERVER"
  $WORKLOAD_COMMAND add $NODES_FILE
}

set -ex
add_nodes_to_workload_pool
