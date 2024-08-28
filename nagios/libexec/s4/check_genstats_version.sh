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
  echo "CRITICAL- EXPECTED GENSTATS VERSION HAS NOT BEEN CONFIGURED IN CONFIGURATION FILE $config_file"
  exit 2
fi

for netsim in $netsims;do 
  genstats_version=$(sshpass -p netsim ssh -q netsim@$netsim "/netsim_users/pms/bin/genStatsRPMVersion.sh" | awk -F "-" '{print $2}')
  if [[ "$genstats_version" != "$genstats_version_expected" ]];then
    wrong_genstats="$wrong_genstats $netsim($genstats_version)"
  fi
done

if [ ! -z "$wrong_genstats" ]
then
  echo "WARNING- THERE ARE NETSIM VMs WITH WRONG GENSTATS VERSION | EXPECTED VERSION: $genstats_version_expected THE FOLLOWING NETSIM VMs ARE AFFECTED: $wrong_genstats"
  exit 1
else
  echo "OK- CORRECT GENSTATS VERSION ($genstats_version_expected) IS LOADED IN ALL NETSIM VMs"
  exit 0
fi
