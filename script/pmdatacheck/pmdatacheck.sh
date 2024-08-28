#!/bin/bash

SQL_FILE_15MIN="/tmp/pmic15.sql"


get_rop_time() {
  local rop_hour
  local rop_minute
  local rop_date
  local rop_time
  local h1
  local m1

  rop_hour=$(date +%H)
  rop_minute=$(date +%M)
  rop_date=$(date "+%Y-%m-%d")

  if [ ${rop_minute} -ge 0 -a ${rop_minute} -lt 15 ];then
    h1=$(expr ${rop_hour} - 1)
    m1=30
    if [ $h1 -lt 10 ];then
      h1=0${h1}
    fi
  elif [ ${rop_minute} -ge 15 -a ${rop_minute} -lt 30 ];then
    h1=$(expr ${rop_hour} - 1)
    if [ $h1 -lt 10 ];then
      h1=0${h1}
    fi
    m1=45
  elif [ ${rop_minute} -ge 30 -a ${rop_minute} -lt 45 ];then
    h1=${rop_hour}
    m1=00
  elif [ ${rop_minute} -ge 45 ];then
    h1=${rop_hour}
    m1=15
  fi
  rop_time="${h1}:${m1}:00"
  echo -e "${rop_date}.${rop_time}"
}

create_pm_support_file() {

  /opt/ericsson/enmutils/bin/cli_app 'cmedit get * enodebfunction -ne=RadioNode -cn'|sed -n '1p' > /tmp/sub_query2.txt
  /opt/ericsson/enmutils/bin/cli_app 'cmedit get * GNBDUFunction -ne=RadioNode -cn'|sed -n '1p' >> /tmp/sub_query2.txt
  /opt/ericsson/enmutils/bin/cli_app 'cmedit get * GNBCUUPFunction -ne=RadioNode -cn'|sed -n '1p' >> /tmp/sub_query2.txt
  /opt/ericsson/enmutils/bin/cli_app 'cmedit get * GNBCUCPFunction -ne=RadioNode -cn'|sed -n '1p' >> /tmp/sub_query2.txt

}


count_nodes_pm_enabled() {

  local nodes_w_pm_enabled
  local netype
  netype=$1

  nodes_w_pm_enabled=$(/opt/ericsson/enmutils/bin/cli_app "cmedit get * pmfunction.pmEnabled==true -ne=$netype -cn" | tail -1 | awk '{print $1}')
  
  echo $nodes_w_pm_enabled
}

get_netypes_w_pm_enabled() {
  
  local netypes_w_pm_enabled

  netypes_w_pm_enabled=$(/opt/ericsson/enmutils/bin/cli_app "cmedit get * networkelement.netype,pmFunction.pmEnabled==true"| grep neType | sort -u | awk '{print $3}')

  echo $netypes_w_pm_enabled

}

create_sql_15min() {

  local netypes_w_pm_enabled
  local netype
  local rop_date
  local rop_time
  local nodes_w_pm_enabled
  netypes_w_pm_enabled=$1
  rop_date=$2
  rop_time=$3

  echo "select node_type,start_roptime_in_oss,data_type as fileType,case" > $SQL_FILE_15MIN
  for netype in $netypes_w_pm_enabled;do 
    nodes_w_pm_enabled=$(count_nodes_pm_enabled $netype)
    if [[ "$nodes_w_pm_enabled" != *"Error"* ]];then
      echo -n " when node_type like '$netype' then '$nodes_w_pm_enabled' " >> $SQL_FILE_15MIN
    fi  
  done
  echo "end total_nodes,count(*) as Actual,round(avg(file_size/1024),2) as file_size from pm_rop_info where start_roptime_in_oss='${rop_date} ${rop_time}' and data_type not in ('PM_STATISTICAL_1MIN','PM_EBM') group by node_type,start_roptime_in_oss,data_type order by node_type,start_roptime_in_oss,data_type;" >> $SQL_FILE_15MIN
}

