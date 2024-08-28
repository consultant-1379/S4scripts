#!/bin/bash

# ************************************************************************************
# Company:      Ericsson
# Autor:        S4 Team (Genoa)
# Description:  counts the number of nodes by type and verifies if the
#               configuration files correspond to those expected
# Parameters:   IP Server | netsim name | netsim type 
#               For example ./check_number_nodes.sh 141.137.208.23 ieatnetsimv5116 DSC
# Note:         this script save some files in      -> list_check_number_nodes
# Files:        host_[netsimname].netsim            -> manual configuration
#               fetched_list_[netsimname].netsim    -> script created
#               diff_[netsimname].netsim            -> script created
#               check_[netsimname].netsim           -> script created
# ************************************************************************************

IP_param=$1
neType_param=$2
#netsim_name_param=$3
netsim_name=(ieatnetsimv5116 ieatnetsimv017)

path_list_check_number_nodes="/usr/local/nagios/libexec/s4/list_check_number_nodes"

#netsim_name=$netsim_name_param
netypes=$neType_param

fetched_files_list=""
tot_number_nodes_enm=0

for u in "${netsim_name[@]}"
do
	# Create .txt file with list Netsim (only number) check_
	sshpass -p 12shroot ssh nagios@$1 "sudo ls -1v /opt/ericsson/enmutils/etc/nodes/ | grep $u | sed 's/.athtem.eei.ericsson.se-nodes//' | sed 's/$u-//'  > /tmp/check_$u.netsim"
	# Move check.netsim from Server to Nagios on /tmp
	sshpass -p 12shroot ssh nagios@$1 "sudo cat /tmp/check_$u.netsim" > /tmp/check_$u.netsim
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

	# Count nodes (total numbers)
	for n in $netypes;do
		number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$IP_param "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$neType_param -t' | grep -i $n | wc -l")
		#echo $number_nodes_enm > number_nodes_enm.txt
		tot_number_nodes_enm=$((number_nodes_enm))
		eval "number_nodes_${n}"=$number_nodes_enm
	done
	#extra_nodes_enm=$(sshpass -p 12shroot ssh nagios@$IP_param "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$neType_param -t' | wc -l")
	#diff_nodes_enm=$((tot_number_nodes_enm - extra_nodes_enm))

	number_nodes_netsim=$(sshpass -p 12shroot ssh nagios@$IP_param "grep -w '$netypes' /opt/ericsson/enmutils/etc/nodes/*$u* | wc -l")
	number_nodes_netsim_1=$((number_nodes_netsim + number_nodes_netsim_1))

	warning_value_float=`echo "$tot_number_nodes_enm_1 * 0.95" | bc -l`
	warning_value=${warning_value_float%.*}
	warning_value_1=$((warning_value + warning_value_1))

	critical_value_float=`echo "$tot_number_nodes_enm_1 * 0.8" | bc -l`
	critical_value=${critical_value_float%.*}
	critical_value_1=$((critical_value + critical_value_1))

