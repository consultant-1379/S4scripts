#!/bin/bash

vnf_sed_doc_id() {

  QUERY_URL="https://atvdit.athtem.eei.ericsson.se/api/deployments?q=name=vio-5${deployment_id}"

  deployment_documents=$(sudo curl -s "$QUERY_URL")

  vnf_sed_doc_id=$(echo $deployment_documents | grep -o -P 'schema_name":"vnflcm_sed_schema","document_id":[^,]*' | awk -F":" '{print $3}' | sed 's/"//g')

}

vnf_laf_ip() {
  
  vnf_sed_doc_id	
  QUERY_URL="https://atvdit.athtem.eei.ericsson.se/api/documents/$vnf_sed_doc_id"

  vnf_sed_info=$(sudo curl -s "$QUERY_URL")

  vnf_laf_ip=$(echo $vnf_sed_info | grep -o -P '"external_ipv4_for_services_vm":[^,]*' | awk -F":" '{print $2}' | sed 's/"//g')

  if [[ $vnf_laf_ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];then
    echo $vnf_laf_ip
    exit 0
  else
    echo "FAILURE IN GETTING VNF LAF IP ADDRESS FROM DIT !"
    exit 1
  fi
 
}

vnf_laf_pvt_key() {

  QUERY_URL="https://atvdit.athtem.eei.ericsson.se/api/deployments?q=name=vio-5${deployment_id}"

  deployment_documents=$(sudo curl -s "$QUERY_URL")


  vnf_private_key=$(echo $deployment_documents | grep -o -P '(?<="private_key":").*(?=END)' | sed 's/\\r\\n/\n/g')
  vnf_private_key=$(echo "$vnf_private_key""END RSA PRIVATE KEY-----")
#  vnf_private_key=$(echo $deployment_documents | grep -o -P '(?<="private_key":").*(?=","sed_id")' | sed 's/\\r\\n/\n/g')
#  vnf_private_key=$(echo $deployment_documents | grep -o -P '(?<="private_key":").*' | sed 's/\\r\\n/\n/g' | grep -v "sed_id")

  if [[ "$vnf_private_key" == *"PRIVATE KEY"* ]]; then
    echo "$vnf_private_key" > $vnf_laf_keyfile
    chmod 400 $vnf_laf_keyfile
    exit 0
  else
    echo "FAILURE IN GETTING VNF LAF PRIVATE KEY FROM DIT !"
    exit 1
  fi

}

deployment_id=$1
selection=$2
vnf_laf_keyfile=key_pair_vio-5${deployment_id}.pem

case "$selection" in

  vnflaf|VNFLAF)  
    vnf_laf_ip	
    ;;
  vnflaf_key|VNFLAF_KEY)  
    vnf_laf_pvt_key
    ;;
  *) 
    echo "Wrong selection $selection !"
    exit 1
   ;;
esac
