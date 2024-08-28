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
netsim_name_param=$2
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

# Create fetched list
filename="$path_list_check_number_nodes/host_$2.netsim"
righe=$(wc -l $filename | awk '{print $1}')
riga=0
while [ $riga -lt $righe ]; do
let riga+=1
current=$(head -$riga $filename | tail -1)
#echo $current
fetched_files_list="$fetched_files_list $netsim_name-$current.athtem.eei.ericsson.se-nodes"
echo "$fetched_files_list" > $path_list_check_number_nodes/fetched_list_$2.netsim
done

# Count nodes (total numbers)
for n in $netypes;do
	number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$n -t' | grep -i $n | wc -l")
	tot_number_nodes_enm=$((tot_number_nodes_enm + number_nodes_enm))
	eval "number_nodes_${n}"=$number_nodes_enm
done

number_nodes_netsim=$(sshpass -p 12shroot ssh nagios@$1 "cd /opt/ericsson/enmutils/etc/nodes;cat $fetched_files_list | awk '{print $1}' | grep -v node_name | wc -l")

warning_value_float=`echo "$tot_number_nodes_enm * 0.95" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_enm * 0.8" | bc -l`
critical_value=${critical_value_float%.*}

if [[ ("$tot_number_nodes_enm" -lt "$warning_value") && ("$tot_number_nodes_enm" -gt "$critical_value") ]];then
	echo "WARNING- NUMBER OF NODES CONFIGURED IN ENM ($number_nodes_enm) IS BETWEEN 80% AND 95% OF NETSIM NODES ($number_nodes_netsim)"
	exit 1	
fi

if [[ "$tot_number_nodes_enm" -lt "$critical_value" ]];then
        echo "CRITICAL- NUMBER OF NODES CONFIGURED IN ENM ($tot_number_nodes_enm) IS LOWER THAN 80% OF NETSIM NODES ($number_nodes_netsim)"
        exit 2
fi

echo "OK- NUMBER OF NODES CONFIGURED IN ENM ($tot_number_nodes_enm) IS HIGHER THAN 95% OF NETSIM NODES ($number_nodes_netsim)"

# Create diff.netsim file if check.netsim and host.netsim are different
if diff -q $path_list_check_number_nodes/check_$2.netsim $path_list_check_number_nodes/host_$2.netsim; then
	echo "check_$2.netsim and host_$2.netsim are the same"
else
	diff -u $path_list_check_number_nodes/check_$2.netsim $path_list_check_number_nodes/host_$2.netsim | grep -v ' ' > $path_list_check_number_nodes/diff_$2.netsim 
  	echo "check_$2.netsim and host_$2.netsim are not the same"
fi

exit 0
