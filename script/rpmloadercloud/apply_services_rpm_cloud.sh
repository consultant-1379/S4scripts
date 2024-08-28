#!/bin/bash
CLOUD_HOST=$(hostname | awk '{print $1}' | awk -F"-" '{print $1"-"$2}')

usage() {
    echo 'Script to deploy service rpm(s) on service group(s)'
    echo "Usage: $0 -r 'rpm_urls' -g 'service_groups' -i jira_id"
    echo
    echo ' where'
    echo '     -r    rpm_urls, a space separated list of URLs for the RPMs within quotes'
    echo '     -g    service_groups, a space separated list of service groups within quotes.'
    echo '           Full SG name or short form are both acceptable.'
    echo '           e.g. Grp_CS_svc_cluster_shmcoreserv or shmcoreserv'
    echo '     -i    jira_id, the ID of the relevant Jira Issue. e.g. CIP-12345'
    echo
    exit 1
}


[[ $# -eq 0 ]] && usage

#while getopts ":r:g:i:" opt
#do
#    case $opt in
#        r ) RPM_URL_LIST="$OPTARG" ;;
#        g ) SHORT_NAME_SERVICE_GROUP_LIST="$OPTARG" ;;
#        i ) JIRA_ID=$OPTARG ;;
#        * ) echo "Invalid input ${opt}"; usage; exit 1 ;;
#    esac
#done

while getopts "g:i:" opt
do
    case $opt in
        g ) SHORT_NAME_SERVICE_GROUP_LIST="$OPTARG" ;;
        i ) JIRA_ID=$OPTARG ;;
        * ) echo "Invalid input ${opt}"; usage; exit 1 ;;
    esac
done


echo -e "\n"
echo `date "+%F %T.%3N"`" INFO  BEGIN PROCESSING OF RPM LOADING FOR JIRA $JIRA_ID"



for SHORT_NAME_SERVICE_GROUP in $SHORT_NAME_SERVICE_GROUP_LIST
do

	#SG_NAME=mscmip
	#echo $SHORT_NAME_SERVICE_GROUP

	SG_HOSTS=`/usr/bin/consul members list | grep $CLOUD_HOST-$SHORT_NAME_SERVICE_GROUP- | awk '{print $1}'`

	#echo $SG_HOSTS 


	for SG in $SG_HOSTS
	do
		OFFLINE_VM=$(/root/rvb/bin/ssh_to_vm_and_su_root.exp $SG 'pkill consul')
		echo `date "+%F %T.%3N"` " INFO  OFFLINE OF VIRTUAL HOST $SG"
		sleep 30
		echo `date "+%F %T.%3N"` " INFO  WAITING FOR STARTUP OF VIRTUAL HOST $SG"
		#counter for timeout of 500 sec
		count=1
		while true; do
			CONSUL_CMD=`/usr/bin/consul members list | grep $SG`
			sleep 10
			if [[ $CONSUL_CMD = *"alive"* ]] || [ $count -eq 50 ]; then
  				echo `date "+%F %T.%3N"` " INFO  VIRTUAL HOST $SG HAS BEEN STARTED"
				break
			else
				if [[ $CONSUL_CMD != *"alive"* ]] && [ $count -eq 50 ]; then
					echo `date "+%F %T.%3N"` " INFO  STARTUP OF VIRTUAL HOST $SG HAS FAILED"
					echo  `date "+%F %T.%3N"`" INFO  IT WILL BE NEEDED TO ROLLBACK RPM $SHORT_NAME_SERVICE_GROUP"
				fi
			fi
			((count++))
		done
	done
done
echo `date "+%F %T.%3N"`" INFO  PROCESSING OF RPM LOADING FOR JIRA $JIRA_ID SUCCESSFULLY COMPLETED"
