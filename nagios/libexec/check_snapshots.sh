#!/bin/bash

is_snapshot=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enminst/bin/enm_snapshots.bsh --action list_snapshot" | grep "ENM list_snapshot finished successfully")

if [[ $is_snapshot != *"No LUN snapshots found on the system"* ]];then
	echo "CRITICAL- ENM SNAPSHOTS ARE PRESENT"
	exit 1	
fi

echo "OK- NO ENM SNAPSHOTS ARE PRESENT"
exit 0
