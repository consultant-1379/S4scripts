#!/bin/bash

    Netsim_state=$(sshpass -p 12shroot ssh nagios@$1 "sudo /opt/ericsson/enmutils/bin/netsim list | grep 'There are\|[Re]start' | wc -l")

        if [ "Netsim_state" -eq "0" ]; then 
        echo "OK NETSIM IS IN Started STATE" 
        exit 0
else 
        echo "NOK Netsim processes are stopped"
        exit 1
        
fi
