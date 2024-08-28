#!/bin/bash

ip=$1

if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];then
  host_name=$(host $ip | grep -Po 'pointer*[^"]*' | awk '{print $2}' | awk -F "." '{print $1}')
  echo $host_name
else
  echo "ERROR: A valid ip address has to be provided!"
fi
