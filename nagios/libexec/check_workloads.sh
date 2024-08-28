#!/bin/bash

workload_status=$(sshpass -p 12shroot ssh -q  nagios@$1 "sshpass -p 12shroot ssh -q root@$2 '/opt/ericsson/enmutils/bin/workload status --no-ansi'" | grep 'DEAD\|ERROR\|STARTING\|STOPPING' | awk '{print $1$3}')

workload_status_output_error=$(echo "$workload_status" | grep ERROR | sed -e "s/ERROR//" | awk 'BEGIN { ORS = " " } { print }')


workload_status_output_dead=$(echo "$workload_status" | grep DEAD | sed -e "s/DEAD//" | awk 'BEGIN { ORS = " " } { print }')


workload_status_output_starting=$(echo "$workload_status" | grep STARTING | sed -e "s/STARTING//" | awk 'BEGIN { ORS = " " } { print }')


workload_status_output_stopping=$(echo "$workload_status" | grep STOPPING | sed -e "s/STOPPING//" | awk 'BEGIN { ORS = " " } { print }')


workload_status_critical="$workload_status_output_dead$workload_status_output_starting$workload_status_output_stopping"


if [ -n "$workload_status_critical" ];then
  echo "CRITICAL- THERE ARE WORKLOAD PROFILES WHICH ARE IN DEAD/STARTING/STOPPING STATE | DEAD WORKLOADS: $workload_status_output_dead STARTING WORKLOADS: $workload_status_output_starting STOPPING WORKLOADS: $workload_status_output_stopping"
  exit 2
fi

if [ -n "$workload_status_output_error" ];then
        	echo "WARNING- THERE ARE WORKLOAD PROFILES WHICH ARE IN ERROR STATE | $workload_status_output_error"
		exit 1
	fi

echo "OK- ALL WORKLOAD PROFILES ARE RUNNING" 
exit 0
