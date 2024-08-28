#!/bin/bash

netsim_cpuidle=$(sshpass -p 12shroot ssh nagios@$1 "sudo sshpass -p shroot ssh root@$2 sar -u 10 3 | tail -1" | awk '{print $8}')

netsim_cpuused=$(echo - | awk "{print 100 - $netsim_cpuidle}")

if [[ "$netsim_cpuused" == 9[0-9]* ]];then
	echo "	WARNING- CPU IS USED $netsim_cpuused%"
	exit 2	
else
	if [[ "$netsim_cpuused" == 100 ]];then
		echo "CRITICAL- CPU IS USED 100%!"
		exit 2
	fi
fi
echo "OK- CPU IS USED $netsim_cpuused%"
exit 0
