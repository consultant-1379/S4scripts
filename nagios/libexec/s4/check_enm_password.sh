#!/bin/bash

#source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1
http_url=$2

enm_gui_user="administrator"
enm_gui_password="TestPassw0rd"

#cluster_id=$(get_deployment_id_from_ms_ip $lms_ip)

#config_file="${cluster_id}_configuration.sh"

#source /usr/local/nagios/libexec/s4/$config_file

enm_login=$(sshpass -p 12shroot ssh -q nagios@$lms_ip "sudo curl -k --request POST \"https://$http_url/login\" -d IDToken1=\"$enm_gui_user\" -d IDToken2=\"$enm_gui_password\" --cookie-jar cookie.txt")

if [[ "$enm_login" == *FAILED* ]]; then
  echo "OK- PASSWORD OF ENM ADMINISTRATOR USER IS NOT SET DEFAULT VALUE"
  exit 0
else
  echo "CRITICAL- PASSWORD OF ENM ADMINISTRATOR USER IS SET TO DEFAULT VALUE !"
  exit 2
fi
