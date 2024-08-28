#!/bin/bash
###############################################################
## Scrtipt: PMIC Data statistics Querying on FLSDB           ##
## Author : rajesh.chiluveru@ericsson.com                    ##
## Last Modified: 21-Aug-2019                                ##
###############################################################

export PGPASSWORD=P0stgreSQL11
KEYPAIR="/var/tmp/enm_keypair.pem"
CLI_APP="/opt/ericsson/enmutils/bin/cli_app"

dt1=`date "+%Y-%m-%d"`
############################################
### Check PM enabled no.of nodes ###########
############################################
check_noof_nodes(){

if [ ! -f /tmp/sub_query.txt ] || [ "n$1" == "nFF" ]
then
rm -f /tmp/sub_query.txt
        echo -e "\e[0;33m Checking Number of Nodes.. \e[0m Takes 1-2 minutes.."
        nodes_in_system=( `$CLI_APP "cmedit get * networkelement.netype,pmFunction.pmEnabled==true"|grep neType | sort -u | awk '{print $3}'` )
if [ -z $nodes_in_system ]
then
echo " No Nodes with pmFunction ENABLED..Exiting script.."
echo
echo
exit
else
        for TYPE in "${nodes_in_system[@]}"
                do
                TYPE1=`echo ${TYPE}|tr -s "-" "_"`
                n_n=`$CLI_APP "cmedit get * pmfunction.pmEnabled==true -ne=${TYPE} -cn"|grep -i -v error|grep -v NetworkElement|tail -1|awk '{print $1}'`
                        if [ "2$n_n" != "2" ]
                        then
                                if [ "2$n_n" != "20" ]
                                then
                                eval "N_${TYPE1}=`echo $n_n`"
                                echo -n " when node_type like '$TYPE' then '$n_n' " >> /tmp/sub_query.txt
                                echo -e "\e[0;34m ${TYPE}:\e[0m $[N_${TYPE1}]"
                                fi
                        fi
                done
fi
fi
}
######################################
### Verify ROP time argument #########
######################################

