#!/bin/bash

IFS=','
read -ra ADDR <<< "${mail_list}"
reporter=${ADDR[0]}
assignee=${ADDR[1]}

IFS='@'
read -ra ADDR1 <<< "${reporter}"
reporter=${ADDR1[0]}

read -ra ADDR2 <<< "${assignee}"
assignee=${ADDR2[0]}

IFS='.'
read -ra ADDR3 <<< "${reporter}"
reporter="${ADDR3[0]} ${ADDR3[1]}"

read -ra ADDR4 <<< "${assignee}"
assignee="${ADDR4[0]} ${ADDR4[1]}"

