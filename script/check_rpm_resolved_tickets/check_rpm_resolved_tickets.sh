#!/bin/bash

deployment_type(){

  local deployment_id=$1
  local depl_type

  case $deployment_id in

  429|623|660)
    depl_type="Physical"	  
    ;;

  625|656)
    depl_type="Cloud"	  
    ;;

  *)
    echo -n "unknown deployment !"
    exit
    ;;
  esac

  echo $depl_type
}

#jira_tickets="$1"
jira_tickets_status=$1

user="S4_Team"
password="S4_Team"
jira_tickets_w_rpm=""

echo ""
echo ""
echo "********* GETTING LIST OF TICKETS WHICH ARE IN $jira_tickets_status STATUS"

jira_tickets=$(S4scripts/script/utilities/get_jira_tickets_from_status.sh $jira_tickets_status)

#echo "FOLLOWING TICKETS ARE IN $jira_tickets_status STATUS:"
echo ""
echo "$jira_tickets"

echo ""
echo ""
echo "******** PHASE 1: SEARCHING JIRA TICKETS WITH RPM"

for jira_ticket in $jira_tickets;do
  echo ""
  echo "CHECKING JIRA TICKET: $jira_ticket"
  QUERY_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com/rest/api/2/issue/$jira_ticket/"
  jira_rest_output=$(curl -s -D- -u $user:$password -X GET -H "Content-Type: application/json" "$QUERY_URL")
#  rpm_records_raw=$(echo $jira_rest_output | grep -o -P '(?<=RPM INFORMATION TABLE).*(?=Deployment Description \(DD\) INFORMATION TABLE)' | grep -o -P 'https:[^{]*' | sed 's/||/|/g' | grep -o -P 'ERIC\w+-.+?(?<=\\r)')

   rpm_present=$(echo $jira_rest_output | grep -o -P '(?<=RPM INFORMATION TABLE).*(?=Deployment Description \(DD\) INFORMATION TABLE)' | grep -o -P 'ERIC')

  if [ -z "$rpm_present" ];then
#    echo "JIRA TICKET: $jira_ticket IS NOT HAVING RPM !"
    echo ">>NO RPMS ARE PRESENT. TICKET CAN BE CLOSED!"
  else
    echo ">TICKET W/ RPM ! PLEASE FOLLOW PHASE 2 PROCESSING ..."
#    rpm_records=$(echo "$rpm_records_raw" | awk -F "|" '{print $1"|"$2"|"$4}')
    jira_tickets_w_rpm="$jira_tickets_w_rpm $jira_ticket"
  fi
done  

#echo "********** JIRA TICKETS WITH RPM: $jira_tickets_w_rpm"

echo ""
echo ""
echo "********* PHASE 2: PROCESSING JIRA TICKETS WITH RPM"

echo "" > rpm_w_sg.txt

for jira_ticket_w_rpm in $jira_tickets_w_rpm;do
  echo ""
  echo "**** PROCESSING JIRA TICKET $jira_ticket_w_rpm"
  QUERY_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com/rest/api/2/issue/$jira_ticket_w_rpm/"
  jira_rest_output=$(curl -s -D- -u $user:$password -X GET -H "Content-Type: application/json" "$QUERY_URL")
  rpm_records_raw=$(echo $jira_rest_output | grep -o -P '(?<=RPM INFORMATION TABLE).*(?=Deployment Description \(DD\) INFORMATION TABLE)' | grep -o -P 'ERIC[^\\]*' | grep "|" | grep -o -P 'ERIC\w+-[^\\]*' | sed 's/||/|/g;s/SERVICE/service/g;s/Service/service/g;s/MODEL/model/g;s/ //g')
  rpm_records=$(echo "$rpm_records_raw" | awk -F "|" '{print $1"|"$2"|"$4}')
  rpm_records_file=$(echo "$rpm_records_raw" | awk -F "|" '{print $jira_ticket_w_rpm"|"$1"|"$2"|"$4}')
  echo "$rpm_records_file" >> rpm_w_sg.txt 
