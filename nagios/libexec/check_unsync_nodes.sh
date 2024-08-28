#!/bin/bash

summary=""
netypes="BSC CISCO-ASR900 DSC EPG ERBS ESC FRONTHAUL-6080 RBS MTAS MGW SGSN-MME RadioNode RNC MINI-LINK-6352 MINI-LINK-Indoor MSC-BC-BSP MSC-BC-IS MSC-DB-BSP Router6274 Router6672 SBG-IS"
netype=""
for netype in $netypes;do 
#	echo $netype
	nodes_unsync=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * CmFunction.syncStatus!=SYNCHRONIZED --neType=$netype -t' | egrep -w UNSYNCHRONIZED | wc -l")
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

