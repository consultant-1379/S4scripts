#!/bin/bash

# ************************************************************************************
# Company:      Ericsson
# Autor:        S4 Team (Genoa)
# Description:  counts the number of nodes by type and verifies if the
#               configuration files correspond to those expected
# Parameters:   IP Server | Workload | Node Type | Netsim  
#               For example ./check_number_nodes.sh 141.137.208.23 10.151.193.14 BSC "ieatnetsimv5116 ieatnetsimv017"
# Note:         this script save some files in      -> list_check_number_nodes
# Files:        fetched_list_[netsimname].netsim    -> script created
#               check_[netsimname].netsim           -> script created
# ************************************************************************************

source /usr/local/nagios/libexec/s4/common_functions.sh

IP_param=$1
wkl_vm_ip=$2
neType_param=$3
netsim_name=($4)

	neType_param_change=$neType_param
	grep_set=0 # Default grep additional No

	# Management differences ENM / NetSim 
	if [ $neType_param == 'CISCO-ASR900' ]; then 			# ENM
		neType_param_change='ASR900' 						# Netsim
	fi
	if [ $neType_param == 'FRONTHAUL-6080' ]; then 			# ENM
		neType_param_change='Fronthaul-6080' 				# Netsim
	fi
	if [ $neType_param == 'MINI-LINK-Indoor' ]; then 		# ENM
		neType_param_change='MLTN' 							# Netsim
	fi
	if [ $neType_param == 'SGSN-MME' ]; then 				# ENM
		neType_param_change='SGSN' 							# Netsim
	fi
	if [ $neType_param == 'MSC-BC-IS' ]; then 				# ENM
		neType_param_change=' MSC-BC-IS' 					# Netsim
		grep_set=1		
	fi
	if [ $neType_param == 'MSC-BC-BSP' ]; then 				# ENM
		neType_param_change=' MSC-BC-BSP' 					# Netsim
		grep_set=1		
	fi
	if [ $neType_param == 'MSC-DB-BSP' ]; then 				# ENM
		neType_param_change=' MSC-DB-BSP' 					# Netsim
		grep_set=1											# Setting grep additional Yes
	fi

path_list_check_number_nodes="/usr/local/nagios/libexec/s4/list_check_number_nodes"

#netsim_name=$netsim_name_param
netypes=$neType_param

fetched_files_list=""
tot_number_nodes_enm=0

for u in "${netsim_name[@]}"
do
	# Create .txt file with list Netsim (only number) check_
	sshpass -p 12shroot ssh nagios@$1 "sudo ssh root@$wkl_vm_ip ls -1v /opt/ericsson/enmutils/etc/nodes/ | grep $u | sed 's/.athtem.eei.ericsson.se-nodes//' | sed 's/$u-//'  > /tmp/check_$u.netsim"
	# Move check.netsim from Server to Nagios on /tmp
	sshpass -p 12shroot ssh nagios@$1 "sudo ssh root@$wkl_vm_ip cat /tmp/check_$u.netsim" > /tmp/check_$u.netsim
	# Move check.netsim from Nagios /tmp from Nagios /usr/local/nagios/libexec/s4/list_check_number_nodes
	mv /tmp/check_$u.netsim $path_list_check_number_nodes

	# Create fetched list
	filename="$path_list_check_number_nodes/host_$u.netsim"
	righe=$(wc -l $filename | awk '{print $1}')
	riga=0
	while [ $riga -lt $righe ]; do
	let riga+=1
	current=$(head -$riga $filename | tail -1)
	#echo $current
	fetched_files_list="$fetched_files_list $netsim_name-$current.athtem.eei.ericsson.se-nodes"
	echo "${fetched_files_list}_${u}" > $path_list_check_number_nodes/fetched_list_$u.netsim
	done

	# Count ENM nodes (total numbers)
	for n in $netypes;do
        number_nodes_enm=$(count_number_nodes_enm $IP_param $wkl_vm_ip $neType_param)
		tot_number_nodes_enm=$((number_nodes_enm))
		#eval "number_nodes_${n}"=$number_nodes_enm
	done

	# Count NetSim nodes (total numbers)
	if [[ "$grep_set" == 1 ]];then
		number_nodes_netsim=$(sshpass -p 12shroot ssh nagios@$IP_param "sudo ssh root@$wkl_vm_ip grep -w | grep '$neType_param_change' /opt/ericsson/enmutils/etc/nodes/*$u* | wc -l")
	fi
	if [[ "$grep_set" == 0 ]];then
		number_nodes_netsim=$(sshpass -p 12shroot ssh nagios@$IP_param "grep -w '$neType_param_change' /opt/ericsson/enmutils/etc/nodes/*$u* | wc -l")
	fi
	number_nodes_netsim_1=$((number_nodes_netsim + number_nodes_netsim_1))

	warning_value_float=`echo "$tot_number_nodes_enm * 0.95" | bc -l`
	warning_value=${warning_value_float%.*}
	warning_value_1=$((warning_value + warning_value_1))

	critical_value_float=`echo "$tot_number_nodes_enm * 0.8" | bc -l`
	critical_value=${critical_value_float%.*}
	critical_value_1=$((critical_value + critical_value_1))

done


#if [[ ("$tot_number_nodes_enm" -lt "$warning_value_1") && ("$tot_number_nodes_enm" -gt "$critical_value_1") ]];then
if [[ "$tot_number_nodes_enm" != "$number_nodes_netsim_1" ]];then

	#Numero di ENM è minore di warning e numero ENM è maggiore di critical
	if [[ ("$tot_number_nodes_enm" -lt "$warning_value_1") && ("$tot_number_nodes_enm" -gt "$critical_value") ]];then
		echo "WARNING - NUMBER OF NODES CONFIGURED IN ENM ($number_nodes_enm) IS BETWEEN 80% AND 95% OF NETSIM NODES ($number_nodes_netsim_1)"
		exit 1	
	fi

	#Numero di ENM è minore di critical 
	if [[ "$tot_number_nodes_enm" -lt "$critical_value_1" ]];then
        echo "CRITICAL - NUMBER OF NODES CONFIGURED IN ENM ($tot_number_nodes_enm) IS LOWER THAN 80% OF NETSIM NODES ($number_nodes_netsim_1)"
        exit 2
	fi
	#echo "WARNING - NUMBER OF NODES CONFIGURED IN ENM ($number_nodes_enm) IS MAGIOR OF NETSIM NODES ($number_nodes_netsim_1)"
	#echo "WARNING- NUMBER OF NODES CONFIGURED IN ENM ($number_nodes_enm) IS NOT EQUAL OF NETSIM NODES ($number_nodes_netsim_1)"
	#exit 1	
fi

if [[ "$tot_number_nodes_enm" == "$number_nodes_netsim_1" ]];then
	echo "OK - NUMBER OF NODES CONFIGURED IN ENM ($tot_number_nodes_enm) IS EQUAL OF NETSIM NODES ($number_nodes_netsim_1)"
	exit 0
fi





