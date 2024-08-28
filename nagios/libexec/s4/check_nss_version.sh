#!/bin/bash

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1

cluster_id=$(get_deployment_id_from_ms_ip $lms_ip)

config_file="${cluster_id}_configuration.sh"

source /usr/local/nagios/libexec/s4/$config_file

if [ -z "$netsims" ]
then
  echo "CRITICAL- NETSIM VMs HAVE NOT BEEN DEFINED IN $config_file FILE"
  exit 2
fi

if [ -z "$nss_version_expected" ]
then
  echo "CRITICAL- EXPECTED NSS VERSION HAS NOT BEEN CONFIGURED IN CONFIGURATION FILE $config_file"
  exit 2
fi

for netsim in $netsims;do 
#  nss_version=$(sshpass -p netsim ssh -q netsim@$netsim "grep NSS_RELEASE /netsim/netsim_cfg" | awk -F "=" '{print $2}')
#  nss_version=$(sshpass -p 12shroot ssh -q nagios@$1 "sshpass -p netsim ssh -q netsim@$netsim 'find /netsim/simdepContents | grep Netsim_CXP9032765.*content'" | head -n 1 | awk -F "." '{print $2"."$3}')
nss_version=$(sshpass -p 12shroot ssh -q nagios@$1 "sshpass -p netsim ssh -q netsim@$netsim 'cat /netsim/simdepContents/nssProductSetVersion'" | awk -F "=" '{print $2}')



  if [[ "$nss_version" != "$nss_version_expected" ]];then
    wrong_nss="$wrong_nss $netsim($nss_version)"
  fi
done

if [ ! -z "$wrong_nss" ]
then
  echo "WARNING- THERE ARE NETSIM VMs WITH WRONG NSS VERSION | EXPECTED VERSION: $nss_version_expected THE FOLLOWING NETSIM VMs ARE AFFECTED: $wrong_nss"
  exit 1
else
  echo "OK- CORRECT NSS VERSION ($nss_version_expected) IS LOADED IN ALL NETSIM VMs"
  exit 0
fi
