#!/bin/bash
exceed_usage=""

fs_state=$(sshpass -p '12shroot' ssh -tt nagios@$1 "sudo /opt/ericsson/enminst/bin/enm_healthcheck.sh --action node_fs_healthcheck")

#echo $fs_state

if [[ "$fs_state" = *"Successfully"* ]];then
	echo "OK"
	exit 0	
fi
if [[ "$fs_state" = *"exceed usage"* ]];then
#		exceed_usage=$(echo $fs_state | sed -n 's/.*exceed usage://p')
	echo "CRITICAL- THERE ARE FILESYSTEMS EXCEEDING USAGE|$fs_state"
	exit 2
fi
