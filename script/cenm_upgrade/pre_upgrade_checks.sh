#!/bin/bash

set -euo pipefail

namespace=$1
tmpfiles_timestamp=$(date '+%Y_%m_%d_%H:%M:%S')
messages_timestamp=$(date '+%H:%M:%S')
TMP_FILES_DIR=/tmp/CENM_HC_$tmpfiles_timestamp


initial_message(){
  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "cENM Upgrade: Phase 1 Platform Health Checks"
  echo "---------------------------------------------------------------------------------------------"
  echo ""
}

final_message(){
  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "cENM Upgrade: Phase 1 Platform Health Checks Successfully Completed"
  echo "---------------------------------------------------------------------------------------------"
  echo ""
}

print_message(){
  message="$1"
  echo "$messages_timestamp $message" 
}

create_tmp_file_dir(){
  mkdir -p $TMP_FILES_DIR
}

remove_tmp_file_dir(){
  print_message "INFO Removing old tmp directories"
  tmp_dirs=$(ls -la /tmp/CENM_HC* | grep CENM | sed 's/://g')
  for tmp_dir in $tmp_dirs;do
    rm -rf $tmp_dir
  done
}

cluster_info_status(){
  is_failed="false"
  print_message "INFO Checking cluster info status..."
  kubectl cluster-info | grep Kube > $TMP_FILES_DIR/cluster-info-checks.tmp
  while read line;do 
    if [[ "$line" != *"is running"* ]]; then
       print_message "ERROR Problems in operation of cluster: $line"
       is_failed="true"
    fi
  done < $TMP_FILES_DIR/cluster-info-checks.tmp
  if $is_failed;then 
    print_message "ERROR Cluster checks have failed"
    exit 1
  else 
    print_message "INFO Cluster checks have been successfully passed"
  fi 
}

nodes_status(){
  is_failed="false"
  print_message "INFO Checking nodes status..."
  kubectl get nodes | tail -n +2 > $TMP_FILES_DIR/node-status-checks.tmp
  while read line;do
    node_name=$(echo $line | awk '{print $1}')
    node_status=$(echo $line | awk '{print $2}')
    if [ $node_status != "Ready" ];then
      print_message "ERROR Node $node_name is not ready"
      is_failed="true"
    fi
  done < $TMP_FILES_DIR/node-status-checks.tmp
  if $is_failed;then
    print_message "ERROR Nodes status checks have failed"
    exit 1
  else
    print_message "INFO Nodes status checks have been successfully passed. All nodes are in Ready status"
  fi
}

namespace_status(){
  print_message "INFO Checking namespace..."
  namesp=$(kubectl get namespaces | grep -i $namespace)
  if [[ "$namesp" != *"$namespace"* ]] || [[ "$namesp" != *"Active"* ]];then
    print_message "ERROR Namespace $namespace not found or not active"
    exit 1
  fi
  print_message "INFO Namespace check has been successfully passed. Namespace $namespace is present and active"
}

labelled_nodes_status(){
  print_message "INFO Checking labelled nodes..."
  no_labelled_nodes=$(kubectl get nodes --show-labels -l node=ericingress | tail -n +2 | wc -l)
  if [ "$no_labelled_nodes" -lt 2 ] || [ "$no_labelled_nodes" -eq 0 ];then
    print_message "ERROR There are less than two labelled nodes ($no_labelled_nodes)"
    exit 1
  fi
  print_message "INFO Labelled nodes check has been successfully passed. Two labelled nodes are present"
}

charts_deployed_status(){
  is_failed="false"
  print_message "INFO Checking that all charts are deployed..."
  helm list --date --namespace $namespace | tail -n +2 > $TMP_FILES_DIR/chart-status.tmp
  while read line;do
    chart_name=$(echo $line | awk '{print $1}')
    chart_status=$(echo $line | awk '{print $8}')
    if [ $chart_status != "deployed" ];then
      print_message "ERROR Chart $chart_name is not in Deployed status"
      is_failed="true"
    fi
  done < $TMP_FILES_DIR/chart-status.tmp
  if $is_failed;then
    print_message "ERROR Deployed charts checks have failed"
    exit 1
  else
    print_message "INFO Deployed charts checks have been been successfully passed. All charts are in Deployed status"
  fi
}

