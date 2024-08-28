#!/bin/bash

CLUSTERID=$1
ticket_status_query_list="$2"
watchers=$3

if [[ $ticket_status_query_list = *"All"* ]];then
  TICKET_STATUS_QUERY="(Status!=Closed%20OR%20Status!=Resolved)"	
#  ticket_status_query_list="Testing Approved Open Next%20to%20go%20on"
#   ticket_status_query_list="Closed"
else
  TICKET_STATUS_QUERY="Status=Testing"
fi  

#for ticket_status_query in $ticket_status_query_list; do
#  echo "Processing tickets in status: $ticket_status_query"
#  TICKET_STATUS_QUERY="status=%22$ticket_status_query%22"

#  ENVIRONMENT_QUERY="Environment~$CLUSTERID"

#JQL QUERY: project=DETS AND component='Team Grifone' AND Environment~429 AND (Status!=Closed OR Status!=Resolved) AND ('Type of Server Access'=Shared OR 'Type of Server Access'='Exclusive')

#   QUERY_URL="https://eteamproject.internal.ericsson.com:443/rest/api/2/search?jql=project=DETS%20AND%20component='Team%20Grifone'%20AND%20Environment~'$CLUSTERID'%20AND%20Status%20not%20in%20(Closed,Resolved)%20AND%20'Type%20of%20Server%20Access'%20in%20(Shared,%20'Exclusive',%20'Exclusive%20evening',%20'Exclusive%20weekend')"

 QUERY_URL="https://eteamproject.internal.ericsson.com/rest/api/2/search?jql=project='DE%20Test%20Services'%20AND%20component='Team%20Grifone'%20AND%20Environment~'$CLUSTERID'%20AND%20Status%20not%20in%20(Closed,Resolved)%20AND%20'cf\[35826\]'%20in%20(Shared,%20'Exclusive',%20'Exclusive%20evening',%20'Exclusive%20weekend')"


#  jira_tickets=$(sudo curl -s -D- -u MBTGWBYEBQ:UADyaxhCDYekTcge3zHck8km -X GET -H "Content-Type: application/json" "$QUERY_URL" | grep -oP '"key": *"DETS[^"]*"')

#  dets_tickets=$(echo $jira_tickets | grep -oP 'DETS-[^"]*' | sort | uniq)

dets_tickets=$(sudo curl -s -u MBTGWBYEBQ:UADyaxhCDYekTcge3zHck8km -X GET -H "Content-Type: application/json" "$QUERY_URL" | jq -r '.issues[].key')

#  echo $dets_tickets


  for dets_ticket in $dets_tickets; do

    QUERY_URL="https://eteamproject.internal.ericsson.com/rest/api/2/issue/$dets_ticket"
    emails=$(sudo curl -s -D- -u MBTGWBYEBQ:UADyaxhCDYekTcge3zHck8km -X GET -H "Content-Type: application/json" "$QUERY_URL" | grep -oP '"emailAddress": *"[^"]*"' | sort | uniq)
    tot_emails="$tot_emails$emails"
  done
#  echo $tot_emails
  email_list=$tot_emails
#  email_list=$(echo $tot_emails | grep -oP ':*"[^"]*"' | grep -v email | awk -F "\"" '{print $2}')
#  echo $email_list
  final_email_list="$final_email_list $email_list"

  if [[ $watchers = *"true"* ]];then
    QUERY_URL="https://eteamproject.internal.ericsson.com/rest/api/2/issue/$dets_ticket/watchers"
    emails_watchers=$(sudo curl -s -D- -u MBTGWBYEBQ:UADyaxhCDYekTcge3zHck8km -X GET -H "Content-Type: application/json" "$QUERY_URL" | grep -oP '"emailAddress": *"[^"]*"' | sort | uniq)
    final_email_list="$final_email_list $email_list $emails_watchers"
  fi
#done
  final_email_list=$(echo $final_email_list | grep -oP ':*"[^"]*"' | grep -v email | awk -F "\"" '{print $2}')
  final_email_list=$(echo $final_email_list | tr ' ' '\n' | sort | uniq | tr '\n' ',')
#  aa=$final_email_list

echo $final_email_list