create_sql_24hours() {

#echo "select substring(a.rop from 1 for 29) as ROP,a.node_type,a.fcd,a.start_roptime_in_oss,a.end_roptime_in_oss,count(*),round(avg(a.kb),2) as file_size from (select split_part(file_location, '/', 6) as rop,node_type,to_char(file_creationtime_in_oss, 'yyyy-mm-dd') as fcd,start_roptime_in_oss,end_roptime_in_oss,file_size/1024 as kb from pm_rop_info where data_type='PM_STATISTICAL' and extract(epoch from (end_roptime_in_oss - start_roptime_in_oss))>=86400) a group by substring(a.rop from 1 for 29),a.node_type,a.fcd,a.start_roptime_in_oss,a.end_roptime_in_oss order by substring(a.rop from 1 for 29),a.fcd,a.node_type;" > /tmp/pmic24.sql

echo "select substring(a.rop from 1 for 29) as ROP,a.node_type,a.fcd,a.start_roptime_in_oss,a.end_roptime_in_oss,total_nodes,count(*),round(avg(a.kb),2) as file_size from (select split_part(file_location, '/', 6) as rop,node_type,to_char(file_creationtime_in_oss, 'yyyy-mm-dd') as fcd,start_roptime_in_oss,end_roptime_in_oss,file_size/1024 as kb from pm_rop_info where data_type='PM_STATISTICAL' and extract(epoch from (end_roptime_in_oss - start_roptime_in_oss))>=86400) a group by substring(a.rop from 1 for 29),a.node_type,a.fcd,a.start_roptime_in_oss,a.end_roptime_in_oss order by substring(a.rop from 1 for 29),a.fcd,a.node_type;" > /tmp/pmic24.sql


}



execute_psql_query(){

  env | grep LMS_HOST > /dev/null
  if [ $? -eq 0 ];then
    LMS_H=$(env | grep LMS_HOST | cut -d"=" -f2)
    ser=$(ssh -q -t -o StrictHostKeyChecking=no ${LMS_H} "grep postgres /etc/hosts" | awk '{print $1}')
    #rm -f /tmp/pmic_out15
    scp -q -o StrictHostKeyChecking=no $SQL_FILE_15MIN root@${LMS_H}:/tmp/
    ssh -q -t -o StrictHostKeyChecking=no ${LMS_H} "PGPASSWORD=P0stgreSQL11 /usr/bin/psql -h ${ser} -U postgres -d flsdb -f $SQL_FILE_15MIN -o /tmp/pmic_out15 -q"
    scp -q -o StrictHostKeyChecking=no root@${LMS_H}:/tmp/pmic_out15 /tmp/pmic_out15
  fi
}

execute_psql_query_24(){
  
  env | grep LMS_HOST > /dev/null
  if [ $? -eq 0 ];then
    LMS_H=$(env | grep LMS_HOST | cut -d"=" -f2)
    ser=$(ssh -q -t -o StrictHostKeyChecking=no ${LMS_H} "grep postgres /etc/hosts" | awk '{print $1}')
    #rm -f /tmp/pmic_out15
    scp -q -o StrictHostKeyChecking=no /tmp/pmic24.sql root@${LMS_H}:/tmp/
    ssh -q -t -o StrictHostKeyChecking=no ${LMS_H} "PGPASSWORD=P0stgreSQL11 /usr/bin/psql -h ${ser} -U postgres -d flsdb -f /tmp/pmic24.sql -o /tmp/pmic_out24 -q"
    scp -q -o StrictHostKeyChecking=no root@${LMS_H}:/tmp/pmic_out24 /tmp/pmic_out24
  fi
}

write_exp_and_status() {
  local myLine
  local ff1
  local pm_status
  myLine=$1
  ff1=$2
  pm_status=$3

  echo -n " ${myLine} |" #>> /tmp/pmic_out15_report
  /usr/bin/printf "%8s | %6s \n" ${ff1} ${pm_status} #>> /tmp/pmic_out15_report

}

