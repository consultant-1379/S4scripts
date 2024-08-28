#!/bin/bash

netypes="BSC DSC ERBS MGW MINI-LINK-6352 MINI-LINK-Indoor MSC-BC-IS MSC-DB-BSP MSC-BC-BSP MTAS RadioNode RBS RNC Router6672 SGSN-MME CISCO-ASR900 EPG ESC FRONTHAUL-6080 Router6274 SBG-IS"
#netypes="BSC DSC ERBS HLR-FE HLR-FE-BSP HLR-FE-IS MGW MINI-LINK-6352 MINI-LINK-Indoor MSC-BC-IS MSC-BB-BSP MTAS RadioNode RBS RNC Router6672 SGSN-MME SIU02 TCU02 vHLR-FE"

#fetched_files_list=""
tot_number_nodes_enm=0

#for i in $netsim_hosts;do 
#	fetched_files_list="$fetched_files_list $netsim_name-$i.athtem.eei.ericsson.se-nodes"
#done

#number_dsc_netsim=$(sshpass -p 12shroot ssh nagios@$1 "cd /opt/ericsson/enmutils/etc/nodes;cat $fetched_files_list | awk '{print $1}' | grep -v node_name | grep DSC | wc -l")
for n in $netypes;do
	number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$n -t' | grep -i $n | wc -l")
	tot_number_nodes_enm=$((tot_number_nodes_enm + number_nodes_enm))
	eval "number_nodes_${n}"=$number_nodes_enm
done

for m in $netypes;do
        number_nodes_fmsuperv=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * FmAlarmSupervision.active -neType=$m -t' | grep true | wc -l")
        tot_number_nodes_fmsuperv=$((tot_number_nodes_fmsuperv + number_nodes_fmsuperv))
        eval "number_nodes_${m}"=$number_nodes_fmsuperv
done

#number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement' | grep NetworkElement | wc -l")


warning_value_float=`echo "$tot_number_nodes_enm * 0.95" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_enm * 0.8" | bc -l`
critical_value=${critical_value_float%.*}

if [[ ("$tot_number_nodes_fmsuperv" -lt "$warning_value") && ("$tot_number_nodes_fmsuperv" -gt "$critical_value") ]];then
	echo "WARNING- NUMBER OF NODES WITH FM SUPERVISION ($tot_number_nodes_fmsuperv) IS BETWEEN 80% AND 95% OF ENM NODES ($tot_number_nodes_enm)"
	exit 1	
fi

if [[ "$tot_number_nodes_fmsuperv" -lt "$critical_value" ]];then
        echo "CRITICAL- NUMBER OF NODES WITH FM SUPERVISION ($tot_number_nodes_fmsuperv) IS LOWER THAN 80% OF ENM NODES ($tot_number_nodes_enm)"
        exit 2
fi

echo "OK- NUMBER OF NODES WITH FM SUPERVISION ($tot_number_nodes_fmsuperv) IS HIGHER THAN 95% OF ENM NODES ($tot_number_nodes_enm)"
exit 0
