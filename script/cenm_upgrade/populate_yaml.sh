#!/bin/bash

set -euo pipefail

deployment_id="ieatenm$1"
integration_yaml_path=$2
integration_yaml_filename=$3
yaml_params="$4"
WORKING_DIR="/var/tmp/cenm-yaml-integration-$(date '+%F-%T')"
messages_timestamp=$(date '+%H:%M:%S')
cenm_integration_values_dit_doc=$(curl -s "http://atvdit.athtem.eei.ericsson.se/api/deployments/?q=name=$deployment_id" | python -m json.tool | grep cENM_integration_values -B3 | grep document_id | awk '{print $2}' | sed 's/"//g;s/,//g')
cenm_site_information_values_dit_doc=$(curl -s "http://atvdit.athtem.eei.ericsson.se/api/deployments/?q=name=$deployment_id" | python -m json.tool | grep cENM_site_information -B3 | grep document_id | awk '{print $2}' | sed 's/"//g;s/,//g')


initial_message(){
  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "cENM Upgrade: Setting-up of Integration YAML File"
  echo "---------------------------------------------------------------------------------------------"
  echo ""
}

final_message(){
  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "cENM Upgrade: Setting-up of Integration YAML File Successfully Completed"
  echo "---------------------------------------------------------------------------------------------"
  echo ""
}

create_working_dir(){
  mkdir -p $WORKING_DIR
}	

print_message(){
  message="$1"
  echo "$messages_timestamp $message"
}

#get_integration_file_version(){
#  int_val_file_ver=$(ls $csar_path/Scripts/eric-enm-integration-production-values* | awk -F "-" '{print $7"-"$8}' | sed 's/.yaml//')
#}

setup_yq_tool(){
  print_message "INFO Checking if yq tool archive is present..."
  if [ ! -f "/var/tmp/yq_linux_386.tar.gz" ];then
     print_message "ERROR Yq tool archive is not present! Exiting..."
    exit 1
  else
    print_message "INFO Creating directory for yq tool"
    cp /var/tmp/yq_linux_386.tar.gz $WORKING_DIR/yq_linux_386.tar.gz
    mkdir -p $WORKING_DIR/yq
    print_message "INFO Uncompressing yq tool archive"
    tar -xvf  $WORKING_DIR/yq_linux_386.tar.gz --directory $WORKING_DIR/yq
  fi
}

print_yaml_parameters_to_be_modified(){
  echo "******************* YAML PARAMETERS TO BE MODIFIED *******************"
  echo $yaml_params | tr ' ' '\n'
}

get_integration_values_from_dit(){
  print_message "INFO Getting integration values from dit (json)..."
  curl --insecure -X GET "https://atvdit.athtem.eei.ericsson.se/api/documents/$cenm_integration_values_dit_doc" -H "accept: application/json" | python -m json.tool > $WORKING_DIR/eric-enm-integration-dit.json
  if [ $? -ne 0 ];then
    print_message "ERROR Failure in getting integration values from DIT"
    exit 1
  fi
}

convert_integration_values_to_yaml(){
  print_message "INFO Converting integration values from json to yaml..."
  $WORKING_DIR/yq/yq_linux_386 eval -P $WORKING_DIR/eric-enm-integration-dit.json | grep -v "__v\|601d744368295e36b3bac44a\|autopopulate\|content\|created_at\|managedconfig\|${deployment_id}_integration_value_file\|schema_id\|updated_at" | cut -c 3- > $WORKING_DIR/eric-enm-integration-dit.yaml
  if [ $? -ne 0 ];then
    print_message "ERROR Failure in converting integration values from json to yaml"
    exit 1
  fi
}

get_site_values_from_dit(){
  print_message "INFO Getting site from dit (json)"
  curl --insecure -X GET "https://atvdit.athtem.eei.ericsson.se/api/documents/$cenm_site_information_values_dit_doc" -H "accept: application/json" | python -m json.tool > $WORKING_DIR/eric-enm-site.json
}

convert_site_values_to_yaml(){
  print_message "INFO Converting site values from json to yaml"
  $WORKING_DIR/yq/yq_linux_386 eval -P $WORKING_DIR/eric-enm-site.json | grep -v "__v\|601d745168295e1351bac44c\|autopopulate\|content\|created_at\|managedconfig\|${deployment_id}_site_information\|schema_id\|updated_at" | cut -c 3- > $WORKING_DIR/eric-enm-site.yaml
}

create_backup_integration_file(){
  print_message "INFO Creating a backup copy of $integration_yaml_filename file"
  cp ${integration_yaml_path}${integration_yaml_filename} ${integration_yaml_path}${integration_yaml_filename}.bkp
  if [ $? -ne 0 ];then
    print_message "ERROR Failure in creating a backup copy of $integration_yaml_filename file"
    exit 1
  fi
}

populate_integration_file_from_integration_dit(){
  print_message "INFO Processing values from integration dit"
  for yaml_param in $yaml_params; do
    yaml_dit_value=$($WORKING_DIR/yq/yq_linux_386 eval "$yaml_param" $WORKING_DIR/eric-enm-integration-dit.yaml)
    print_message "INFO Modifying value: $yaml_param using dit value: $yaml_dit_value"
    $WORKING_DIR/yq/yq_linux_386 eval "$yaml_param = \"$yaml_dit_value\"" -i ${integration_yaml_path}${integration_yaml_filename}
  done
}

populate_integration_file_from_site_dit(){
  #In DIT file the parameter is pullsecret while in yaml is pullSecret
  yaml_param=".global.pullsecret"

  echo $yaml_param
  yaml_dit_value=$($WORKING_DIR/yq/yq_linux_386 eval "$yaml_param" $WORKING_DIR/eric-enm-site.yaml)

  yaml_params=".global.pullSecret .global.registry.pullSecret .global.registry.url"

  print_message "INFO Processing values from site dit"

  for yaml_param in $yaml_params;do
    $WORKING_DIR/yq/yq_linux_386 eval "$yaml_param = \"$yaml_dit_value\"" -i ${integration_yaml_path}${integration_yaml_filename}
    echo "MODIFYING VALUE: $yaml_param USING DIT VALUE: $yaml_dit_value"
  done
}

populate_integration_file(){
  print_message "INFO Populating integration file $integration_yaml_filename with values from dit..."
  populate_integration_file_from_integration_dit
  populate_integration_file_from_site_dit
  print_message "INFO Integration file $integration_yaml_filename values have been assigned" 
}

check_null_values_integration_file(){
  print_message "INFO Checking if null values are present in parameters of integration file"
  if ! grep -q null ${integration_yaml_path}${integration_yaml_filename};then 
    print_message "INFO All parameters of integration file have been successfully replaced"
  else 
    echo "ERROR Following parameters of integration file have not been replaced:"
    grep null ${integration_yaml_path}${integration_yaml_filename}
    exit 1
  fi
}  

initial_message
create_working_dir
#get_integration_file_version
setup_yq_tool
print_yaml_parameters_to_be_modified
get_integration_values_from_dit
convert_integration_values_to_yaml
get_site_values_from_dit
convert_site_values_to_yaml
create_backup_integration_file
populate_integration_file
check_null_values_integration_file
final_message