roptime_finder(){
if [ $# -eq 0 ] || [ "n$1" == "nFF" ]
then
_hour=`date +%H`
_minute=`date +%M`

        if [ ${_minute} -ge 0 -a ${_minute} -lt 15 ]
        then
                h1=`expr ${_hour} - 1`
                m1=30
                if [ $h1 -lt 10 ]
                then
                h1=0${h1}
                fi
        elif [ ${_minute} -ge 15 -a ${_minute} -lt 30 ]
        then
        h1=`expr ${_hour} - 1`
                if [ $h1 -lt 10 ]
                then
                h1=0${h1}
                fi

        m1=45
        elif [ ${_minute} -ge 30 -a ${_minute} -lt 45 ]
        then
        h1=${_hour}
        m1=00
        elif [ ${_minute} -ge 45 ]
        then
        h1=${_hour}
        m1=15
        fi
rop_time=${h1}:${m1}:00
echo -e "\e[0;32m Latest ROP_TIME :: \e[0m A${dt1}.${h1}:${m1}"
echo
elif [ $# -eq 2 ]
then
dt1=$1
rop_time=$2
else
rop_time=$1
fi
}

##############################
## Verify ENM ISO version ####
##############################
enm_baseline(){
        echo -ne "\e[0;32m Current ENM Baseline/ISO version : \e[0m"
        H_name=`hostname`
	if [ ! -f /etc/enm-version ]
                then
                EMP=`cat ~/.bashrc|grep EMP|cut -d"=" -f2`
                ssh -i ${KEYPAIR} cloud-user@${VNF_LAF} 'consul kv get "enm/deployment/enm_version"'| sed "s/^/\t/g"
                else
                cat /etc/enm-history |tail -1
                fi
echo
               }

#####################################
### Prepare PSQL query to run #######
#####################################
prepare_psql_query(){
echo "select node_type,start_roptime_in_oss,data_type as fileType,count(*) as files_collected,case" > /tmp/pmic.sql
cat /tmp/sub_query.txt >> /tmp/pmic.sql
echo "end total_nodes,round(avg(file_size/1024),2) as avg_compressed_filesize_KB from pm_rop_info where start_roptime_in_oss='${dt1} ${rop_time}' group by node_type,start_roptime_in_oss,data_type order by node_type,start_roptime_in_oss,data_type;" >> /tmp/pmic.sql
echo "select substring(a.rop from 1 for 29) as ROP,a.node_type,a.start_roptime_in_oss,a.end_roptime_in_oss,count(*),round(avg(a.kb),2) as file_size from (select split_part(file_location, '/', 6) as rop,node_type,start_roptime_in_oss,end_roptime_in_oss,file_size/1024 as kb from pm_rop_info where data_type like 'PM_%' and extract(epoch from (end_roptime_in_oss - start_roptime_in_oss))=86400) a group by substring(a.rop from 1 for 29),a.node_type,a.start_roptime_in_oss,a.end_roptime_in_oss order by substring(a.rop from 1 for 29),a.node_type;" > /tmp/pmic24.sql
}

######################################
### Execute PSQL query prepared ######
######################################
execute_psql_query(){
        echo -e "\e[0;33m Executing Query for ROP \e[0m ${dt1} ${rop_time} .... "
        echo "============================================================================================"
H_name=`hostname`
if [ ! -f /etc/enm-version ]
then
EMP=`cat ~/.bashrc|grep EMP|cut -d"=" -f2`
WL=`hostname`
Post_host=`ssh -i ${KEYPAIR} cloud-user@${VNF_LAF} "consul members | egrep 'postgres'"|head -1|awk '{print $1}'`
scp -q -o StrictHostKeyChecking=no -i ${KEYPAIR} /var/tmp/enm_keypair.pem cloud-user@${EMP}:/var/tmp/

ssh -i ${KEYPAIR} cloud-user@${EMP} "rm -f /tmp/pmic*"
scp -q -o StrictHostKeyChecking=no -i ${KEYPAIR} /tmp/pmic*.sql cloud-user@${EMP}:/tmp/

ssh -i ${KEYPAIR} cloud-user@${EMP} "ssh -o StrictHostKeyChecking=no -i ${KEYPAIR} cloud-user@${Post_host} 'sudo rm -f /tmp/pmic*'"
ssh -q -t -i ${KEYPAIR} cloud-user@${EMP} "scp -q -o StrictHostKeyChecking=no -i ${KEYPAIR} /tmp/pmic*.sql cloud-user@${Post_host}:/tmp/"

ssh -i ${KEYPAIR} cloud-user@${EMP} "ssh -o StrictHostKeyChecking=no -i ${KEYPAIR} cloud-user@${Post_host} '/opt/rh/postgresql92/root/usr/bin/psql -h postgres -U postgres -d flsdb -f /tmp/pmic.sql -o /tmp/pmic_out15 -q'"

ssh -i ${KEYPAIR} cloud-user@${EMP} "scp -q -o StrictHostKeyChecking=no -i ${KEYPAIR} cloud-user@${Post_host}:/tmp/pmic_out15 /tmp/"
rm -f /tmp/pmic_out15
scp -q -o StrictHostKeyChecking=no -i ${KEYPAIR} cloud-user@${EMP}:/tmp/pmic_out15 /tmp/

cat /tmp/pmic_out15
echo -e "\e[0;33m Total \e[0m15MIN ROP \e[0;33mPM files collected in ${dt1} ${rop_time}\e[0m :: `awk '{ sum += $8 } END { print sum }' /tmp/pmic_out15` "
echo
echo -e "\e[0;33m Executing Query for \e[0m **24 Hr ROP** "
echo "========================================================="
ssh -i ${KEYPAIR} cloud-user@${EMP} "ssh -o StrictHostKeyChecking=no -i ${KEYPAIR} cloud-user@${Post_host} 'sudo /opt/rh/postgresql92/root/usr/bin/psql -h postgres -U postgres -d flsdb -f /tmp/pmic24.sql -q'"

else
ser=`/opt/ericsson/enminst/bin/vcs.bsh --groups|grep postgres|grep ONLINE|awk '{print $3}'`
rm -f /tmp/pmic_out15
/usr/bin/psql -h ${ser} -U postgres -d flsdb -f /tmp/pmic.sql -o /tmp/pmic_out15 -q
cat /tmp/pmic_out15
echo -e "\e[0;33m Total \e[0m15MIN ROP \e[0;33mPM files collected in ${dt1} ${rop_time}\e[0m :: `awk '{ sum += $8 } END { print sum }' /tmp/pmic_out15` "
echo
echo -e "\e[0;33m Executing Query for \e[0m **24 Hr ROP** "
echo "========================================================="
/usr/bin/psql -h ${ser} -U postgres -d flsdb -f /tmp/pmic24.sql -q
fi
        echo -e "\e[0;33m ********** END of QUERY Execution *********** \e[0m"
}
#######################
## Main       #########
#######################
if [ $# -ge 1 ]
 then
   if [ `echo $1|wc -c` -eq 6 ]
   then
   rop_time=$1
   echo -e "\e[0;32m Checking for ROP_TIME :: \e[0m A${dt1}.${1}"
	echo
      _hourm=`date +%H%M`
      _hourm1=`echo $1|sed 's/://'`
      if [ ${_hourm1} -ge ${_hourm} ]
         then
         echo
         echo " ERROR :: ROP_TIME is MORE than current time .. "
         exit
      fi
   fi
   if [ $# -eq 2 ]
   then
   dt1=$1
   rop_time=$2
   elif [ "n$1" == "nFF" ]
   then
roptime_finder $1
enm_baseline
check_noof_nodes $1
rm -f /tmp/pmic*
prepare_psql_query
execute_psql_query
exit
elif [ `echo $1|wc -c` -ne 6 -o $# -gt 1 ]
   then
   echo
   echo "  Syntax ERROR .. !!! "
   echo -e "\e[0;32m  Script Help - Run script as follows with no parameters OR with ROP_TIME parameter eg:10:15 OR date & ROP combination eg: 2019-08-17 10:15  \e[0m"
   echo -e "\e[0;35mPRE-REQUISITES only for vENM/VIO deployments: \e[0m"| sed "s/^/\t/g"
   echo "1). Ensure .pem key file is on WORKLOAD VM."| sed "s/^/\t/g"
   echo "2). Ensure .pem key file is on EMP VM as /var/tmp/enm_keypair.pem with grp & owner set as cloud-user"| sed "s/^/\t/g"
   echo "3). Ensure VNF_LAF & EMP variables are set in .bashrc on workload vm"| sed "s/^/\t/g"
   echo
   exit 1
   fi
fi

###########################
### Call to functions #####
###########################
roptime_finder $1 $2
enm_baseline
check_noof_nodes
rm -f /tmp/pmic*
prepare_psql_query
execute_psql_query