ok_status_chk() {
  local pm_files_found
  local pm_files_expected
  local pm_status

  pm_files_found=$2
  pm_files_expected=$1
  if [ $pm_files_found -eq $pm_files_expected ];then
    pm_status="OK"
  else
    pm_status="NOK"
  fi
  echo $pm_status

}

expected_files_count_24(){

  echo "`head -1 /tmp/pmic_out24`| EXPECTED | STATUS"
  tail -n +3 /tmp/pmic_out24 > /tmp/pmic_out241
  while read myLine;do
    pm24_node_type=`echo "$myLine"|awk -F"|" '{print $2}'|sed 's/ //g'`
    pm24_file_count=`echo "$myLine"|awk -F"|" '{print $6}'|sed 's/ //g'`


  done
}



expected_files_count(){
  echo "`head -1 /tmp/pmic_out15`| EXPECTED | STATUS" 
  echo "----------------------------------------------------------------------------------------------------------------"
  grep PM_ /tmp/pmic_out15|tr -d $'\r' > /tmp/pmic_out151

  while read myLine; do
    ff=`echo "$myLine"|awk -F"|" '{print $1":"$3}'|sed 's/ //g'`
    ff1=`echo "$myLine"|awk -F"|" '{print $4}'|sed 's/ //g'|tr -d $'\r'`
    ff4=`echo "$myLine"|awk -F"|" '{print $5}'|sed 's/ //g'|tr -d $'\r'`
    case "x${ff}x" in
    "xCCDM:PM_STATISTICALx"|"xCISCO-ASR900:PM_STATISTICALx"|"xDSC:PM_STATISTICALx"|"xERBS:PM_STATISTICALx"|"xESC:PM_STATISTICAL"|"xFRONTHAUL-6080:PM_STATISTICALx"|"xMGW:PM_STATISTICALx"|"xMINI-LINK-6352:PM_STATISTICALx"|"xRadioNode:PM_STATISTICALx"|"xRBS:PM_STATISTICALx"|"xRNC:PM_STATISTICALx"|"xSGSN-MME:PM_STATISTICALx"|"xMSC-DB-BSP:PM_STATISTICALx"|"xMTAS:PM_STATISTICALx"|"xRouter6274:PM_STATISTICALx"|"xRouter6672:PM_STATISTICALx"|"vWMG-OI:PM_STATISTICALx"|"xWMG-OI:PM_STATISTICALx")

       pm_status=$(ok_status_chk ${ff4} ${ff1})        
#	    pm_status="OK"
#       echo "FF1: ${ff1}  FF4: ${ff4}   PM_STATUS: $pm_status"
#       sts_=`ok_status_chk ${ff4} ${ff1}`
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xBSC:PM_STATISTICALx"|"xMINI-LINK-Indoor:PM_STATISTICALx"|"xMINI-LINK-669x:PM_STATISTICALx")
       ff1=`expr ${ff1} \* 4`
       pm_status=$(ok_status_chk ${ff4} ${ff1})
