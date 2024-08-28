#!/bin/bash

netsim_fs=$(sshpass -p 12shroot ssh nagios@$1 "sudo sshpass -p shroot ssh root@$2 'df -h'")

if [[ "$netsim_fs" == *9[0-9]%* ]];then
	echo "	WARNING- FILESYSTEM IS USED >90%"
	exit 2	
else
	if [[ "$netsim_fs" == *100%* ]];then
		echo "CRITICAL- FILESYSTEM IS FULL!"
		exit 2
	fi
fi
echo "OK"
exit 0
