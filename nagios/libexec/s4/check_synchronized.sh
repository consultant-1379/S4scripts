#!/bin/bash

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1
wkl_vm_ip=$2
netype=$3

tot_number_nodes_enm=0
tot_number_nodes_syn=0

number_nodes_enm=$(count_number_nodes_enm $lms_ip $wkl_vm_ip $netype)

tot_number_nodes_enm=$((tot_number_nodes_enm + number_nodes_enm))
eval "number_nodes_${n}"=$number_nodes_enm

number_nodes_syn=$(count_number_nodes_syn $lms_ip $wkl_vm_ip $netype)
tot_number_nodes_syn=$((tot_number_nodes_syn + number_nodes_syn))
eval "number_nodes_syn_${n}"=$number_nodes_syn

warning_value_float=`echo "$tot_number_nodes_enm * 0.95" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_enm * 0.8" | bc -l`
critical_value=${critical_value_float%.*}

if [[ "$tot_number_nodes_syn" -lt "$warning_value" && "$tot_number_nodes_syn" -gt "$critical_value" ]];then
	echo "WARNING- THERE ARE ($tot_number_nodes_syn) $netype NODES SYNCHRONIZED OUT OF ($tot_number_nodes_enm) ENM $netype NODES"
	exit 1	
fi

if [[ "$tot_number_nodes_syn" -lt "$critical_value" ]];then
        echo "CRITICAL- THERE ARE ($tot_number_nodes_syn) $netype NODES SYNCHRONIZED OUT OF ($tot_number_nodes_enm) ENM $netype NODES"
        exit 2
fi

if [[ "$tot_number_nodes_syn" -eq "$tot_number_nodes_enm" ]];then 

    echo "OK- ALL NODES $netype ARE SYNCHRONIZED ($tot_number_nodes_syn)"
    exit 0
fi

echo "WARNING- THERE ARE ($tot_number_nodes_syn) $netype NODES SYNCHRONIZED OUT OF ($tot_number_nodes_enm) ENM $netype NODES"
exit 1