#       pm_status="OK"
#       sts_=`ok_status_chk ${ff4} ${ff1}`
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xBSC:PM_BSC_BARx"|"xBSC:PM_BSC_CERx"|"xBSC:PM_BSC_CTRx"|"xBSC:PM_BSC_MRRx"|"xBSC:PM_BSC_RIRx"|"xBSC:PM_MTRx")
#       pm_status="OK"
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xBSC:PM_BSC_PERFORMANCE_EVENTx")
       ff1="TBD"
       pm_status="TO BE DEFINED"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xBSC:PM_BSC_RTTx")
       ff1="TBD"
       pm_status="TO BE DEFINED"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xBSC:PM_MTRx")
       ff1="TBD"
       pm_status="TO BE DEFINED"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xEPG:PM_STATISTICALx")
       ff1=`expr ${ff1} \* 3`
       pm_status=$(ok_status_chk ${ff4} ${ff1})
 #      pm_status="OK"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xSBG-IS:PM_STATISTICALx")
       ff1=`expr ${ff1} \* 300`
 #      pm_status="OK"
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xERBS:PM_CELLTRACEx"|"xRBS:PM_GPEHx")
       ff1=`expr ${ff1} \* 2`
       #pm_status="OK"
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xRadioNode:PM_CELLTRACEx")
       ff1=`grep -i enodebfunction /tmp/sub_query2.txt|awk '{print $2}'`
       ff1=`expr ${ff1} \* 2`
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       #pm_status="OK"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xRadioNode:PM_EBSLx")
       ff1=`grep -i enodebfunction /tmp/sub_query2.txt|awk '{print $2}'`
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       #pm_status="OK"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xRadioNode:PM_CELLTRACE_DUx")
       ff1=`grep -i GNBDUFunction /tmp/sub_query2.txt|awk '{print $2}'`
       ff1=`expr ${ff1} \* 2`
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       #pm_status="OK"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xRadioNode:PM_CELLTRACE_CUUPx")
       ff1=`grep -i GNBCUUPFunction /tmp/sub_query2.txt|awk '{print $2}'`
       ff1=`expr ${ff1} \* 2`
       #pm_status="OK"
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xRadioNode:PM_CELLTRACE_CUCPx")
       ff1=`grep -i GNBCUCPFunction /tmp/sub_query2.txt|awk '{print $2}'`
       ff1=`expr ${ff1} \* 2`
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       #pm_status="OK"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xRadioNode:PM_EBSN_CUCPx"|"xRadioNode:PM_EBSN_DUx"|"xRadioNode:PM_EBSN_CUUPx")
       ff1=`grep -i networkelement /tmp/sub_query2.txt|awk '{print $2}'`
       #pm_status="OK"
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xERBS:PM_UETRACEx")
       ff1=180
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       #pm_status="OK"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xMSC-BC-BSP:PM_STATISTICALx"|"xMSC-BC-IS:PM_STATISTICALx")
       ff1=`expr ${ff1} \* 6`
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       #pm_status="OK"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xRadioNode:PM_UETRACEx")
       ff1=320
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       #pm_status="OK"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xRNC:PM_UETRx")
       ff1=`expr ${ff1} \* 16`
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       #pm_status="OK"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    "xRNC:PM_GPEHx")
       ff1=`grep num_MP /tmp/sub_query2.txt |cut -d= -f2`
       pm_status=$(ok_status_chk ${ff4} ${ff1})
       #pm_status="OK"
       write_exp_and_status "${myLine}" "${ff1}" "$pm_status"
       ;;
    *)
       echo -n " ${myLine} | ${ff1}" >> /tmp/pmic_out15_report
       ;;

   esac
done < /tmp/pmic_out151
echo
}


#set -x

#if [[ "$nodes_w_pm_enabled" == *"Error"* ]];then

rop_time=$(get_rop_time)

echo "SELECTED ROP TIME: $rop_time"

echo "GETTING NETYPES WITH PM SUPERVISION ENABLED ...."
netypes_w_pm_enabled=$(get_netypes_w_pm_enabled)

#echo "NE TYPES WITH PM ENABLED: $netypes_w_pm_enabled"

rop_date=$(echo $rop_time | awk -F "." '{print $1}')
rop_time=$(echo $rop_time | awk -F "." '{print $2}')

create_sql_15min "$netypes_w_pm_enabled" $rop_date $rop_time 

#cat $SQL_FILE_15MIN

echo "EXECUTING PSQL QUERY TO RETRIEVE 15MIN PM INFO FROM FLS DATABASE ..."

execute_psql_query

#cat /tmp/pmic_out15

create_pm_support_file

#cat /tmp/sub_query2.txt

echo "GENERATING PM REPORT OF EXPECTED FILES ..."

expected_files_count

#cat /tmp/pmic_out15_report

echo "EXECUTING PSQL QUERY TO RETRIEVE 24HOURS PM INFO FROM FLS DATABASE ..."

execute_psql_query_24

cat /tmp/pmic_out24
