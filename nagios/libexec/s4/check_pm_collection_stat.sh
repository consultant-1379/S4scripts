#!/bin/bash

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1
wkl_vm_ip=$2
netype=$3
http_url=$4
number_pm_files_by_node=$5

tot_number_nodes_pmsuperv=0


cluster_id=$(get_deployment_id_from_ms_ip $lms_ip)

config_file="${cluster_id}_configuration.sh"

source /usr/local/nagios/libexec/s4/$config_file

number_nodes_pmsuperv=$(count_number_nodes_pmsuperv $lms_ip $wkl_vm_ip $netype)

if [ "$number_nodes_pmsuperv" -eq "0" ]; then
   echo "WARNING- THERE ARE NO NODES $netype WITH PM SUPERVISION ENABLED";
   exit 1;
fi

tot_number_nodes_pmsuperv=$((tot_number_nodes_pmsuperv + number_nodes_pmsuperv))
eval "number_nodes_${n}"=$number_nodes_pmsuperv

tot_expected_pm_files=`echo "$tot_number_nodes_pmsuperv * $number_pm_files_by_node" | bc -l`

warning_value_float=`echo "$tot_number_nodes_pmsuperv * 0.95 * $number_pm_files_by_node" | bc -l`
warning_value=${warning_value_float%.*}

critical_value_float=`echo "$tot_number_nodes_pmsuperv * 0.8 * $number_pm_files_by_node" | bc -l`
critical_value=${critical_value_float%.*}

cyear=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo date -d '-30 min' +%Y")
cmonth=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo date -d '-30 min' +%m")
cday=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo date -d '-30 min' +%d")
cmin=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo date -d '-30 min' +%M")
chour=$(sshpass -p 12shroot ssh -q nagios@$1 "sudo date -d '-30 min' +%H")

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


enm_login=$(sshpass -p 12shroot ssh -q nagios@$lms_ip "sudo curl -k --request POST \"https://$http_url/login\" -d IDToken1=\"$enm_gui_user\" -d IDToken2=\"$enm_gui_password\" --cookie-jar cookie.txt")

if [[ "$enm_login" == *FAILED* ]]; then
  echo "CRITICAL- CANNOT LOGIN TO ENM (CHECK PASSWORD OF ADMINISTRATOR USER) !"
  exit 2
fi

pm_files_query=$(sshpass -p 12shroot ssh -q nagios@$lms_ip "sudo curl -w \"%{http_code}\" -G -s --insecure --request GET --cookie cookie.txt \"https://$http_url/file/v1/files?filter=dataType==PM_STATISTICAL;nodeType==$netype;startRopTimeInOss==${cyear}-${cmonth}-${cday}T${chour}:${cmin}:00\"")

no_pm_files=$(echo $pm_files_query | grep -o 'fileLocation' | wc -l)
last_id=$(echo $pm_files_query | grep -o -P '"id".{0,10}' | awk -F ":" '{print $2}' | tail -1 | sed 's/,//g')
#echo "No of pm files: $no_pm_files"
#echo "Last Id: $last_id"

# | rev | cut -c 1- | rev)


#echo "NUMBER OF PM FILES: $no_pm_files"
#echo "LAST ID: $last_id"

#    no_pm_files_extended=$(sshpass -p 12shroot ssh nagios@$lms_ip "sudo curl -w \"%{http_code}\" -G -s --insecure --request GET --cookie cookie.txt \"https://$http_url/file/v1/files?filter=dataType==PM_STATISTICAL;nodeType==$netype;startRopTimeInOss==${cyear}-${cmonth}-${cday}T${chour}:${cmin}:00;id=gt=$last_id\" | grep -o 'fileLocation' | wc -l")
#    echo "NUMBER OF PM FILES EXTENDED: $no_pm_files_extended"
#    exit




tot_no_pm_files_extended=0

if [[ $no_pm_files -eq 10000 ]];then
  while :;do
    
#    echo "Query for extended files"
    pm_files_query_extended=$(sshpass -p 12shroot ssh -q nagios@$lms_ip "sudo curl -w \"%{http_code}\" -G -s --insecure --request GET --cookie cookie.txt \"https://$http_url/file/v1/files?filter=dataType==PM_STATISTICAL;nodeType==$netype;startRopTimeInOss==${cyear}-${cmonth}-${cday}T${chour}:${cmin}:00;id=gt=$last_id\"")
    no_pm_files_extended=$(echo $pm_files_query_extended | grep -o 'fileLocation' | wc -l)
    last_id=$(echo $pm_files_query_extended | grep -o -P '"id".{0,10}' | awk -F ":" '{print $2}' | tail -1 | sed 's/,//g')
#    echo "NUMBER OF PM FILES EXTENDED: $no_pm_files_extended"
#    echo "Last Id: $last_id"
    tot_no_pm_files_extended=$(($tot_no_pm_files_extended + $no_pm_files_extended))

    if [[ $no_pm_files_extended -lt 10000 ]];then
#		echo "NUMBER OF PM FILES IS HIGHER THAN 10000 THE LAST ID IS: $last_id"
#		echo "NUMBER OF PM FILES IN THE EXTENDED QUERY: $no_pm_files_extended"	
#      echo "Number of files lower than 10000"
      break
    fi
        
  done
fi
tot_no_pm_files=$(($no_pm_files + $tot_no_pm_files_extended))

if [[ ("$tot_no_pm_files" -lt "$warning_value") && ("$tot_no_pm_files" -gt "$critical_value") ]];then
        echo "WARNING- NUMBER OF PM FILES ($tot_no_pm_files) IS BETWEEN 80% AND 95% OF NODES WITH PM SUPERVISION ENABLED ($tot_number_nodes_pmsuperv*$number_pm_files_by_node=$tot_expected_pm_files)"
        exit 1
fi

if [[ "$tot_no_pm_files" -lt "$critical_value" ]];then
        echo "CRITICAL- NUMBER OF PM FILES ($tot_no_pm_files) IS LOWER THAN 80% OF NODES WITH PM SUPERVISION ENABLED ($tot_number_nodes_pmsuperv*$number_pm_files_by_node=$tot_expected_pm_files)"
        exit 2
fi

if [[ "$tot_no_pm_files" -eq "$tot_expected_pm_files" ]];then
        echo "OK- ALL PM FILES ARE COLLECTED ($tot_number_nodes_pmsuperv*$number_pm_files_by_node=$tot_expected_pm_files)!"
        exit 0
fi

echo "WARNING- NUMBER OF PM FILES ($tot_no_pm_files) IS HIGHER THAN 95% OF NODES WITH PM SUPERVISION ENABLED ($tot_number_nodes_pmsuperv*$number_pm_files_by_node=$tot_expected_pm_files)"
exit 1
