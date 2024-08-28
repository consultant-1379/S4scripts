#!/bin/bash

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1
wkl_vm_ip=$2
netype=$3

for n in $netype;do

        #number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement' | grep NetworkElement | wc -l")
        number_nodes_enm=$(count_number_nodes_enm $lms_ip $wkl_vm_ip $netype)

        number_nodes_workload=$(sshpass -p 12shroot ssh nagios@$1 "sudo sshpass -p 12shroot ssh root@$2 '/opt/ericsson/enmutils/bin/workload status'" | grep TOTAL | awk '{print $5}')

        number_nodes_workload=$(printf '%d\n' "$number_nodes_workload")

        warning_value_float=`echo "$number_nodes_enm * 0.95" | bc -l`
        warning_value=${warning_value_float%.*}

        critical_value_float=`echo "$number_nodes_enm * 0.8" | bc -l`
        critical_value=${critical_value_float%.*}

        if [[ "$number_nodes_workload" -lt "$warning_value" && "$number_nodes_workload" -gt "$critical_value" ]];then
                echo "WARNING- NUMBER OF NODES CONFIGURED IN WORKLOADS $number_nodes_workload IS FROM 80% TO 95% OF ENM NODES"
                exit 1	
        fi

        if [[ "$number_nodes_workload" -lt "$critical_value" ]];then
                echo "CRITICAL- NUMBER OF NODES CONFIGURED IN WORKLOADS $number_nodes_workload IS LOWER THAN 80% OF ENM NODES"
                exit 2
        fi

        echo "OK- NUMBER OF NODES CONFIGURED IN WORKLOADS ($number_nodes_enm) IS HIGHER THAN 95% OF ENM NODES"
        exit 0

done