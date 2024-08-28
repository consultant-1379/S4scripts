#!/bin/bash

sshvm='/root/rvb/bin/ssh_to_vm_and_su_root.exp'

# Create file on SFS to be sourced on the VM in order to grab the logs
WORKING_DIR_ENM=/ericsson/enm/dumps/PM_LOGS$(date +%Y-%m-%d-%H:%M:%S)/

PM_SG_LABELS="pmserv mspm mspmip"
#PM_SG_LABELS="pmserv"

get_pm_sgs(){
  for PM_SG_LABEL in $PM_SG_LABELS;do
    pm_sgs=$(grep -w $PM_SG_LABEL /etc/hosts | awk '{print $2}' | sort | uniq)
    pm_sgs_list="$pm_sgs_list $pm_sgs"
  done
  echo $pm_sgs_list
}

grab_jboss_logs(){

# ssh to each VM in SVC_LIST and grab the Jboss logs
for pm_sg_list in $pm_sgs_list;do
  $sshvm $pm_sg_list "cp /ericsson/3pp/jboss/standalone/log/server.log $WORKING_DIR_ENM$pm_sg_list-server.log"
  if [ $? -ne 0 ];then echo "Problem connecting to $pm_sg_list with ssh...exiting";exit 0;fi
  echo "Logs stored at: $WORKING_DIR_ENM"
done;

}



get_pm_sgs

mkdir -p $WORKING_DIR_ENM

grab_jboss_logs


start_rop_year=$(date -d '-30 min' +%Y)
start_rop_month=$(date -d '-30 min' +%m)
start_rop_day=$(date -d '-30 min' +%d)
start_rop_min=$(date -d '-30 min' +%M)
start_rop_hour=$(date -d '-30 min' +%H)

if [[ $start_rop_min -ge 0 && $start_rop_min -lt 15 ]];then
  start_rop_min=00
fi

if [[ $start_rop_min -ge 15 && $start_rop_min -lt 30 ]];then
  start_rop_min=15
fi

if [[ $start_rop_min -ge 30 && $start_rop_min -lt 45 ]];then
  start_rop_min=30
fi

if [[ $start_rop_min -ge 45 && $start_rop_min -lt 59 ]];then
  start_rop_min=45
fi

if [[ $start_rop_min -eq 59 ]];then
  start_rop_min=45
fi

start_rop_date="${start_rop_year}-${start_rop_month}-${start_rop_day} ${start_rop_hour}:${start_rop_min}"

echo "START ROP DATE: $start_rop_date"

end_rop=$(date -d "$start_rop_date 15 minutes" +"%Y-%m-%d %H:%M")
end_rop_date=$(echo $end_rop | awk '{print $1}')
end_rop_time=$(echo $end_rop | awk '{print $2}')
end_rop_year=$(echo $end_rop_date | awk -F'-' '{print $1}')
end_rop_month=$(echo $end_rop_date | awk -F'-' '{print $2}')
end_rop_day=$(echo $end_rop_date | awk -F'-' '{print $3}')
end_rop_hour=$(echo $end_rop_time | awk -F':' '{print $1}')
end_rop_min=$(echo $end_rop_time | awk -F':' '{print $2}')


echo "END ROP DATE: $end_rop"

search_rop_str="${start_rop_year}${start_rop_month}${start_rop_day}.${start_rop_hour}${start_rop_min}+0100-${end_rop_hour}${end_rop_min}"

#20220529.1000+0100-1015+0100

grep ERROR $WORKING_DIR_ENM*pmserv*.log | grep $search_rop_str | grep LTE109dg2ERBS00043

grep LTE109dg2ERBS00043 $WORKING_DIR_ENM*mspm*.log


#grep LTE109dg2ERBS00043 ${WORKING_DIR_ENM}pmserv-server-log.error


#cat ${WORKING_DIR_ENM}pmserv-server-log.error

