#!/bin/bash

ip_ms=$1
netypes=$2
family=$3

tot_no_hb_ok=0
tot_number_nodes_fmsuperv=0

sshpass -p 12shroot ssh nagios@$ip_ms "sudo rm -rf /tmp/nagiosfmhbcollection*"

for m in $netypes;do
        number_nodes_fmsuperv=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * FmAlarmSupervision.active -neType=$m -t' | grep true | wc -l")
        tot_number_nodes_fmsuperv=$((tot_number_nodes_fmsuperv + number_nodes_fmsuperv))
        eval "number_nodes_${n}"=$number_nodes_fmsuperv
done

warning_value_float=`echo "$tot_number_nodes_fmsuperv * 0.95" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_fmsuperv * 0.8" | bc -l`
critical_value=${critical_value_float%.*}

for n in $netypes;do
	file_suffix=$(echo $n | sed -r 's/\-//g')
        nodes_for_collection=$(sshpass -p 12shroot ssh nagios@$ip_ms "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$n -t' | grep -i $n | awk '{print \$1}' > /tmp/nagiosfmhbcollection$file_suffix") 
	create_collection=$(sshpass -p 12shroot ssh nagios@$ip_ms "sudo /opt/ericsson/enmutils/bin/cli_app 'collection create nagiosfmhbcollection$file_suffix -f file:nagiosfmhbcollection$file_suffix' /tmp/nagiosfmhbcollection$file_suffix")
	no_hb_ok=$(sshpass -p 12shroot ssh nagios@$ip_ms "sudo /opt/ericsson/enmutils/bin/cli_app 'alarm status nagiosfmhbcollection$file_suffix' | awk '{print \$5}' | grep false | wc -l")
	tot_no_hb_ok=$((tot_no_hb_ok + no_hb_ok))
	delete_collection=$(sshpass -p 12shroot ssh nagios@$ip_ms "sudo /opt/ericsson/enmutils/bin/cli_app 'collection delete nagiosfmhbcollection$file_suffix'")
done

#	create_collection=$(sshpass -p 12shroot ssh nagios@$ip_ms "sudo /opt/ericsson/enmutils/bin/cli_app 'collection create nagiosfmhbcollection$family -f file:nagiosfmhbcollection$family' /tmp/nagiosfmhbcollection$family")

#	no_hb_ok=$(sshpass -p 12shroot ssh nagios@$ip_ms "sudo /opt/ericsson/enmutils/bin/cli_app 'alarm status nagiosfmhbcollection$family' | awk '{print \$5}' | grep false | wc -l")


#delete_collection=$(sshpass -p 12shroot ssh nagios@$ip_ms "sudo /opt/ericsson/enmutils/bin/cli_app 'collection delete nagiosfmhbcollection$family'")

if [[ "$tot_no_hb_ok" -lt "$warning_value" && "$tot_no_hb_ok" -gt "$critical_value" ]];then
	echo "WARNING- NUMBER OF $family NODES W/O FM HB FAILURES ($tot_no_hb_ok) IS FROM 80% TO 95% OF $family NODES WITH FM SUPERVISION ENABLED ($tot_number_nodes_fmsuperv)"
	exit 1	
fi

if [[ "$tot_no_hb_ok" -lt "$critical_value" ]];then
        echo "CRITICAL- NUMBER OF $family NODES W/O FM HB FAILURES ($tot_no_hb_ok) IS LOWER THAN 80% OF $family NODES WITH FM SUPERVISION ENABLED ($tot_number_nodes_fmsuperv)"
        exit 2
fi

echo "OK- NUMBER OF $family NODES W/O FM HB FAILURES ($tot_no_hb_ok) IS HIGHER THAN 95% OF $family NODES WITH FM SUPERVISION ENABLED ($tot_number_nodes_fmsuperv)"
exit 0
