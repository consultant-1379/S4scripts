#!/bin/bash

LMS_SERVER=$1
WORKLOAD_COMMAND="/opt/ericsson/enmutils/bin/workload"
NODE_FILES_DIR="/opt/ericsson/enmutils/etc/nodes/"

copy_node_files_from_lms(){

  echo "$FUNCNAME - $(date)"	
  echo "Setup nodes folder on WORKLOAD_SERVER"
  rm -rf $NODE_FILES_DIR
  mkdir -p $NODE_FILES_DIR
  echo "Copying nodes files from LMS to WORKLOAD_SERVER"
  scp -r root@$LMS_SERVER:$NODE_FILES_DIR/*nodes $NODE_FILES_DIR
}

add_nodes_to_workload_pool(){
  
  echo "$FUNCNAME - $(date)"
  echo "Add nodes to workload pool on WORKLOAD_SERVER"
  for FILE in $(ls $NODE_FILES_DIR | egrep -v failed);do
    echo "Add $FILE to workload pool"
    $WORKLOAD_COMMAND add $NODE_FILES_DIR/$FILE
  done
  echo "Nodes have been added to workload pool on WORKLOAD_SERVER"

}

start_workload_profiles(){

  echo "$FUNCNAME - $(date)"
  echo "Start workload profiles on WORKLOAD_SERVER"
  $WORKLOAD_COMMAND start all

}

set -ex
copy_node_files_from_lms
add_nodes_to_workload_pool
start_workload_profiles
