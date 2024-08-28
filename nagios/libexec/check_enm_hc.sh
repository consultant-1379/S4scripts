#!/bin/bash


status=$(sshpass -p 12shroot ssh -tt nagios@$1 "sudo /opt/ericsson/enminst/bin/enm_healthcheck.sh --action $2 -v")

if [[ "$status" = *"Successfully"* ]];then
	echo "OK- $2 SUCCESSFULLY PASSED"
	exit 0	
else
	echo "CRITICAL- $2 FAILED| $status"
	exit 2
fi
