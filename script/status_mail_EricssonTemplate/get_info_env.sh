#!/bin/bash

get_enm_iso() {
  enm_iso_version=$(ssh -q root@$msip "/opt/ericsson/enminst/bin/enm_version.sh" | grep ENM | grep "ISO Version" | tail -1 | awk '{print $7}')
  if [ -z "$enm_iso_version" ];then
    enm_iso_version="ERROR: NO ENM ISO VERSION HAS BEEN RETURNED!"
  fi

}

get_nss_utils() {
  nss_utils_version=$(ssh -q root@$msip "rpm -qa | grep ERICTWnssutils_CXP9036352" | awk -F "-" '{print $2}')
  if [ -z "$nss_utils_version" ];then
    nss_utils_version="ERROR: NO NSS UTILS VERSION HAS BEEN RETURNED!"
  fi

}

get_torutils() {
   enm_torutils_version=$(ssh -q root@$wkl_vm "rpm -qa | grep ERICtorutilities_CXP9030570" | awk -F "-" '{print $2}')
   if [ -z "$enm_torutils_version" ];then
    enm_torutils_version="ERROR: NO ENM TORUTILS VERSION HAS BEEN RETURNED!"
   fi

}

get_torutils_int() {
  enm_torutils_int_version=$(ssh -q root@$wkl_vm "rpm -qa | grep ERICtorutilitiesinternal_CXP9030579" | awk -F "-" '{print $2}')
  if [ -z "$enm_torutils_int_version" ];then
    enm_torutils_int_version="ERROR: NO ENM TORUTILS INTERNAL VERSION HAS BEEN RETURNED!"
  fi


}


get_nss() {
  nss_version=$(ssh -q root@$msip "sshpass -p netsim ssh -q netsim@$netsim 'cat /netsim/simdepContents/nssProductSetVersion'" | awk -F "=" '{print $2}')
  if [ -z "$nss_version" ];then
    nss_version="ERROR: NO NSS VERSION HAS BEEN RETURNED!"
  fi

}

get_genstats() {
  genstats_version=$(sshpass -p netsim ssh -q netsim@$netsim "/netsim_users/pms/bin/genStatsRPMVersion.sh" | awk -F "-" '{print $2}')  
  if [ -z "$genstats_version" ];then
    genstats_version="ERROR: NO GENSTATS VERSION HAS BEEN RETURNED!"
  fi


}

get_nrm() {
  nrm=$(ssh -q root@$msip "sshpass -p netsim ssh -q netsim@$netsim 'cat /netsim/simdepContents/NRMDetails'" | head -1 | awk -F "=" '{print $2}')
  if [ -z "$nrm" ];then
    nrm="ERROR: NO NRM VERSION HAS BEEN RETURNED!"
  fi

}


get_synch_nodes() {
  no_synch_nodes=$(ssh -q root@$wkl_vm "/opt/ericsson/enmutils/bin/cli_app 'cmedit get * CmFunction.syncStatus==SYNCHRONIZED -t'" | grep SYNCHRONIZED | wc -l)
  if [ -z "$no_synch_nodes" ];then
    nrm="ERROR: NO SYNCH NODES HAVE BEEN RETURNED!"
  fi

}



msip=$1
wkl_vm=$2
netsim=$3



get_enm_iso
get_nss_utils
get_torutils
get_torutils_int
get_nss
get_genstats
get_nrm
get_synch_nodes

echo "ENM: $enm_iso_version NSSUTILS: $nss_utils_version TORUTILS: $enm_torutils_version TORUTILS_INT: $enm_torutils_int_version NSS: $nss_version GENSTATS: $genstats_version NRM: $nrm SYNCH_NODES: $no_synch_nodes"
