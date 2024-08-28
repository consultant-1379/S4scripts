#!/bin/bash

# ************************************************************************************
# Company:      Ericsson
# Autor:        S4 Team (Genoa)
# Description:  
# Parameters:	
# Note:         
# Files:        
# ************************************************************************************

IP_param=$1
netsim_name_param=$2 #"ieatnetsimv5116 ieatnetsimv017"
neType_param=$3

path_list_check_number_nodes="/usr/local/nagios/libexec/s4/list_check_number_nodes"

netsim_name=$netsim_name_param
netypes=$neType_param

fetched_files_list=""
tot_number_nodes_enm=0

# Create .txt file with list Netsim (only number) da sostituire il nome del Netsim con $2
sshpass -p 12shroot ssh nagios@$1 "sudo ls -1v /opt/ericsson/enmutils/etc/nodes/ | grep $2 | sed 's/.athtem.eei.ericsson.se-nodes//' | sed 's/$2-//'  > /tmp/check_$2.netsim"
# Move check.netsim from Server to Nagios on /tmp
sshpass -p 12shroot ssh nagios@$1 "sudo cat /tmp/check_$2.netsim" > /tmp/check_$2.netsim
# Move check.netsim from Nagios /tmp from Nagios /usr/local/nagios/libexec/s4/list_check_number_nodes
mv /tmp/check_$2.netsim $path_list_check_number_nodes

# Create diff.netsim file if check.netsim and host.netsim are different
status=$(diff -q $path_list_check_number_nodes/check_$2.netsim $path_list_check_number_nodes/host_$2.netsim | awk '{print $ 5;}')

if [ "$status" == "differ" ]; then
    echo "CRITICAL - Please view in $1 management server into /opt/ericsson/enmutils/etc/nodes/"
	echo ""
	echo "On $2 files check_$2.netsim and host_$2.netsim are not the same" # ciclare qui
    exit 2
fi

#diff -u $path_list_check_number_nodes/check_$2.netsim $path_list_check_number_nodes/host_$2.netsim | grep -v ' '
#diff -q $path_list_check_number_nodes/check_$2.netsim $path_list_check_number_nodes/host_$2.netsim | awk '{print $5}'
echo "OK - check_$2.netsim and host_$2.netsim are the same"
echo ""

exit 0