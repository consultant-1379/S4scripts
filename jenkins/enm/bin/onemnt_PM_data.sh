#!/bin/bash
###############################################################
## Scrtipt: PMIC Data statistics for one mnt ROP             ##
## Author : rajesh.chiluveru@ericsson.com                    ##
###############################################################

if [ $# -ne 1 ]
then
echo -e "\e[0;35m SYNTAX error \e[0m"
echo "Use like ./onemnt_data.sh <ROP TIME HH:MM>"
echo "Eg: ./onemnt_data.sh 1045"
exit
fi

DATE=`date +%Y%m%d`
TIME=$1
CLUSTER=`grep -ri san_siteId /software/autoDeploy/*site*|head -1 | awk -F '=ENM' '{print $2}'`
nas_vip_enm_1=`grep -ri nas_vip_enm_1 /software/autoDeploy/*site*|head -1 | awk -F '=' '{print $2}'`
nas_vip_enm_2=`grep -ri nas_vip_enm_2 /software/autoDeploy/*site*|head -1 | awk -F '=' '{print $2}'`
mkdir -p /ericsson/pmic1
mkdir -p /ericsson/pmic2
mount ${nas_vip_enm_1}:/vx/ENM${CLUSTER}-pm1 /ericsson/pmic1
mount ${nas_vip_enm_2}:/vx/ENM${CLUSTER}-pm2 /ericsson/pmic2

rm -f /ericsson/enm/dumps/rop_onemnt_*.txt

T1=`echo ${TIME}|cut -c1-2`
T2=`echo ${TIME}|cut -c3-4`
if [ "$T2" == "00" ]
then
T3=`expr $T2 + 14`
   for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14
   do
   find /ericsson/pmic*/ebm/data/* -name [AB]${DATE}.${T1}${i}*|xargs ls -ltr >> /ericsson/enm/dumps/rop_onemnt_${DATE}_${TIME}_file_list.txt
   done
else
T3=`expr $T2 + 14`
   for ((j=$T2;j<=$T3;j++))
   do
   find /ericsson/pmic*/ebm/data/ -name [AB]${DATE}.${T1}${j}* |xargs ls -ltr >> /ericsson/enm/dumps/rop_onemnt_${DATE}_${TIME}_file_list.txt
   done
fi
umount /ericsson/pmic1
umount /ericsson/pmic2
rmdir /ericsson/pmic1
rmdir /ericsson/pmic2

echo " ============== SGSN EBM Data statistics =========== "
echo
NUM_SGSNMME=`cli_app 'cmedit get * NetworkElement -netype=SGSN-MME -cn' | tail -1 | awk '{print $1}'`
echo -e "\e[0;32m Total SGSN-MME nodes in This server \e[0m       : ${NUM_SGSNMME} "
tf=`echo "${NUM_SGSNMME}*4*15"|bc`
echo -e "\e[0;32m Total No.of EBM Files supposed to collect \e[0m : $tf ( ${NUM_SGSNMME}nodes * 4FilesPerNode * 15FilesPerRop ) "
echo
echo -e "\e[0;32m Total EBM files Collecting \e[0m : `grep -i ebm /ericsson/enm/dumps/rop_onemnt_${DATE}_${TIME}_file_list.txt|wc -l` / $tf "
echo -e "\e[0;32m Total EBSM files Collecting\e[0m : `grep -i ebsm /ericsson/enm/dumps/rop_onemnt_${DATE}_${TIME}_file_list.txt|wc -l`"
echo
cli_app 'cmedit get * networkelement.neType==SGSN-MME'|grep FDN|cut -d"=" -f2|sort -u > /ericsson/enm/dumps/all_sgsn1.txt
if [ -f /ericsson/enm/dumps/rop_onemnt_${DATE}_${TIME}_file_list.txt ]
then
j=`cat /ericsson/enm/dumps/rop_onemnt_${DATE}_${TIME}_file_list.txt|awk '{ sum += $5/1024 } END { print (sum/1024) }'`
j1=`echo "scale=2;${j}/1024"|bc`
echo -e "\e[0;33m SGSN_EBM data for ROP from ${T1}${T2} TO ${T1}${T3} \e[0m ==> ${j1} GB "
else
echo -e "\e[0;33m SGSN_EBM data for ROP from ${T1}${T2} TO ${T1}${T3} \e[0m  ==> 0 GB "
echo -e "\e[0;32mThere are NO EBM files collected in ROP ${TIME}.Please troubleshoot "
echo
fi
echo
#echo "**** List of Nodes Failed to Collect ROP ${TIME} Files *********"
cat /ericsson/enm/dumps/rop_onemnt_${DATE}_${TIME}_file_list.txt|awk -F"/" '{print $6}'|cut -d"=" -f3|sort -u > /ericsson/enm/dumps/data_sgsn1.txt
a1_1=`comm -23 /ericsson/enm/dumps/all_sgsn1.txt /ericsson/enm/dumps/data_sgsn1.txt|wc -l`
if [ $a1_1 -ne 0 ]
then
echo "**** There is/are ${a1_1} sgsn Node Failed To collect PMIC files in given ROP ${TIME} ****"
if [ $a1_1 -le 20 ]
then
echo "**** Below are Failed To COllect sgsn Nodes . PLZ troubleshoot **** "
comm -23 /ericsson/enm/dumps/all_sgsn1.txt /ericsson/enm/dumps/data_sgsn1.txt
echo
else
comm -23 /ericsson/enm/dumps/all_sgsn1.txt /ericsson/enm/dumps/data_sgsn1.txt > /ericsson/enm/dumps/sgsn_EBM_Failed.txt
echo "**** CHECK failed to collect sgsn nodes in file /ericsson/enm/dumps/sgsn_EBM_Failed.txt"
echo
fi
fi
