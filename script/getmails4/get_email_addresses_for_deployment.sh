#!/bin/bash

CLUSTERID=$1
TICKET_STATUS=$2

if [ "$CLUSTERID" == "test" ]
then
    echo "stefano.a.manni@ericsson.com"
    exit 0
fi

if [ "$CLUSTERID" == "All" ]
then
    ENVIRONMENT_QUERY=""
else
    ENVIRONMENT_QUERY="%20AND%20Environment~$CLUSTERID"
fi

if [ "$TICKET_STATUS" == "All" ]
then
    TICKET_STATUS_QUERY='status!=Closed'
else
    TICKET_STATUS="%22$(echo $TICKET_STATUS | sed 's/ /%20/')%22"
    TICKET_STATUS_QUERY="status=$TICKET_STATUS"
fi

QUERY_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com:443/rest/api/2/search?jql=project=CIP%20AND%20component=TEaaS%20AND%20$TICKET_STATUS_QUERY%20AND%20%22DE%20Team%20Name%22=%22S4(Performance)%22$ENVIRONMENT_QUERY&maxResults=1000"

#email_addresses=$(curl -s -D- -u S4_Team:S4_Team -X GET -H "Content-Type: application/json" "$QUERY_URL" | tr '{' '\n' | sed -n -e 's/.*emailAddress":"\(.*\)","avatarUrls.*/\1/p' | sort | uniq | egrep -v '^@|@$')

email_addresses=$(curl -s -D- -u S4_Team:S4_Team -X GET -H "Content-Type: application/json" "$QUERY_URL" | tr '{' '\n' | sed -n -e 's/.*emailAddress":"\(.*\)","avatarUrls.*/\1/p' | sort | uniq)

email_addresses=$(echo $email_addresses | tr ' ' ',')
echo $email_addresses
