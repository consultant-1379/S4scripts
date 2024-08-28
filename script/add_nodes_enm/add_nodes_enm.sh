#!/bin/bash

#. ${BASEDIR}/../functions

BASEDIR=`dirname $0`
NODES=$1
TICKET=$2
#CLUSTER_ID=$2
#FETCH_DIR=/var/rvb/network/$NETSIM
#NODES=$NETSIM-nodes
NODES_FILE=/opt/ericsson/enmutils/etc/nodes/
NODES_DIR=/opt/ericsson/enmutils/etc/nodes/
NODES_WORKING_DIR=/opt/ericsson/enmutils/etc/nodes_tmp/$TICKET/
NODES_WORKING_FILE=$NODES_WORKING_DIR/nodestoaddtoenm-nodes
NETSIM_CMD=/opt/ericsson/nssutils/bin/netsim
NODE_POPULATOR_CMD=/opt/ericsson/nssutils/bin/node_populator



extract_node_from_node_files(){
  echo "$FUNCNAME - $(date)"
  nodes_node=$(cat ${NODES_DIR}*nodes | grep -w $node)
  if [ -z "$nodes_node" ];then
    echo "NODE $node HAS NOT BEEN FOUND IN NODES FILES !"
  else
    echo $nodes_node >> $NODES_WORKING_FILE
  fi
}

create_node_file_header(){
  echo "$FUNCNAME - $(date)"
  nodes_file_for_head=$(ls -la $NODES_DIR*nodes | awk '{print $9}' | tail -1)
  node_file_header=$(cat $nodes_file_for_head | head -1)
  echo $node_file_header > $NODES_WORKING_FILE

}

create_working_dir(){
  echo "$FUNCNAME - $(date)"
  mkdir -p $NODES_WORKING_DIR
}

populate_network() {
  echo "$FUNCNAME - $(date)"
  $NODE_POPULATOR_CMD create $NODES_WORKING_FILE --verbose
}

#set -ex

echo "CREATE WORKING DIRECTORY FOR NODE FILE $NODES_WORKING_DIR"
create_working_dir
echo "CREATE HEADER OF NODE FILE"
create_node_file_header
echo "ADD NODES TO NODE FILE"
for node in $NODES;do
  extract_node_from_node_files
done

sleep 10

echo "CREATE NODES IN ENM USING $NODES_WORKING_FILE"
populate_network

echo "OPERATIONS COMPLETED - $(date)"


