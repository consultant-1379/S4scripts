#!/bin/bash

faulted_sg=$(sshpass -p '12shroot' ssh -tt nagios@$1 "sudo /opt/ericsson/enminst/bin/vcs.bsh --groups | grep FAULT")

if [[ "$faulted_sg" = *"FAULTED"* ]];then
	echo "CRITICAL- THERE ARE FAULTED SG!"
	exit 2	
else
	echo "OK"
	exit 0
fi
