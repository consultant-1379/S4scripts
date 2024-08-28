#!/bin/bash

sshpass -p '12shroot' ssh nagios@$1 "ping -c3 $2" 1>/dev/null 2>/dev/null

SUCCESS=$?

if [ $SUCCESS -eq 0 ]
then
  echo "PING OK"
  exit 0
else
  echo "PING NOK"
  exit 2
fi
