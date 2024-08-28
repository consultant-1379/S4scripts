#!/bin/bash

issue_url=$1
#S4deploymentissue${clusterId}
user="S4_Team"
password="S4_Team"


issue=$(echo $issue_url | awk -F "/" '{print $5}')


QUERY_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com/rest/api/2/issue/$issue?fields=summary"

jira_rest_output=$(curl -s -D- -u S4_Team:S4_Team -X GET -H "Content-Type: application/json" "$QUERY_URL")

summary=$(echo $jira_rest_output | grep -oP 'summary":"[^"]*' | awk -F "\"" '{print $3}')

if [ -z "$summary" ];then
  echo "NO ISSUE SUMMARY HAS BEEN FOUND !"
  exit 1
else
  echo "$summary"
  exit 0
fi
