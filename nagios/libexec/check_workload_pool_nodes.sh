#!/bin/bash

netypes="BSC DSC ERBS HLR-FE HLR-FE-BSP HLR-FE-IS MGW MINI-LINK-6352 MINI-LINK-Indoor MSC-BC-IS MSC-BB-BSP MTAS RadioNode RBS RNC Router6672 SGSN-MME SIU02 TCU02 vHLR-FE"

number_nodes=""

tot_number_nodes_enm=0
netypes_output=""
i=0




sshpass -p 12shroot ssh nagios@$1 "sshpass -p 12shroot ssh root@$2 '/opt/ericsson/enmutils/bin/workload list all --no-ansi'" > /tmp/workload_nodes.txt

for n in $netypes;do
	        
	number_nodes=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$n -t' | grep -i $n | wc -l")
	i=$((i+1))
	netypes_output="$netypes_output $n: $number_nodes"


	case $n in
		"BSC") ;;
		"DSC");;
		"ERBS")
			ERBScpp=$(cat /tmp/workload_nodes.txt | grep RBS | grep ieatnetsim | wc -l) ;;
		"HLR-FE");;
		"HLR-FE-BSP");;
		"HLR-FE-IS");;
		"MGW");;
		"MINI-LINK-6352");;
		"MINI-LINK-Indoor");;
		"MSC-BC-IS");;
		"MSC-BB-BSP");;
		"MTAS");;
		"RadioNode");;
		"RBS");;
		"RNC");;
		"Router6672");;
		"SGSN-MME");;
		"SIU02");;
		"TCU02");;
		"vHLR-FE");;

	esac
done

echo $netypes_output
echo $ERBScpp

