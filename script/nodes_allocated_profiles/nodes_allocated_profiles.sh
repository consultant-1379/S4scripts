#!/bin/bash

#. ${BASEDIR}/../functions

BASEDIR=`dirname $0`
NODES=$1
#CLUSTER_ID=$2
#FETCH_DIR=/var/rvb/network/$NETSIM
#NODES=$NETSIM-nodes
NODES_FILE=/opt/ericsson/enmutils/etc/nodes/
NODES_DIR=/opt/ericsson/enmutils/etc/nodes/
NODES_WORKING_DIR=/opt/ericsson/enmutils/etc/nodes_tmp/$TICKET/
NODES_WORKING_FILE=$NODES_WORKING_DIR/nodestoaddtoenm-nodes
NETSIM_CMD=/opt/ericsson/nssutils/bin/netsim
WORKLOAD_CMD=/opt/ericsson/enmutils/bin/workload
TMP_DIR=/root/rvb/bin/teaas/s4/tmp/
PROFILES_TMP_FILE=$TMP_DIR/nodesprofiles$(date +"%Y-%m-%d_%H:%M:%S").txt

create_nodes_profiles_tmp_file(){
  echo "$FUNCNAME - $(date)"	
  $WORKLOAD_CMD list all --no-ansi > $PROFILES_TMP_FILE
}

extract_profiles_by_node(){
  echo "$FUNCNAME - $(date)"	
  profiles=$(cat $PROFILES_TMP_FILE | grep $grep_opt -A1 | grep ACTIVE | awk -F':' '{print $2}' | sed 's/,//g' | sed -e 's/^[ \t]*//')
}


create_working_dir(){
  echo "$FUNCNAME - $(date)"
  mkdir -p $TMP_DIR
}

create_node_list_grep(){
  echo "$FUNCNAME - $(date)"
  for node in $NODES;do
    grep_opt="grep_opt$node\|"
  done
}


#set -ex

tot_profiles=""

echo "CREATE WORKING DIRECTORY FOR NODE FILE $NODES_WORKING_DIR"
create_working_dir
echo "CREATE TMP FILE WITH LIST OF WORKLOADS ($PROFILES_TMP_FILE)"
create_nodes_profiles_tmp_file

create_node_list_grep

echo "SEARCH PROFILES USING NODES"
#for node in $NODES;do
  extract_profiles_by_node
  tot_profiles="$tot_profiles $profiles"
#done

allocated_profiles=$(echo $tot_profiles | tr " " "\n" | sort | uniq | tr "\n" " ")

echo "LIST OF PROFILES USING NODES: $allocated_profiles"

echo "OPERATIONS COMPLETED - $(date)"


