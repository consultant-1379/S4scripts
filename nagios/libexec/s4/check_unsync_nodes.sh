#!/bin/bash

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1
wkl_vm_ip=$2
netype=$3

#number_nodes_enm=$(count_number_nodes_enm $lms_ip $wkl_vm_ip $netype)

for n in $netype;do
#	echo $netype
	#nodes_unsync=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * CmFunction.syncStatus!=SYNCHRONIZED --neType=$netype -t' | egrep -w UNSYNCHRONIZED | wc -l")
	nodes_unsync=$(count_number_nodes_unsyn $lms_ip $wkl_vm_ip $netype)
#	echo $nodes_unsync
	if [ "$nodes_unsync" -ne "0" ];then
		summary="$summary $netype: $nodes_unsync"
	fi
done

#echo $summary
if [ -z "$summary" ];then
	echo "OK"
        exit 0
else
        echo "WARNING- THE FOLLOWING NODES ARE NOT SYNCHRONIZED:|$summary"
        exit 1
fi

