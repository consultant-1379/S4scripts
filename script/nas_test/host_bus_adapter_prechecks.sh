#!/bin/bash

DEPLOYMENT_ID=$1

. ./nas_functions_lib.sh


##MAIN

setVars

echo "INFO" "Check nas cluster info"
nas_cluster_info=$(show_cluster_summary $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP)
echo "$nas_cluster_info"

nas_host_1=$(getNasHostname $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $NAS_VIP_ENM_1)
echo "INFO" "Nas hostname 1: $nas_host_1"

nas_host_2=$(getNasHostname $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $NAS_VIP_ENM_2)
echo "INFO" "Nas hostname 2: $nas_host_2"

nas_wwnp_details_host1=$(getNasWWNPDetails $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP $nas_host_1)
echo "$nas_wwnp_details_host1"

nas_wwnp_details_host2=$(getNasWWNPDetails $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP $nas_host_2)
echo "$nas_wwnp_details_host2"

nas_disk_info=$(checkNasDiskInfo $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP)
echo "$nas_disk_info"


