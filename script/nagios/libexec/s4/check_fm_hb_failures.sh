#!/bin/bash


lms_host=$1
ne_type=$2

#summary=""
#netypes="RBS ERBS MTAS MGW SGSN-MME RadioNode RNC DSC RNC TCU02 SIU02 MINI-LINK-6352 MINI-LINK-Indoor"
#netypes=$2
#netype=""

#for n in $netypes;do
    number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$ne_type -t'" | grep -i $ne_type | wc -l)
    tot_number_nodes_enm=$((tot_number_nodes_enm + number_nodes_enm))
    eval "number_nodes_${n}"=$number_nodes_enm
#done

warning_value_float=`echo "$tot_number_nodes_enm * 0.05" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_enm * 0.2" | bc -l`
critical_value=${critical_value_float%.*}


#for netype in $netypes;do 
#	echo $netype
	nodes_hb_fail=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * FmFunction.currentServiceState==HEART_BEAT_FAILURE --neType=$ne_type -t'" | grep HEART_BEAT_FAILURE | wc -l)
#	echo $nodes_unsync


if [[ ("$nodes_hb_fail" -gt "$warning_value") && ("$nodes_hb_fail" -lt "$critical_value") ]];then
    echo "WARNING- NUMBER OF NODES WITH HB FAILURE ($nodes_hb_fail) IS BETWEEN 5% AND 20% OF ENM NODES ($tot_number_nodes_enm)"
    exit 1
fi

if [[ "$nodes_hb_fail" -gt "$critical_value" ]];then
        echo "CRITICAL- NUMBER OF NODES WITH HB FAILURE ($nodes_hb_fail) IS HIGHER THAN 20% OF ENM NODES ($tot_number_nodes_enm)"
        exit 2
fi

if [[ "$nodes_hb_fail" -eq "0" ]];then

    echo "OK- NO FM HB FAILURES ARE PRESENT IN $ne_type NODES !"
    exit 0
fi


echo "OK- NUMBER OF NODES WITH HB FAILURE ($nodes_hb_fail) IS LOWER THAN 5% OF ENM NODES ($tot_number_nodes_enm)"
exit 0
