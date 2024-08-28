#!/bin/bash

set -euo pipefail

deployment_id=$1
csar_version=$2
docker_registry=$3
docker_registry_user=$4
docker_registry_password=$5
csar_path=/home/eccd/cENM_CSAR_$csar_version
docker_root_dir=/var/lib/docker/
yaml_params=".global.registry.url .global.timezone .global.persistentVolumeClaim.storageClass .global.ingress.enmHost .global.vips.fm_vip_address .global.vips.cm_vip_address .global.vips.pm_vip_address .global.vips.ui_vip_address .global.vips.amos_vip_address .global.vips.general_scripting_vip_address .global.vips.general_scripting_vip_address .global.vips.element_manager_vip_address .global.vips.visinamingsb_vip_address .global.enmProperties.COM_INF_LDAP_ADMIN_CN .global.enmProperties.COM_INF_LDAP_ROOT_SUFFIX .global.enmProperties.host_system_identifier .global.rwx.storageClass .eric-enm-monitoring-master.monitoring.autoUpload.ddpsite .eric-enm-monitoring-master.monitoring.autoUpload.account .eric-enm-monitoring-master.monitoring.autoUpload.password .eric-data-graph-database-nj.persistentVolumeClaim.storageClass .eric-data-graph-database-nj.persistentVolumeClaim.backup.storageClass .eric-data-graph-database-nj.persistentVolumeClaim.logging.storageClass .eric-net-ingress-l4.interfaces.internal .eric-net-ingress-l4.interfaces.external .eric-net-ingress-l4.cniMode .eric-ctrl-bro.persistence.persistentVolumeClaim.storageClassName .eric-data-search-engine.persistence.data.persistentVolumeClaim.storageClassName .eric-data-search-engine.persistence.backup.persistentVolumeClaim.storageClassName .eric-data-search-engine.persistence.master.persistentVolumeClaim.storageClassName .eric-pm-node-exporter.prometheus.nodeExporter.service.hostPort .eric-pm-node-exporter.prometheus.nodeExporter.service.servicePort .eric-pm-alert-manager.persistence.persistentVolumeClaim.storageClassName .eric-pm-server.server.persistentVolume.storageClass"
messages_timestamp=$(date '+%H:%M:%S')
cenm_integration_values_dit_doc=$(curl -s "http://atvdit.athtem.eei.ericsson.se/api/deployments/?q=name=$deployment_id" | python -m json.tool | grep cENM_integration_values -B3 | grep document_id | awk '{print $2}' | sed 's/"//g;s/,//g')
cenm_site_information_values_dit_doc=$(curl -s "http://atvdit.athtem.eei.ericsson.se/api/deployments/?q=name=$deployment_id" | python -m json.tool | grep cENM_site_information -B3 | grep document_id | awk '{print $2}' | sed 's/"//g;s/,//g')


initial_message(){
  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "cENM Upgrade: Phase 1 Preparation of Artifacts"
  echo "---------------------------------------------------------------------------------------------"
  echo ""
}

final_message(){
  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "cENM Upgrade: Phase 1 Preparation of Artifacts Successfully Completed"
  echo "---------------------------------------------------------------------------------------------"
  echo ""
}

print_message(){
  message="$1"
  echo "$messages_timestamp $message"
}

delete_csar_dir() {
  if [ -d "$csar_path" ];then
    print_message "INFO Directory $csar_path is already existing. Removing it..."	  
    rm -rf $csar_path
  fi
}

check_space_docker_root_dir() {
  print_message "INFO Checking if there is enough space on Docker root dir to download csar package..."
  avail_space=$(df -khP $docker_root_dir | awk '{print $4}' | tail -1 | sed 's/G//g')
  if [ $avail_space -lt 50 ];then
    print_message "ERROR Insufficient disk space (${avail_space}G) in /var/lib/docker to download csar package"
    exit 1
  fi
}  

create_csar_dir() {
  print_message "INFO Creating dir ($csar_path) for csar package..."
  #create dir for CSAR file
  mkdir -p $csar_path
}

download_unzip_csar_package(){
  print_message "INFO Downloading csar package..."
  wget https://arm902-eiffel004.athtem.eei.ericsson.se:8443/nexus/content/repositories/releases//cENM/csar/enm-installation-package/$csar_version/enm-installation-package-$csar_version.csar -O $csar_path/enm-installation-package-$csar_version.csar
  if [ $? -ne 0 ];then
    echo "ERROR Failure in getting csar package"
    exit 1
  fi
  echo "INFO Unzipping csar package..."
  unzip $csar_path/enm-installation-package-$csar_version.csar -d $csar_path
  if [ $? -ne 0 ];then
    echo "ERROR Failure in unzipping csar package"
    exit 1
  fi
}

get_integration_file_version(){
  int_val_file_ver=$(ls $csar_path/Scripts/eric-enm-integration-production-values* | awk -F "-" '{print $7"-"$8}' | sed 's/.yaml//')
}

setup_yq_tool(){
  print_message "INFO Checking if yq tool archive is present..."
  if [ ! -f "/home/eccd/s4_scripts/yq_linux_386.tar.gz" ];then
     print_message "ERROR Yq tool archive is not present! Exiting..."
    exit 1
  else
    print_message "INFO Creating directory for yq tool"
    cp /home/eccd/s4_scripts/yq_linux_386.tar.gz $csar_path/yq_linux_386.tar.gz
    mkdir -p $csar_path/yq
    print_message "INFO Uncompressing yq tool archive"
    tar -xvf  $csar_path/yq_linux_386.tar.gz --directory $csar_path/yq
  fi
}

print_yaml_parameters_to_be_modified(){
  echo "******************* YAML PARAMETERS TO BE MODIFIED *******************"
  echo $yaml_params | tr ' ' '\n'
}

