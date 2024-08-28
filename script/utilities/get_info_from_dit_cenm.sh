#!/bin/bash

set -euo pipefail

deployment_id=$1
#selection=$2
eccd_director_keyfile=ccd-${deployment_id}.director.pem

is_empty(){
  local var
  var=$1
  if [ -z "$var" ];then
    echo "ERROR Empty value has been returned"
    exit 1
  fi
}

check_ip(){
  local ip_addr
  ip_addr=$1
  if [[ ! $ip_addr =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];then
    echo "ERROR Failure in getting ip address"
    exit 1
  fi
}

get_integration_values_dit_doc(){
  cenm_integration_values_dit_doc=$(curl -s "http://atvdit.athtem.eei.ericsson.se/api/deployments/?q=name=$deployment_id" | python -m json.tool | grep cENM_integration_values -B3 | grep document_id | awk '{print $2}' | sed 's/"//g;s/,//g')
  is_empty $cenm_integration_values_dit_doc
}


get_site_information_values_dit_doc(){
  cenm_site_information_values_dit_doc=$(curl -s "http://atvdit.athtem.eei.ericsson.se/api/deployments/?q=name=$deployment_id" | python -m json.tool | grep cENM_site_information -B3 | grep document_id | awk '{print $2}' | sed 's/"//g;s/,//g')
  is_empty $cenm_site_information_values_dit_doc
}  

get_director_client_ip(){  
  director_client_ip=$(curl -s "https://atvdit.athtem.eei.ericsson.se/api/documents/$cenm_site_information_values_dit_doc" | python -m json.tool | grep client_machine -A2 | grep ipaddress | awk '{print $2}' | sed "s/\"//g;s/,//g;s/'//g")
  check_ip $director_client_ip
}

get_director_username(){
  director_username=$(curl -s "https://atvdit.athtem.eei.ericsson.se/api/documents/$cenm_site_information_values_dit_doc" | python -m json.tool | grep client_machine -A2 | grep username | awk '{print $2}' | sed "s/\"//g;s/,//g;s/'//g")
  is_empty $director_username
}

get_docker_registry_url(){
  docker_registry_url=$(curl -s "https://atvdit.athtem.eei.ericsson.se/api/documents/$cenm_site_information_values_dit_doc" | python -m json.tool | grep registry -A4 | grep hostname | awk '{print $2}' | sed "s/\"//g;s/,//g;s/'//g")
   is_empty $docker_registry_url
}

get_docker_registry_username(){
  docker_registry_username=$(curl -s "https://atvdit.athtem.eei.ericsson.se/api/documents/$cenm_site_information_values_dit_doc" | python -m json.tool | grep registry -A4 | grep username | awk '{print $2}' | sed "s/\"//g;s/,//g;s/'//g")
   is_empty $docker_registry_username
}

get_docker_registry_password(){
  docker_registry_password=$(curl -s "https://atvdit.athtem.eei.ericsson.se/api/documents/$cenm_site_information_values_dit_doc" | python -m json.tool | grep registry -A4 | grep password | awk '{print $2}' | sed "s/\"//g;s/,//g;s/'//g")
  is_empty $docker_registry_password
}

get_namespace(){
  namespace=$(curl -s "https://atvdit.athtem.eei.ericsson.se/api/documents/$cenm_site_information_values_dit_doc" | python -m json.tool | grep namespace | awk '{print $2}' | sed "s/\"//g;s/,//g;s/'//g")
  is_empty $namespace
}

get_director_client_key(){
  curl -s "http://atvdit.athtem.eei.ericsson.se/api/deployments/?q=name=${deployment_id}" | python -m json.tool | grep private_key | sed 's/\\r\\n/\n/g' | sed 's/            "private_key": "//g;s/\",//g' > $eccd_director_keyfile
  if  ! ( ( grep -q "BEGIN RSA PRIVATE KEY" $eccd_director_keyfile ) && ( grep -q "END RSA PRIVATE KEY" $eccd_director_keyfile ) );then 
    echo "ERROR Key File is wrong"
    exit 1
  fi
}


get_integration_values_dit_doc
get_site_information_values_dit_doc
get_director_client_ip
get_director_username
get_docker_registry_url
get_docker_registry_username
get_docker_registry_password
get_namespace
get_director_client_key

echo "$director_client_ip $director_username $eccd_director_keyfile $docker_registry_url $docker_registry_username $docker_registry_password $namespace"