done

	if [[ ("$tot_number_nodes_enm" -lt "$warning_value") && ("$tot_number_nodes_enm" -gt "$critical_value_1") ]];then
		echo "TOTAL number of nodes configured in ENM " $tot_number_nodes_enm_1 " is BETWEEN 80% and 95% of Netsim nodes " $number_nodes_netsim_1 " NETSIM" #WARNING
		echo ""
		for u_check in "${netsim_name[@]}"
		do
			if [[ "_$tot_number_nodes_enm" -lt "$_critical_value" ]];then
				echo "CRITICAL - on $u_check number of nodes configured in ENM ($_tot_number_nodes_enm) is LOWER that 80%  of Netsim nodes ($_number_nodes_netsim)"
			fi
			if [[ ("$_tot_number_nodes_enm" -lt "$_warning_value") && ("$_tot_number_nodes_enm" -gt "$_critical_value") ]];then
				echo "WARNING - on $u_check number of nodes configured in ENM ($_tot_number_nodes_enm) is BETWEEN 80% and 95%  of Netsim nodes ($_number_nodes_netsim)"
			fi

			#echo "WARNING - on $u number of nodes configured in ENM ($tot_number_nodes_enm) is BETWEEN 80% and 95%  of Netsim nodes ($number_nodes_netsim)"
		done
		exit 1	
	fi

	if [[ "$tot_number_nodes_enm" -lt "$critical_value_1" ]];then
		echo "TOTAL number of nodes configured in ENM " $tot_number_nodes_enm "is LOWER that 80% of Netsim nodes " $number_nodes_netsim_1 " NETSIM" #CRITICAL
		echo ""
		for u_check in "${netsim_name[@]}"
		do

        # ############################# ################################ ########################
        for _n in $netypes;do   # Count nodes (total numbers)
            _number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$IP_param "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$_n -t' | grep -i $_n | wc -l")
            _tot_number_nodes_enm=$((_tot_number_nodes_enm + _number_nodes_enm))
            eval "_number_nodes_${_n}"=$_number_nodes_enm
        done
        _tot_number_nodes_enm_1=$((_tot_number_nodes_enm + _tot_number_nodes_enm_1))

        _number_nodes_netsim=$(sshpass -p 12shroot ssh nagios@$IP_param "grep -w '$netypes' /opt/ericsson/enmutils/etc/nodes/*$u_check* | wc -l")
        _number_nodes_netsim_1=$((_number_nodes_netsim + _number_nodes_netsim_1))

        _warning_value_float=`echo "$_tot_number_nodes_enm_1 * 0.95" | bc -l`
        _warning_value=${_warning_value_float%.*}
        _warning_value_1=$((_warning_value + _warning_value_1))

        _critical_value_float=`echo "$_tot_number_nodes_enm_1 * 0.8" | bc -l`
        _critical_value=${_critical_value_float%.*}
        _critical_value_1=$((_critical_value + _critical_value_1))
        # ############################# ################################ ########################

			if [[ "_$tot_number_nodes_enm" -lt "$_critical_value" ]];then
				echo "CRITICAL - on $u_check number of nodes configured in ENM ($_tot_number_nodes_enm) is LOWER that 80% of Netsim nodes ($_number_nodes_netsim)"
			fi
			if [[ ("$_tot_number_nodes_enm" -lt "$_warning_value") && ("$_tot_number_nodes_enm" -gt "$_critical_value") ]];then
				echo "WARNING - on $u_check number of nodes configured in ENM ($_tot_number_nodes_enm) is BETWEEN 80% and 95% of Netsim nodes ($_number_nodes_netsim)"
			fi
		done
		exit 2
	fi

		echo "TOTAL number of nodes configured in ENM ($tot_number_nodes_enm) is HIGHER that 95% of Netsim nodes Netsim ($number_nodes_netsim_1)" #OK
		echo ""
		for u_check in "${netsim_name[@]}"
		do

        # ############################# ################################ ########################
        #for _n in $netypes;do   # Count nodes (total numbers)
            _number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$IP_param "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$neType_param -t' | grep -i $u_check | wc -l")
            _tot_number_nodes_enm=$((_number_nodes_enm))
            eval "_number_nodes_${_n}"=$_number_nodes_enm
        #done
        #_tot_number_nodes_enm_1=$((_tot_number_nodes_enm + _tot_number_nodes_enm_1))

        _number_nodes_netsim=$(sshpass -p 12shroot ssh nagios@$IP_param "grep -w '$netypes' /opt/ericsson/enmutils/etc/nodes/*$u_check* | wc -l")
        _number_nodes_netsim_1=$((_number_nodes_netsim + _number_nodes_netsim_1))

        _warning_value_float=`echo "$_tot_number_nodes_enm_1 * 0.95" | bc -l`
        _warning_value=${_warning_value_float%.*}
        _warning_value_1=$((_warning_value + _warning_value_1))

        _critical_value_float=`echo "$_tot_number_nodes_enm_1 * 0.8" | bc -l`
        _critical_value=${_critical_value_float%.*}
        _critical_value_1=$((_critical_value + _critical_value_1))
        # ############################# ################################ ########################

			echo "OK - on $u_check number of nodes configured in ENM ($_tot_number_nodes_enm) is higher that 95% of Netsim nodes ($_number_nodes_netsim)"

		done
	#done




