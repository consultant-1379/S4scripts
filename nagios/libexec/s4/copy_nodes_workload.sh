#!/bin/bash

# ************************************************************************************
# Company:      Ericsson
# Autor:        S4 Team (Genoa)
# Description:  if directory /nodes is not aligned with workload machine and updates 
#               it automatically
# Parameters:   IP Server | Workload machine
#               For example ./copy_nodes_workload.sh 141.137.208.23 ieatwlvm5116
# Note:         this script save some files in      -> list_copy_nodes_workload
# Files:        nodes_now.txt                       -> list directory new
#               nodes_story.txt                     -> list directory previous
#               restored_[date].txt                 -> log direcorty restored
# ************************************************************************************

IP_param=$1
workload_param=$2

path_list_copy_nodes_workload="/usr/local/nagios/libexec/s4/list_copy_nodes_workload"
info_dir=""

# use test or which
check_dir=$(sshpass -p 12shroot ssh nagios@$IP_param "test -d /opt/ericsson/enmutils/etc/nodes/ && echo 'nodes dir exists' || echo 'nodes not found' ")
check_scp=$(sshpass -p 12shroot ssh nagios@$IP_param "test scp && echo 'scp ok' || 'No usable scp found' ")

sshpass -p 12shroot ssh nagios@$IP_param "sudo ls -1v /opt/ericsson/enmutils/etc/nodes/" > $path_list_copy_nodes_workload/nodes_now.txt
status_if=$(diff -q $path_list_copy_nodes_workload/nodes_now.txt $path_list_copy_nodes_workload/nodes_story.txt | awk '{print $ 5;}')

	if [ "$status_if" == "differ" ]; then #if nodes is changed 
        info_dir="nodes dir restored"
        NOW=$(date +"%d-%m-%y_%H-%M-%S")
        sshpass -p 12shroot ssh nagios@$1 "sudo scp -r root@$2:/opt/ericsson/enmutils/etc/nodes/ /opt/ericsson/enmutils/etc/" #copy nodes form workload machine
        sshpass -p 12shroot ssh nagios@$IP_param "sudo ls -1v /opt/ericsson/enmutils/etc/nodes/" > $path_list_copy_nodes_workload/nodes_story.txt
	fi

if [[ ("$check_dir" == "nodes not found") ]];then #CRITICAL
    echo $check_scp - $check_dir - $info_dir
    sshpass -p 12shroot ssh nagios@$1 "sudo scp -r root@$2:/opt/ericsson/enmutils/etc/nodes/ /opt/ericsson/enmutils/etc/" #copy nodes form workload machine
    sshpass -p 12shroot ssh nagios@$IP_param "sudo ls -1v /opt/ericsson/enmutils/etc/nodes/" > $path_list_copy_nodes_workload/nodes_story.txt
    sshpass -p 12shroot ssh nagios@$IP_param "sudo ls -1v /opt/ericsson/enmutils/etc/nodes/" > $path_list_copy_nodes_workload/nodes_not_present_$NOW.txt
exit 2
fi
if [[ ("$status_if" == "differ") ]];then #WARNING
    echo $check_scp - $check_dir - $info_dir
    sshpass -p 12shroot ssh nagios@$IP_param "sudo ls -1v /opt/ericsson/enmutils/etc/nodes/" > $path_list_copy_nodes_workload/restored_$NOW.txt
exit 1
fi
echo $check_scp - $check_dir - $info_dir