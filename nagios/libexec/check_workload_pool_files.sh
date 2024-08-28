#!/bin/bash
netsim_name="ieatnetsimv5116"
netsim_hosts="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 108 109 110"

fetched_files_list=""
tot_number_nodes_enm=0

for i in $netsim_hosts;do
        fetched_files_list="$fetched_files_list $netsim_name-$i.athtem.eei.ericsson.se-nodes"
done

number_of_files=$(echo $fetched_files_list | wc -w)

echo $fetched_files_list


fetched_files_list_wl=$(sshpass -p 12shroot ssh nagios@$1 "sudo sshpass -p 12shroot ssh root@$2 'ls /opt/ericsson/enmutils/etc/nodes/'")

number_of_files_wl=$(echo $fetched_files_list_wl | wc -w) 

#if [[ "$number_of_files_wl" != "$number_of_files" ]];then
#	echo "CRITICAL- NUMBER OF PARSED NODE FILES IN WORKLOAD VM ($number_of_files_wl) IS DIFFERENT FROM THE REQUIRED"
#	exit 2
#fi
missing_files=""
for fetched_file in $fetched_files_list;do
	if [[ $fetched_files_list_wl != *$fetched_file* ]];then
		missing_files=$missing_files" "$fetched_file
	fi
done

if [[ ! -z "$missing_files" ]];then
        echo "CRITICAL- THERE ARE PARSED NODE FILES NOT PRESENT IN WORKLOAD VM | $missing_files"
        exit 2
fi


check_files_diff=''

make_temp_dir=$(sshpass -p 12shroot ssh nagios@$1 "sudo sshpass -p 12shroot ssh root@$2 'mkdir /tmp/nodes/'") 

copy_files=$(sshpass -p 12shroot ssh nagios@$1 "sudo sshpass -p 12shroot scp /opt/ericsson/enmutils/etc/nodes/* root@$2:/tmp/nodes/")

check_files_diff=$(sshpass -p 12shroot ssh nagios@$1 "sudo sshpass -p 12shroot ssh root@$2 'diff --brief -r /opt/ericsson/enmutils/etc/nodes/ /tmp/nodes/'")

delete_temp_files=$(sshpass -p 12shroot ssh nagios@$1 "sudo sshpass -p 12shroot ssh root@$2 'rm -rf /tmp/nodes/'")

if [[ "$check_files_diff" != "" ]];then
	echo "CRITICAL- THERE ARE DIFFERENCES BETWEEN PARSED NODE FILES IN MS AND FILES IN WORKLOAD VM! WORKLOAD POOL IS NOT VALID | $check_files_diff"
	exit 2	
fi
echo "OK- NO DIFFERENCE FOUND IN PARSED NODE FILES" 
exit 0