stateful_resources_status(){
  is_failed="false"
  print_message "INFO Checking stateful resources..."
  kubectl get statefulsets -n $namespace | tail -n +2 > $TMP_FILES_DIR/stateful-status.tmp
  while read line;do
    stateful_resource=$(echo $line | awk '{print $1}')
    ready_state=$(echo $line | awk '{print $2}')
    ready_state1=$(echo $ready_state | awk -F "/" '{print $1}')
    ready_state2=$(echo $ready_state | awk -F "/" '{print $2}')
    if [ $ready_state1 != "$ready_state2" ];then
      print_message "ERROR Stateful resource chart $stateful_resource is not ready"
      is_failed="true"
    fi
  done < $TMP_FILES_DIR/stateful-status.tmp
  if $is_failed;then
    print_message "ERROR Stateful resources checks have failed"
    exit 1
  else
    print_message "INFO Stateful resources checks have been successfully passed. All stateful resources are in Ready status"
  fi
}

pods_resources_status(){
  is_failed="false"
  print_message "INFO Checking pods resources..."
  kubectl get pods -n $namespace | tail -n +2 > $TMP_FILES_DIR/pods-status.tmp
  while read line;do
    pod_resource=$(echo $line | awk '{print $1}')
    ready_state=$(echo $line | awk '{print $2}')
    ready_state1=$(echo $ready_state | awk -F "/" '{print $1}')
    ready_state2=$(echo $ready_state | awk -F "/" '{print $2}')
    pod_status=$(echo $line | awk '{print $3}')
    if [[ "$pod_status" != "Running" ]];then
      if [[ "$pod_status" != "Completed" ]];then
        print_message "ERROR Status of pod $pod_resource is wrong"
        is_failed="true"
      fi
    fi
  done < $TMP_FILES_DIR/pods-status.tmp
  if $is_failed;then
    print_message "ERROR Pods resources checks have failed"
    exit 1
  else
    print_message "INFO Pods resources checks have been successfully passed. All pods resources are in Running/Completed status"
  fi
}

jobs_resources_status(){
  is_failed="false"
  print_message "INFO Checking jobs resources..."
  kubectl get jobs -n $namespace | tail -n +2 > $TMP_FILES_DIR/jobs-status.tmp
  while read line;do
    job_resource=$(echo $line | awk '{print $1}')
    completion_state=$(echo $line | awk '{print $2}')
    completion_state1=$(echo $ready_state | awk -F "/" '{print $1}')
    completion_state2=$(echo $ready_state | awk -F "/" '{print $2}')
    if [ $completion_state1 != "$completion_state2" ];then
      print_message "ERROR Job resource $job_resource is not completed"
      is_failed="true"
    fi
  done < $TMP_FILES_DIR/jobs-status.tmp
  if $is_failed;then
    print_message "ERROR Jobs resources checks have failed"
    exit 1
  else
    print_message "INFO Jobs resources checks have been successfully passed. All jobs resources are in Completed status"
  fi
}

pvc_resources_status(){
  is_failed="false"
  print_message "INFO Checking pvc reources..."
  kubectl get pvc -n $namespace | tail -n +2 > $TMP_FILES_DIR/pvc-status.tmp
  while read line;do
    pvc_resource=$(echo $line | awk '{print $1}')
    pvc_state=$(echo $line | awk '{print $2}')
    if [ $pvc_state != "Bound" ];then
      print_message "ERROR Pvc resource $pvc_resource is not bound"
      is_failed="true"
    fi
  done < $TMP_FILES_DIR/pvc-status.tmp
  if $is_failed;then
    print_message "ERROR Pvc resources checks have failed"
    exit 1
  else
    print_message "INFO Pvc resources checks have been successfully passed. All pvc resources are in Bound status"
  fi
}

initial_message
remove_tmp_file_dir
create_tmp_file_dir
cluster_info_status
nodes_status
namespace_status
labelled_nodes_status
charts_deployed_status
stateful_resources_status
pods_resources_status
jobs_resources_status
pvc_resources_status
final_message


