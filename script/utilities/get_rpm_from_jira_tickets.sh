#!/bin/bash

jira_tickets=$1

user="S4_Team"
password="S4_Team"

rm -rf lista_rpm.txt
rm -rf lista_rpm_repo.txt

rpm_info_summary=""

for jira_ticket in $jira_tickets;do

  QUERY_URL="https://jira-oss.seli.wh.rnd.internal.ericsson.com/rest/api/2/issue/$jira_ticket/"
#  jira_rest_output=$(curl -s -D- -u $user:$password -X GET -H "Content-Type: application/json" "$QUERY_URL")
  jira_rest_output=$(curl -s -D- -u $user:$password "$QUERY_URL")
#  rpm_records_raw=$(echo $jira_rest_output | grep -o -P '(?<=RPM INFORMATION TABLE).*(?=Deployment Description \(DD\) INFORMATION TABLE)' | grep -o -P 'https:[^{]*' | sed 's/||/|/g' | grep -o -P 'ERIC\w+-.+?(?<=\\r)')

#   rpm_present=$(echo $jira_rest_output | grep -o -P '(?<=RPM INFORMATION TABLE).*(?=Deployment Description \(DD\) INFORMATION TABLE)' | grep -o -P 'ERIC')
  rpm_present=$(echo $jira_rest_output | grep -o -P '(?<=RPM INFORMATION TABLE).*(?=Deployment Description \(DD\) INFORMATION TABLE)')

  rpm_list=$(echo "$rpm_present" | grep -o -P 'https.*' | sed 's/\\n/\n/g' | sed 's/^|//g' | sed 's/\[//g' | sed 's/\]//g' | sed 's/\\r//g' | sed 's/ //g' | grep -o -P 'http.*' | grep -o -P 'ERIC.*' | grep -o -P '(?=ERIC).*(?<=rpm)')

  #echo $rpm_list

  for rpm in $rpm_list;do

    if [[ $rpm == *\/* ]];then
      rpm=$(echo $rpm | awk -F'/' '{print $3}')
    fi
#    echo "$jira_ticket $rpm" >> lista_rpm.txt
#  done

#  while read line; do
    
#    rpm_name=$(echo $line | awk '{print $2}' | awk -F '-' '{print $1}')
#    echo $rpm_name
     rpm_name=$(echo $rpm | awk -F '-' '{print $1}')

    rpm_repo=$(find /var/www/html -name "$rpm_name*" | awk -F'/' '{print $5}')
    
     rpm_info_summary="$rpm_info_summary $jira_ticket|$rpm|$rpm_repo"

#    echo "$line $rpm_repo" >> lista_rpm_repo.txt

#  done < lista_rpm.txt
  done
done
echo $rpm_info_summary


