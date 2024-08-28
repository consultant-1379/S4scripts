#!/bin/bash

stopped_nodes=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/netsim info $2 --no-ansi | grep stopped | wc -l")

if [ "$stopped_nodes" -eq "0" ];then
	echo "OK- THERE ARE NO STOPPED NODES"
	exit 0	
else
	echo "CRITICAL- THERE ARE STOPPED NODES"
	exit 2
fi

