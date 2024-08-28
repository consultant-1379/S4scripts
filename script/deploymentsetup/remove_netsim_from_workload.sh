#!/bin/bash

NETSIM=$1
WORKLOAD_COMMAND="/opt/ericsson/enmutils/bin/workload"
NODE_FILES_DIR="/opt/ericsson/enmutils/etc/nodes/"
NODES=$NETSIM-nodes
NODES_FILE=/opt/ericsson/enmutils/etc/nodes/$NODES

remove_nodes_from_workload_pool(){
  
  echo "$FUNCNAME - $(date)"
  echo "Remove nodes from workload pool on WORKLOAD_SERVER"
  $WORKLOAD_COMMAND remove $NODES_FILE
}

set -ex
remove_nodes_from_workload_pool
