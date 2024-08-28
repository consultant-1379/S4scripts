#!/bin/bash

#netypes="BSC DSC ERBS HLR-FE HLR-FE-BSP HLR-FE-IS MGW MINI-LINK-6352 MINI-LINK-Indoor MSC-BC-IS MTAS RadioNode RBS RNC Router6672 SGSN-MME vHLR-FE"

netypes=$2
http_url=$3
number_pm_files_by_node=$4

fetched_files_list=""
tot_number_nodes_pmsuperv=0

for m in $netypes;do
        number_nodes_pmsuperv=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * PmFunction.pmEnabled==true -neType=$m -t' | grep true | wc -l")
        tot_number_nodes_pmsuperv=$((tot_number_nodes_pmsuperv + number_nodes_pmsuperv))
        eval "number_nodes_${n}"=$number_nodes_pmsuperv
done

tot_expected_pm_files=`echo "$tot_number_nodes_pmsuperv * $number_pm_files_by_node" | bc -l`
#number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement' | grep NetworkElement | wc -l")


warning_value_float=`echo "$tot_number_nodes_pmsuperv * 0.95 * $number_pm_files_by_node" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_pmsuperv * 0.8 * $number_pm_files_by_node" | bc -l`
critical_value=${critical_value_float%.*}


cyear=$(sshpass -p 12shroot ssh nagios@$1 "sudo date -d '-30 min' +%Y")
cmonth=$(sshpass -p 12shroot ssh nagios@$1 "sudo date -d '-30 min' +%m")
cday=$(sshpass -p 12shroot ssh nagios@$1 "sudo date -d '-30 min' +%d")
cmin=$(sshpass -p 12shroot ssh nagios@$1 "sudo date -d '-30 min' +%M")
chour=$(sshpass -p 12shroot ssh nagios@$1 "sudo date -d '-30 min' +%H")

if [[ $cmin -ge 0 && $cmin -lt 15 ]];then
        cmin=00
fi

if [[ $cmin -ge 15 && $cmin -lt 30 ]];then
        cmin=15
fi

if [[ $cmin -ge 30 && $cmin -lt 45 ]];then
        cmin=30
fi

if [[ $cmin -ge 45 && $cmin -lt 59 ]];then
        cmin=45
fi

if [[ $cmin -eq 59 ]];then
        cmin=45
fi


#echo $cyear-$cmonth-$cday" "$chour:$cmin



enm_login=$(sshpass -p 12shroot ssh nagios@$1 "sudo curl -k --request POST \"https://$http_url/login\" -d IDToken1=\"administrator\" -d IDToken2=\"TestPassw0rd\" --cookie-jar cookie.txt")

for n in $netypes;do

	pm_files_query=$(sshpass -p 12shroot ssh nagios@$1 "sudo curl -w \"%{http_code}\" -G -s --insecure --request GET --cookie cookie.txt \"https://$http_url/file/v1/files?filter=dataType==PM_STATISTICAL;nodeType==$n;startRopTimeInOss==${cyear}-${cmonth}-${cday}T${chour}:${cmin}:00\"")

	no_pm_files=$(echo $pm_files_query | grep -o 'fileLocation' | wc -l)

#	echo "NUMBER OF PM FILES: $no_pm_files" $n

	if [[ $no_pm_files -eq 10000 ]];then

		last_id=$(echo $pm_files_query | grep -o -P '"id".{0,10}' | awk -F ":" '{print $2}' | tail -1)
		no_pm_files_extended=$(sshpass -p 12shroot ssh nagios@$1 "sudo curl -w \"%{http_code}\" -G -s --insecure --request GET --cookie cookie.txt \"https://$http_url/file/v1/files?filter=dataType==PM_STATISTICAL;nodeType==$n;startRopTimeInOss==${cyear}-${cmonth}-${cday}T${chour}:${cmin}:00;id=gt=$last_id\" | grep -o 'fileLocation' | wc -l")

#		echo "NUMBER OF PM FILES IS HIGHER THAN 10000 THE LAST ID IS: $last_id"
#		echo "NUMBER OF PM FILES IN THE EXTENDED QUERY: $no_pm_files_extended"	

		no_pm_files=$(($no_pm_files + $no_pm_files_extended))
#		echo "NUMBER OF PM FILES + EXTENDED: $no_pm_files" $n
	fi
	tot_no_pm_files=$(($tot_no_pm_files + $no_pm_files))
done


#echo "TOTAL NUMBER OF PM FILES: $tot_no_pm_files"

if [[ ("$tot_no_pm_files" -lt "$warning_value") && ("$tot_no_pm_files" -gt "$critical_value") ]];then
        echo "WARNING- NUMBER OF PM FILES ($tot_no_pm_files) IS BETWEEN 80% AND 95% OF NODES WITH PM SUPERVISION ENABLED ($tot_number_nodes_pmsuperv*$number_pm_files_by_node=$tot_expected_pm_files)"
        exit 1
fi

if [[ "$tot_no_pm_files" -lt "$critical_value" ]];then
        echo "CRITICAL- NUMBER OF PM FILES ($tot_no_pm_files) IS LOWER THAN 80% OF NODES WITH PM SUPERVISION ENABLED ($tot_number_nodes_pmsuperv*$number_pm_files_by_node=$tot_expected_pm_files)"
        exit 2
fi

if [[ "$tot_no_pm_files" -eq "tot_number_nodes_pmsuperv" ]];then
        echo "OK- NUMBER OF PM FILES ($tot_no_pm_files) IS EQUAL TO NUMBER OF NODES WITH PM SUPERVISION ENABLED ($tot_number_nodes_pmsuperv*$number_pm_files_by_node=$tot_expected_pm_files)"
        exit 0
fi

echo "OK- NUMBER OF PM FILES ($tot_no_pm_files) IS HIGHER THAN 95% OF NODES WITH PM SUPERVISION ENABLED (NO. OF EXPECTED FILES: $tot_expected_pm_files)"
exit 0


