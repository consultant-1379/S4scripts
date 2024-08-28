#!/bin/bash

cmd=$(sshpass -p '12shroot' ssh nagios@$1 "ping -c3 $2")

if [[ "$cmd" ]];then
	echo "PING OK"
	exit 0	
else
	echo "PING NOK"
	exit 2
fi
