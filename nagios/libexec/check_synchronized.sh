#!/bin/bash

netypes=$2
family=$3

tot_number_nodes_enm=0
tot_number_nodes_syn=0

for n in $netypes;do
        number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$n -t' | grep -i $n | wc -l")
        tot_number_nodes_enm=$((tot_number_nodes_enm + number_nodes_enm))
        eval "number_nodes_${n}"=$number_nodes_enm
done

for m in $netypes;do
        number_nodes_syn=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * CmFunction.syncStatus==SYNCHRONIZED --neType=$m -t' | grep SYNCHRONIZED | wc -l")
        tot_number_nodes_syn=$((tot_number_nodes_syn + number_nodes_syn))
        eval "number_nodes_syn_${n}"=$number_nodes_syn
done

warning_value_float=`echo "$tot_number_nodes_enm * 0.95" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_enm * 0.8" | bc -l`
critical_value=${critical_value_float%.*}


if [[ "$tot_number_nodes_syn" -lt "$warning_value" && "$tot_number_nodes_syn" -gt "$critical_value" ]];then
	echo "WARNING- NUMBER OF $family NODES SYNCHRONIZED ($tot_number_nodes_syn) IS FROM 80% TO 95% OF ENM $family NODES ($tot_number_nodes_enm)"
	exit 1	
fi

if [[ "$tot_number_nodes_syn" -lt "$critical_value" ]];then
        echo "CRITICAL- NUMBER OF $family NODES SYNCHRONIZED ($tot_number_nodes_syn) IS LOWER THAN 80% OF ENM $family NODES ($tot_number_nodes_enm)"
        exit 2
fi

echo "OK- NUMBER OF $family NODES SYNCHRONIZED ($tot_number_nodes_syn) IS HIGHER THAN 95% OF ENM $family NODES ($tot_number_nodes_enm)"
exit 0
