#!/bin/bash

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1
wkl_vm_ip=$2
netype=$3

tot_number_nodes_enm=0

number_nodes_enm=$(count_number_nodes_enm $lms_ip $wkl_vm_ip $netype)
tot_number_nodes_enm=$((tot_number_nodes_enm + number_nodes_enm))
eval "number_nodes_${n}"=$number_nodes_enm
number_nodes_cmsuperv=$(count_number_nodes_cmsuperv $lms_ip $wkl_vm_ip $netype)
tot_number_nodes_cmsuperv=$((tot_number_nodes_cmsuperv + number_nodes_cmsuperv))
eval "number_nodes_${n}"=$number_nodes_cmsuperv

warning_value_float=`echo "$tot_number_nodes_enm * 0.95" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_enm * 0.8" | bc -l`
critical_value=${critical_value_float%.*}

if [[ ("$tot_number_nodes_cmsuperv" -lt "$warning_value") && ("$tot_number_nodes_cmsuperv" -gt "$critical_value") ]];then
	echo "WARNING- THERE ARE ($tot_number_nodes_cmsuperv) NODES WITH CM SUPERVISION ENABLED OUT OF ($tot_number_nodes_enm) ENM NODES"
	exit 1	
fi

if [[ "$tot_number_nodes_cmsuperv" -lt "$critical_value" ]];then
        echo "CRITICAL- THERE ARE ($tot_number_nodes_cmsuperv) NODES WITH CM SUPERVISION ENABLED OUT OF ($tot_number_nodes_enm) ENM NODES"
        exit 2
fi

if [[ "$tot_number_nodes_cmsuperv" -eq "$tot_number_nodes_enm" ]];then
        echo "OK- CM SUPERVISION IS ENABLED IN ALL NODES ($tot_number_nodes_cmsuperv)"
        exit 0
fi

echo "WARNING- THERE ARE ($tot_number_nodes_cmsuperv) NODES WITH CM SUPERVISION ENABLED OUT OF ($tot_number_nodes_enm) ENM NODES"
exit 1
