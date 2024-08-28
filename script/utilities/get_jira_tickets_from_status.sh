#!/bin/bash

ticket_status_query=$1
user="S4_Team"
password="S4_Team"


TICKET_STATUS_QUERY="status=%22$ticket_status_query%22"

#QUERY_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com:443/rest/api/2/search?jql=project=DETS%20AND%20component=Team%20Grifone%20AND%20$TICKET_STATUS_QUERY%20AND%20%22DE%20Team%20Name%22=%22S4(Performance)%22&maxResults=1000"

QUERY_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com:443/rest/api/2/search?jql=project%20=%20DETS%20AND%20component%20=%20'Team%20Grifone'%20AND%20$TICKET_STATUS_QUERY%20AND%20'Type%20of%20Server%20Access'%20in%20(Shared,%20'Exclusive',%20'Exclusive%20evening',%20'Exclusive%20weekend')"

jira_tickets=$(sudo curl -s -D- -u S4_Team:S4_Team -X GET -H "Content-Type: application/json" "$QUERY_URL" | grep -oP '"key": *"DETS[^"]*"')

dets_tickets=$(echo $jira_tickets | grep -oP 'DETS-[^"]*')


if [ -z "$dets_tickets" ];then
  echo "NO TICKETS HAVE BEEN FOUND !"
  exit 1
else
  echo "$dets_tickets"
  exit 0
fi
