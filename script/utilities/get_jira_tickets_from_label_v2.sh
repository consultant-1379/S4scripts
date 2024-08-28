#!/bin/bash

label=$1
#S4deploymentissue${clusterId}
user="MBTGWBYEBQ"
password="UADyaxhCDYekTcge3zHck8km"


QUERY_URL="https://eteamproject.internal.ericsson.com/rest/api/2/search?jql=labels%20in%20($label)%20AND%20(status!=Closed%20AND%20status!=Done)"
jira_rest_output=$(sudo curl -s -D- -u $user:$password -X GET -H "Content-Type: application/json" "$QUERY_URL" | grep -oP '"https://eteamproject.internal.ericsson.com/rest/api/2/issue/*[^"]*-*/' | grep -oP 'https://eteamproject.internal.ericsson.com/rest/api/2/issue/*[^"]*-[^"]*' | sort | uniq)


tickets_raw=$(echo $jira_rest_output | tr ' ' '\n' | sed 's/.$//')

tickets=$(echo $tickets_raw | sed 's/https:\/\/eteamproject.internal.ericsson.com\/rest\/api\/2\/issue/https:\/\/eteamproject.internal.ericsson.com\/browse/g')

#if [ -z "$tickets" ];then
#  echo "NO TICKETS HAVE BEEN FOUND !"
#  exit 1
#else
  echo "$tickets"
  exit 0
#fi
