#!/bin/bash

get_enm_iso() {
  if [ "$deployment_type" == "Physical" ];then
	enm_iso_version=$(ssh -q root@$msip "timeout 15 /opt/ericsson/enminst/bin/enm_version.sh" | grep ENM | grep "ISO Version" | head -1 | awk '{print $9}')
	if [ -z "$enm_iso_version" ];then
		enm_iso_version="N/A"
	fi
  elif [ "$deployment_type" == "Cloud" ];then
	IP=$(sshpass -p 12shroot ssh -q root@$wkl_vm 'env|grep EMP| cut -d'=' -f 2' )
	
	enm_iso_version=$(sshpass -p 12shroot ssh -q -t root@$wkl_vm "ssh -q -t -o StrictHostKeyChecking=no -i /var/tmp/enm_keypair.pem cloud-user@${IP} \"sudo consul kv get enm/deployment/enm_version | cut -d' ' -f 5\"")
	if [ -z "$enm_iso_version" ];then
		enm_iso_version="N/A"
	fi
  elif [ "$deployment_type" == "cENM" ];then
		enm_iso_version="N/A"
  fi
  
	if [[ ${#enm_iso_version} -gt 20 ]];then
	
		enm_iso_version=$(echo "echo $enm_iso_version | awk '{print $NF}'")  
		
	fi
	if [[ ${#enm_iso_version} -gt 20 ]];then
		enm_iso_version="Not_Found"
	fi
	enm_iso_version=${enm_iso_version%")"}
}

get_nss_utils() {
  if [ "$deployment_type" == "Physical" ];then
    nss_utils_version=$(ssh -q root@$msip "rpm -qa | grep ERICTWnssutils_CXP9036352" | awk -F "-" '{print $2}')
      if [ -z "$nss_utils_version" ];then
        nss_utils_version="ERROR"
      fi
  else
    nss_utils_version=$(ssh -q root@$wkl_vm "rpm -qa | grep ERICTWnssutils_CXP9036352" | awk -F "-" '{print $2}')
      if [ -z "$nss_utils_version" ];then
        nss_utils_version="ERROR"
      fi
  fi

}

get_torutils() {
	if [ "$deployment_type" == "Physical" ];then
		enm_torutils_version=$(ssh -q root@$msip rpm -qa | grep ERICtorutilities_CXP9030570 | awk -F "-" '{print $2}')
		if [ -z "$enm_torutils_version" ];then
			enm_torutils_version="ERROR"
		fi
	else 
		enm_torutils_version=$(ssh -q root@$wkl_vm rpm -qa | grep ERICtorutilities_CXP9030570 | awk -F "-" '{print $2}')
		if [ -z "$enm_torutils_version" ];then
			enm_torutils_version="ERROR"
		fi
	fi
}

get_torutils_int() {
  enm_torutils_int_version=$(sshpass -p 12shroot ssh -q root@$wkl_vm "rpm -qa | grep ERICtorutilitiesinternal_CXP9030579" | awk -F "-" '{print $2}')
  if [ -z "$enm_torutils_int_version" ];then
    enm_torutils_int_version="ERROR"
  fi


}


get_nss() {
  nss_version=$(sshpass -p netsim ssh -q netsim@$netsim 'cat /netsim/simdepContents/nssProductSetVersion' | awk -F "=" '{print $2}')
  if [ -z "$nss_version" ];then
    nss_version="ERROR"
  fi

}

get_genstats() {
  genstats_version=$(sshpass -p netsim ssh -q netsim@$netsim "/netsim_users/pms/bin/genStatsRPMVersion.sh" | awk -F "-" '{print $2}')  
  if [ -z "$genstats_version" ];then
    genstats_version="ERROR"
  fi


}

get_nrm() {
  nrm=$(sshpass -p netsim ssh -q netsim@$netsim 'cat /netsim/simdepContents/NRMDetails' | head -1 | awk -F "=" '{print $2}')
  if [ -z "$nrm" ];then
    nrm="ERROR"
  fi

}


get_synch_nodes() {
  no_synch_nodes=$(sshpass -p 12shroot ssh -q root@$wkl_vm "/opt/ericsson/enmutils/bin/cli_app 'cmedit get * CmFunction.syncStatus==SYNCHRONIZED -t'" | grep SYNCHRONIZED | wc -l)
  if [ -z "$no_synch_nodes" ];then
    nrm="ERROR"
  fi

}



msip=$1
wkl_vm=$2
netsim=$3
deployment_type=$4

get_enm_iso
get_nss_utils
get_torutils
get_torutils_int
get_nss
get_genstats
get_nrm
get_synch_nodes

echo "ENM: $enm_iso_version NSSUTILS: $nss_utils_version TORUTILS: $enm_torutils_version TORUTILS_INT: $enm_torutils_int_version NSS: $nss_version GENSTATS: $genstats_version NRM: $nrm SYNCH_NODES: $no_synch_nodes"
