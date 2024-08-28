#!/bin/bash

#deployment_id=ieatenmc15a014
#requested_info=workload_vm
set -e

deployment_id=$1
requested_info=$2

curl_api_cmd="http://atvdit.athtem.eei.ericsson.se/api/"

check_jq_installed(){
  if ! rpm -q jq  2>&1 > /dev/null;then
    yum install jq -y -q 2>&1 > /dev/null
  fi
}

is_null(){
  local variable_to_check=$1
  if [ -z "$variable_to_check" ];then
#    echo "ERROR - VARIABLE RETURNED FROM DIT IS NULL! EXITING...."
    exit 1
  fi
}

get_dit_document_id(){
  local document_type=$1
  local document_id
  document_id=$(curl -4 -s "${curl_api_cmd}deployments/?q=name=$deployment_id" | jq ".[].documents[] | select(.schema_name==\"$document_type\") | .document_id" | sed 's/"//g')
  is_null $document_id
  echo $document_id
}

get_workload_vm_hostname_from_dit(){
  local document_id=$1
  local vm_hostname
  local workload_doc_id
  workload_doc_id=$(get_dit_document_id "workload")
  vm_hostname=$(curl -4 -s "${curl_api_cmd}documents/$workload_doc_id" | jq '.content.vm[0].hostname' | sed 's/"//g')
  is_null $vm_hostname
  echo $vm_hostname  
}


#main
#echo "INFO - CHECKING IF JQ TOOL IS INSTALLED ...."
#check_jq_installed  

case $requested_info in
  workload_vm)
    workload_vm=$(get_workload_vm_hostname_from_dit)
    echo $workload_vm
    exit 0
    ;;
  *)
    echo "ERROR - WRONG PARAMETERS!"
    exit 1
    ;;
esac
