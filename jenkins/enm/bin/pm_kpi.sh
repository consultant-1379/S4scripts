#!/bin/bash
###############################################################
## Scrtipt: PMIC Data statistics Querying on pmserv VM       ##
## Author : rajesh.chiluveru@ericsson.com                    ##
## Last Modified: 20-Nov-2017                                ##
###############################################################

mkdir -p /tmp/erahchu_scripts/

#Cid=`grep -ri san_siteId /software/autoDeploy/*site*|head -1 | awk -F '=ENM' '{print $2}'`
a=`date "+%d%m%y"`
Check_date=`expr $a - 10000`
cnt=`echo ${Check_date}|wc -c`
if [ ${cnt} -lt 7 ]
then
Check_date=0${Check_date}
fi

mount $2:/data/stats /net/$2/data/stats

zgrep fifteenMinuteRopFileCollectionCycleInstru /net/$2/data/stats/tor/$1/analysis/${Check_date}/enmlogs/*.csv.gz > /tmp/erahchu_scripts/pm_kpi.txt
#zgrep fifteenMinuteRopFileCollectionCycleInstru /mnt_ddpenm2_latest/tor/LMI_ENM${Cid}/analysis/${Check_date}/enmlogs/*.csv.gz > /tmp/erahchu_scripts/pm_kpi.txt

while read line
do
u1=`echo "$line"|sed -n 's/.*,ropStartTimeIdentifier=\([[:digit:]]*\+\),.*/\1/p'|cut -c1-10`
u2=`echo "$line"|sed -n 's/.*,ropStartTime=\([[:digit:]]*\+\),.*/\1/p'`
u3=`echo "$line"|sed -n 's/.*,ropEndTime=\([[:digit:]]*\+\)]/\1/p'`
n1=`echo "$line"|sed -n 's/.*,numberOfFilesCollected=\([[:digit:]]*\+\),.*/\1/p'`
n2=`echo "$line"|sed -n 's/.*,numberOfFilesFailed=\([[:digit:]]*\+\),.*/\1/p'`
U1=`date -d @${u1} "+%Y-%m-%d %H:%M"`
U2=`expr ${u3} - ${u2}`
U3=`echo "${U2}/1000"|bc`

echo -e "ROP_START_TIME: ${U1}  Files_collected: ${n1}  Files_Failed: ${n2}     STKPI: ${U3}" >> /ericsson/enm/dumps/erahchu_dump_pm_kpi.txt

done < /tmp/erahchu_scripts/pm_kpi.txt