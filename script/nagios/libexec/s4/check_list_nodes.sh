#!/bin/bash

# ************************************************************************************
# Company:      Ericsson
# Autor:        S4 Team (Genoa)
# Description:  check nodes list in directory /nodes is equal from 
#				configuration file on deployment 
# Parameters:   IP Server | netsim name 
#               For example ./check_list_nodes.sh 141.137.208.23 
# Note:         this script save some files in      -> list_check_number_nodes
# Files:        host_[netsimname].netsim            -> manual configuration
#               fetched_list_[netsimname].netsim    -> script created
#               diff_[netsimname].netsim            -> script created
#               check_[netsimname].netsim           -> script created
# ************************************************************************************

IP_param=$1
netsim_name=(ieatnetsimv5116 ieatnetsimv017)
#netsim_name=($2)

path_list_check_number_nodes="/usr/local/nagios/libexec/s4/list_check_number_nodes"

#netsim_name=$netsim_name_param
netypes=$neType_param

fetched_files_list=""
tot_number_nodes_enm=0

status_check_1=0
status_check=0

#for m in $netsim_name;do
for u in "${netsim_name[@]}"
do
	# Create .txt file with list Netsim (only number) check_
	sshpass -p 12shroot ssh nagios@$IP_param "sudo ls -1v /opt/ericsson/enmutils/etc/nodes/ | grep $u | sed 's/.athtem.eei.ericsson.se-nodes//' | sed 's/$u-//'  > /tmp/check_$u.netsim"
	# Move check.netsim from Server to Nagios on /tmp
	sshpass -p 12shroot ssh nagios@$IP_param "sudo cat /tmp/check_$u.netsim" > /tmp/check_$u.netsim
	# Move check.netsim from Nagios /tmp from Nagios /usr/local/nagios/libexec/s4/list_check_number_nodes
	mv /tmp/check_$u.netsim $path_list_check_number_nodes
	# Create diff.netsim file if check.netsim and host.netsim are different
	status_check_1=$(diff -u $path_list_check_number_nodes/check_$u.netsim $path_list_check_number_nodes/host_$u.netsim | grep -v ' ' | grep -v "+" | wc -l)
	status_check=$((status_check + status_check_1))
done

	if [ $status_check -ge 10 ]; then
		echo "CRITICAL - some $neType_param type nodes in management server ($IP_param) are different ($status_check)"
		echo ""
		for u_check in "${netsim_name[@]}"
		do
		status_if=$(diff -q $path_list_check_number_nodes/check_$u_check.netsim $path_list_check_number_nodes/host_$u_check.netsim | awk '{print $ 5;}') #deve stare dentro al ciclo interno
		if [ "$status_if" == "differ" ]; then
			echo "$u_check are different nodes types ("$(diff -u $path_list_check_number_nodes/check_$u_check.netsim $path_list_check_number_nodes/host_$u_check.netsim | grep -v ' ' | grep -v '+' | wc -l)")"
		else
			echo "$u_check there are no different nodes types" 	
		fi
		done
		echo ""
		echo "Please check with ls -1v /opt/ericsson/enmutils/etc/nodes/"
		echo ""
		exit 2
	fi

	if [ $status_check -lt 10 ]; then
		echo "WARNING - some $neType_param type nodes in management server ($IP_param) are different ($status_check)"
		echo ""
		for u_check in "${netsim_name[@]}"
		do
		status_if=$(diff -q $path_list_check_number_nodes/check_$u_check.netsim $path_list_check_number_nodes/host_$u_check.netsim | awk '{print $ 5;}') #deve stare dentro al ciclo interno
		if [ "$status_if" == "differ" ]; then
			echo "$u_check are different nodes types ("$(diff -u $path_list_check_number_nodes/check_$u_check.netsim $path_list_check_number_nodes/host_$u_check.netsim | grep -v ' ' | grep -v '+' | wc -l)")"
		else
			echo "$u_check there are no different nodes types" 	
		fi
		done
		echo ""
		echo "Please check with ls -1v /opt/ericsson/enmutils/etc/nodes/"
		echo ""
		exit 1
	fi

	if [ $status_check == 0 ]; then
			echo "OK - there are no different nodes types in management server ($IP_param)"
			echo ""
			exit 0
	fi



