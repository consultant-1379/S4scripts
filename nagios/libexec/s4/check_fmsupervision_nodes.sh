#!/bin/bash

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1
wkl_vm_ip=$2
netype=$3

tot_number_nodes_enm=0

number_nodes_enm=$(count_number_nodes_enm $lms_ip $wkl_vm_ip $netype)
tot_number_nodes_enm=$((tot_number_nodes_enm + number_nodes_enm))
eval "number_nodes_${n}"=$number_nodes_enm

number_nodes_fmsuperv=$(count_number_nodes_fmsuperv $lms_ip $wkl_vm_ip $netype)
tot_number_nodes_fmsuperv=$((tot_number_nodes_fmsuperv + number_nodes_fmsuperv))
eval "number_nodes_${m}"=$number_nodes_fmsuperv

warning_value_float=`echo "$tot_number_nodes_enm * 0.95" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_enm * 0.8" | bc -l`
critical_value=${critical_value_float%.*}

if [[ ("$tot_number_nodes_fmsuperv" -lt "$warning_value") && ("$tot_number_nodes_fmsuperv" -gt "$critical_value") ]];then
	echo "WARNING- THERE ARE ($tot_number_nodes_fmsuperv) NODES WITH FM SUPERVISION ENABLED OUT OF ($tot_number_nodes_enm) ENM NODES"
	exit 1	
fi

if [[ "$tot_number_nodes_fmsuperv" -lt "$critical_value" ]];then
        echo "CRITICAL- THERE ARE ($tot_number_nodes_fmsuperv) NODES WITH FM SUPERVISION ENABLED OUT OF ($tot_number_nodes_enm) ENM NODES"
        exit 2
fi

if [[ "$tot_number_nodes_fmsuperv" -eq "$tot_number_nodes_enm" ]];then
        echo "OK- FM SUPERVISION IS ENABLED IN ALL NODES ($tot_number_nodes_fmsuperv)"
        exit 0
fi

echo "WARNING- THERE ARE ($tot_number_nodes_fmsuperv) NODES WITH FM SUPERVISION ENABLED OUT OF ($tot_number_nodes_enm) ENM NODES"
exit 1