get_integration_values_from_dit(){
  print_message "INFO Getting integration values from dit (json)..."
  curl --insecure -X GET "https://atvdit.athtem.eei.ericsson.se/api/documents/$cenm_integration_values_dit_doc" -H "accept: application/json" | python -m json.tool > $csar_path/eric-enm-integration-dit.json
  if [ $? -ne 0 ];then
    print_message "ERROR Failure in getting integration values from DIT"
    exit 1
  fi
}

convert_integration_values_to_yaml(){
  print_message "INFO Converting integration values from json to yaml..."
  $csar_path/yq/yq_linux_386 eval -P $csar_path/eric-enm-integration-dit.json | grep -v "__v\|601d744368295e36b3bac44a\|autopopulate\|content\|created_at\|managedconfig\|${deployment_id}_integration_value_file\|schema_id\|updated_at" | cut -c 3- > $csar_path/eric-enm-integration-dit.yaml
  if [ $? -ne 0 ];then
    print_message "ERROR Failure in converting integration values from json to yaml"
    exit 1
  fi
}

get_site_values_from_dit(){
  print_message "INFO Getting site from dit (json)"
  curl --insecure -X GET "https://atvdit.athtem.eei.ericsson.se/api/documents/$cenm_site_information_values_dit_doc" -H "accept: application/json" | python -m json.tool > $csar_path/eric-enm-site.json
}

convert_site_values_to_yaml(){
  print_message "INFO Converting site values from json to yaml"
  $csar_path/yq/yq_linux_386 eval -P $csar_path/eric-enm-site.json | grep -v "__v\|601d745168295e1351bac44c\|autopopulate\|content\|created_at\|managedconfig\|${deployment_id}_site_information\|schema_id\|updated_at" | cut -c 3- > $csar_path/eric-enm-site.yaml
}

create_backup_integration_file(){
  print_message "INFO Creating a backup copy of /eric-enm-integration-production-values-$int_val_file_ver.yaml file"
  cp $csar_path/Scripts/eric-enm-integration-production-values-$int_val_file_ver.yaml $csar_path/Scripts/eric-enm-integration-production-values-$int_val_file_ver.yaml.bkp
  if [ $? -ne 0 ];then
    print_message "ERROR Failure in creating a backup copy of /eric-enm-integration-production-values-$int_val_file_ver.yaml file"
    exit 1
  fi
}

populate_integration_file_from_integration_dit(){
  print_message "INFO Processing values from integration dit"
  for yaml_param in $yaml_params; do
    yaml_dit_value=$($csar_path/yq/yq_linux_386 eval "$yaml_param" $csar_path/eric-enm-integration-dit.yaml)
    print_message "INFO Modifying value: $yaml_param using dit value: $yaml_dit_value"
    $csar_path/yq/yq_linux_386 eval "$yaml_param = \"$yaml_dit_value\"" -i $csar_path/Scripts/eric-enm-integration-production-values-$int_val_file_ver.yaml
  done
}

populate_integration_file_from_site_dit(){
  #In DIT file the parameter is pullsecret while in yaml is pullSecret
  yaml_param=".global.pullsecret"

  echo $yaml_param
  yaml_dit_value=$($csar_path/yq/yq_linux_386 eval "$yaml_param" $csar_path/eric-enm-site.yaml)

  yaml_params=".global.pullSecret .global.registry.pullSecret"

  print_message "INFO Processing values from site dit"

  for yaml_param in $yaml_params;do
    $csar_path/yq/yq_linux_386 eval "$yaml_param = \"$yaml_dit_value\"" -i  $csar_path/Scripts/eric-enm-integration-production-values-$int_val_file_ver.yaml
    echo "MODIFYING VALUE: $yaml_param USING DIT VALUE: $yaml_dit_value"
  done
}

populate_integration_file(){
  print_message "INFO Populating integration file /eric-enm-integration-production-values-$int_val_file_ver.yaml with values from dit..."
  populate_integration_file_from_integration_dit
  populate_integration_file_from_site_dit
  print_message "INFO Integration file /eric-enm-integration-production-values-$int_val_file_ver.yaml values have been assigned" 
}

check_null_values_integration_file(){
  print_message "INFO Checking if null values are present in parameters of integration file"
  if ! grep -q null $csar_path/Scripts/eric-enm-integration-production-values-$int_val_file_ver.yaml;then 
    print_message "INFO All parameters of integration file have been successfully replaced"
  else 
    echo "ERROR Following parameters of integration file have not been replaced:"
    grep null $csar_path/Scripts/eric-enm-integration-production-values-$int_val_file_ver.yaml
    exit 1
  fi
}  

login_to_docker_registry(){
  print_message "INFO Logging-in to docker registry $docker_registry"
  echo $docker_registry_password > $csar_path/password_docker_registry.txt
  cat $csar_path/password_docker_registry.txt | sudo docker login $docker_registry -u $docker_registry_user --password-stdin
  if [ $? -ne 0 ];then
    print_message "ERROR Failure in loggin-in to docker registry $docker_registry"
    exit 1
  fi
}

pushing_docker_images_to_registry(){
  print_message "INFO Pushing docker images to docker registry..."
  bash $csar_path/Scripts/csar_utils.sh --docker-registry-url=$docker_registry
}	


initial_message
delete_csar_dir
sleep 30
check_space_docker_root_dir
create_csar_dir
download_unzip_csar_package
get_integration_file_version
setup_yq_tool
print_yaml_parameters_to_be_modified
get_integration_values_from_dit
convert_integration_values_to_yaml
get_site_values_from_dit
convert_site_values_to_yaml
create_backup_integration_file
populate_integration_file
check_null_values_integration_file
login_to_docker_registry
#pushing_docker_images_to_registry
final_message