#  cat rpm_w_sg.txt


  rpms_to_search=$(echo "$rpm_records" | awk -F "|" '{print $1}')
  assignee_email=$(echo $jira_rest_output | grep -o -P 'assignee":{[^}]*' | grep -o -P 'emailAddress":"[^"]*' | sed 's/emailAddress":"//g')
  deployment_id=$(echo $jira_rest_output | grep -o -P 'environment":"[^"]*' | sed 's/environment":"//g' | sed 's/\\r\\n//g')
  echo ">DEPLOYMENT ID: $deployment_id"
  echo ">JIRA TICKET ASSIGNEE: $assignee_email"
  echo ">RPM TO CHECK:"
  echo "$rpm_records"
  type_of_deployment=$(deployment_type $deployment_id)
  echo ">DEPLOYMENT TYPE: $type_of_deployment"

  if [ "$type_of_deployment" == "Physical" ]; then
#    echo "GETTING REMOTE HOST (LMS) FOR DEPLOYMENT TYPE: $type_of_deployment DEPLOYMENT ID: $deployment_id"

    lms=$(S4scripts/script/utilities/get_host_from_dmt.sh $deployment_id lms $type_of_deployment)
    echo ">LMS HOST: $lms"
#    SCRIPT_DIRECTORY='/root/rvb/bin/teaas/s4/check_rpm_resolved_tickets'
#    ssh -q root@$lms "mkdir -p $SCRIPT_DIRECTORY"
#    scp -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no S4scripts/script/check_rpm_resolved_tickets/check_rpm_yum_repo.sh root@$lms:$SCRIPT_DIRECTORY/
#    ssh -q root@$lms "chmod +x $SCRIPT_DIRECTORY/check_rpm_yum_repo.sh"
#    rpm_present_yum_repo=$(ssh -q root@$lms "$SCRIPT_DIRECTORY/check_rpm_yum_repo.sh \"$rpm_to_search\"")
   echo ">CHECKING IF YUM REPO CONTAINS RPM"
   YUM_REPO_PATH=/var/www/html
   rpms_present_yum_repo=""
   for rpm_to_search in $rpms_to_search;do
#     echo "CHECKING RPM: $rpm_to_search"
     rpm_present_yum_repo=$(ssh -q root@$lms "find $YUM_REPO_PATH -name $rpm_to_search")

#rpm_present_yum_repo=$(ssh -q root@$lms "bash -s" < S4scripts/script/check_rpm_resolved_tickets/check_rpm_yum_repo.sh "$rpms_to_search")

#     echo "$rpm_present_yum_repo"
     if [ ! -z "$rpm_present_yum_repo" ];then
#       echo "\$var is empty"
#       echo "RPM IS NOT PRESENT IN YUM REPO!"
#        echo ""
#     else
#       echo "\$var is NOT empty"
#       echo "RPM $rpm_to_search IS PRESENT IN YUM REPO!"
#       echo "RPM MUST BE REMOVED BEFORE CLOSING THE TICKET!"
       rpms_present_yum_repo="$rpms_present_yum_repo $rpm_to_search"

     fi
   done  
   rpms_present_yum_repo=$(echo $rpms_present_yum_repo | tr ' ' '\n')

    if [ -z "$rpms_present_yum_repo" ];then
      echo ">>NO RPMS ARE PRESENT IN YUM REPO. TICKET CAN BE CLOSED!"
    else
      echo ">>FOLLOWING RPMS ARE PRESENT IN YUM REPO:"
      echo "$rpms_present_yum_repo"
      echo ">>RPM MUST BE REMOVED BEFORE CLOSING THE TICKET!"
    fi
  else
#    echo "DEPLOYMENT TYPE  $type_of_deployment NOT YET SUPPORTED"
#    echo "GETTING REMOTE HOST (WKL VM) FOR DEPLOYMENT TYPE: $type_of_deployment DEPLOYMENT ID: $deployment_id"
    wklvm=$(S4scripts/script/utilities/get_host_from_dmt.sh $deployment_id workload $type_of_deployment)
    echo ">WORKLOAD VM HOST: $wklvma"
    echo "***** RPM CHECK NOT YET SUPPORTED ON VIO DEPLOYMENTS"
#    vnf_laf_ip=$(sshpass -p 12shroot ssh -q -o StrictHostKeyChecking=no root@$wklvm 'env|grep EMP| cut -d'=' -f 2' )
#    sshpass -p 12shroot scp -q -o StrictHostKeyChecking=no root@$wklvm://var/tmp/enm_keypair.pem enm_keypair.pem
#    ssh -q -t -o StrictHostKeyChecking=no -i enm_keypair.pem cloud-user@$vnf_laf_ip "hostname;pwd"

  fi
done

echo "************ PROCESSING COMPLETED"
echo ""
echo ""
#cat rpm_w_sg.txt
