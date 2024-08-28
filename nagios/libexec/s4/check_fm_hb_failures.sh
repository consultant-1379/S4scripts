#!/bin/bash
source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1
wkl_vm_ip=$2
netype=$3

number_nodes_enm=$(count_number_nodes_enm $lms_ip $wkl_vm_ip $netype)
tot_number_nodes_enm=$((tot_number_nodes_enm + number_nodes_enm))
eval "number_nodes_${n}"=$number_nodes_enm

warning_value_float=`echo "$tot_number_nodes_enm * 0.05" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_enm * 0.2" | bc -l`
critical_value=${critical_value_float%.*}

nodes_hb_fail=$(count_nodes_hb_fail $lms_ip $wkl_vm_ip $netype)

if [[ ("$nodes_hb_fail" -gt "$warning_value") && ("$nodes_hb_fail" -lt "$critical_value") ]];then
  echo "WARNING- THERE ARE ($nodes_hb_fail) NODES WITH FM HB FAILURE OUT OF ($tot_number_nodes_enm) ENM NODES"
  exit 1
fi

if [[ "$nodes_hb_fail" -gt "$critical_value" ]];then
   echo "CRITICAL- THERE ARE ($nodes_hb_fail) NODES WITH FM HB FAILURE OUT OF ($tot_number_nodes_enm) ENM NODES"
   exit 2
fi

if [[ "$nodes_hb_fail" -eq "0" ]];then

  echo "OK- NO FM HB FAILURES ARE PRESENT IN $ne_type NODES !"
  exit 0
fi

echo "WARNING- THERE ARE ($nodes_hb_fail) NODES WITH FM HB FAILURE OUT OF ($tot_number_nodes_enm) ENM NODES"
exit 1
