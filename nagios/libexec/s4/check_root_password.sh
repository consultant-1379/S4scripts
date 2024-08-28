#!/usr/bin/bash

lms_host=$1

sshpass -p 12shroot scp -q login.sh nagios@$1:login.sh

sshpass -p 12shroot ssh -q nagios@$1 "chmod +x login.sh"

sshpass -p 12shroot ssh -q nagios@$1 "/home/nagios/login.sh root 12shroot"

retVal=$?
if [ $retVal -eq 0 ];then
  echo "CRITICAL - ROOT PASSWORD OF LMS IS SET TO DEFAULT VALUE!"
  exit 2
fi

if [ $retVal -eq 125 ];then
  echo "OK - DEFAULT ROOT PASSWORD OF LMS HAS BEEN CHANGED"
  exit 0
fi
