#!/bin/bash

workload_status=$(sshpass -p 12shroot ssh nagios@$1 "sshpass -p 12shroot ssh root@$2 '/opt/ericsson/enmutils/bin/workload status'" | grep 'DEAD\|ERROR' | awk '{print $1$3}')

#workload_status_output=$(echo "$workload_status" | sed -e "s/ERROR//" | sed -e "s/DEAD//" | awk 'BEGIN { ORS = " " } { print }' | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g')

workload_status_output_error=$(echo "$workload_status" | grep ERROR | sed -e "s/ERROR//" | awk 'BEGIN { ORS = " " } { print }' | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g')

workload_status_output_dead=$(echo "$workload_status" | grep DEAD | sed -e "s/ERROR//" | awk 'BEGIN { ORS = " " } { print }' | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g')

if [[ "$workload_status" = *"DEAD"* ]];then
	echo "CRITICAL- THERE ARE WORKLOAD PROFILES WHICH ARE IN DEAD STATE | $workload_status_output_dead"
	exit 2	
else
	if [[ "$workload_status" = *"ERROR"* ]];then
        	echo "WARNING- THERE ARE WORKLOAD PROFILES WHICH ARE IN ERROR STATE | $workload_status_output_error"
		exit 1
	fi
fi
echo "OK- ALL WORKLOAD PROFILES ARE RUNNING" 
exit 0
