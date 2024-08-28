#!/bin/bash


ticket_status_query_list="$2"
watchers=$3

if [[ $ticket_status_query_list = *"All"* ]];then
  ticket_status_query_list="Testing Approved Open Next%20to%20go%20on"
fi  

for ticket_status_query in $ticket_status_query_list; do
#  echo "Processing tickets in status: $ticket_status_query"
  TICKET_STATUS_QUERY="status=%22$ticket_status_query%22"

  CLUSTERID=$1

  ENVIRONMENT_QUERY="%20AND%20Environment~$CLUSTERID"

  QUERY_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com:443/rest/api/2/search?jql=project=CIP%20AND%20component=TEaaS%20AND%20$TICKET_STATUS_QUERY%20AND%20%22DE%20Team%20Name%22=%22S4(Performance)%22$ENVIRONMENT_QUERY&maxResults=1000"

  jira_tickets=$(curl -s -D- -u S4_Team:S4_Team -X GET -H "Content-Type: application/json" "$QUERY_URL" | grep -oP '"key": *"CIP[^"]*"')

  cip_tickets=$(echo $jira_tickets | grep -oP 'CIP-[^"]*')

#  echo $cip_tickets


  for cip_ticket in $cip_tickets; do

    QUERY_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com/rest/api/2/issue/$cip_ticket"
    emails=$(curl -s -D- -u S4_Team:S4_Team -X GET -H "Content-Type: application/json" "$QUERY_URL" | grep -oP '"emailAddress": *"[^"]*"' | sort | uniq)
    tot_emails="$tot_emails$emails"
  done
#  echo $tot_emails
  email_list=$tot_emails
#  email_list=$(echo $tot_emails | grep -oP ':*"[^"]*"' | grep -v email | awk -F "\"" '{print $2}')
#  echo $email_list
  final_email_list="$final_email_list $email_list"

  if [[ $watchers = *"true"* ]];then
    QUERY_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com/rest/api/2/issue/$cip_ticket/watchers"
    emails_watchers=$(curl -s -D- -u S4_Team:S4_Team -X GET -H "Content-Type: application/json" "$QUERY_URL" | grep -oP '"emailAddress": *"[^"]*"' | sort | uniq)
    final_email_list="$final_email_list $email_list $emails_watchers"
  fi
done
  final_email_list=$(echo $final_email_list | grep -oP ':*"[^"]*"' | grep -v email | awk -F "\"" '{print $2}')
  final_email_list=$(echo $final_email_list | tr ' ' '\n' | sort | uniq | tr '\n' ',')
#  aa=$final_email_list

echo $final_email_list

