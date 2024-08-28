#!/bin/bash

ticket_query="$1"
watchers=$2
deployment_ids=$3

JIRA_CURL_CMD='sudo curl -s -u S4_Team:S4_Team -X GET -H "Content-Type: application/json"'
JIRA_JQL_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com:443/rest/api/2/search?jql="
#JIRA_QUERY="$JIRA_CURL_CMD $JIRA_JQL_URL$ticket_query" 
JIRA_REST_URL_ISSUE="https://jira-oss.seli.wh.rnd.internal.ericsson.com/rest/api/2/issue/"

getJiraTickets(){
  local jira_tickets JIRA_QUERY
  if [ ! -z "$deployment_ids" ];then
    deployment_query_to_add=$(addDeploymentsToQuery)
  fi
  JIRA_QUERY="$JIRA_CURL_CMD $JIRA_JQL_URL$ticket_query$deployment_query_to_add"
  jira_tickets=$($JIRA_QUERY | jq -r '.issues[].key')
  if [ $? -ne 0 ];then
    echo "NO JIRA TICKETS HAVE BEEN FOUND FOR THE SELECTED QUERY!"
    exit 1
  else  
    echo "$jira_tickets"
  fi  
}

addDeploymentsToQuery(){
  deployment_query="%20AND%20("
  num=$(echo $deployment_ids | wc -w)
  if [ $num -eq 1 ];then
    deployment_query="${deployment_query}environment%20~%20$deployment_ids)"
  fi
  if [ $num -gt 1 ];then
    for deployment_id in $deployment_ids;do
      deployment_query="${deployment_query}environment%20~%20$deployment_id"
      i=$((i+1))
      if [ $i -lt $num ];then
        deployment_query="${deployment_query}%20OR%20"
      fi
    done 
    deployment_query="${deployment_query})"
  fi
  echo $deployment_query
}  

getEmailAddressesFromJiraTicket(){
  local jira_ticket=$1
  local JIRA_QUERY email_address
  if [[ "$watchers" == "yes" ]];then
    JIRA_QUERY="$JIRA_CURL_CMD $JIRA_REST_URL_ISSUE$jira_ticket/watchers"
    email_address=$($JIRA_QUERY | jq -r '.watchers[].emailAddress')
  else
    JIRA_QUERY="$JIRA_CURL_CMD $JIRA_REST_URL_ISSUE$jira_ticket"
    email_address=$($JIRA_QUERY | jq -r '.fields.reporter.emailAddress')
  fi
  echo "$email_address"

}

jira_tickets=$(getJiraTickets)
if [ -z "$jira_tickets" ];then
  echo "NO JIRA TICKETS HAVE BEEN FOUND FOR THE SELECTED QUERY!"
  exit 1
fi

for jira_ticket in $jira_tickets;do
  email_address=$(getEmailAddressesFromJiraTicket $jira_ticket)
  email_addresses="$email_addresses $email_address"
done

email_addresses=$(echo $email_addresses | sed 's/^ *//g' | tr ' ' '\n' | sort | uniq | tr '\n' ' ')

echo $email_addresses
