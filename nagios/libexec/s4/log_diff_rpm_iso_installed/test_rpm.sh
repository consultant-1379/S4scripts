#!/bin/bash

ISO_version=$(sshpass -p 12shroot ssh nagios@141.137.208.23 "sudo cat /var/log/enminst.log" | grep "ENM Version info" | tail -1 | awk '{print$14;}' | sed 's/)//')
#echo $ISO_version

echo /software/autoDeploy/ERICenm_CXP9027091-$ISO_version.iso

ISO_check=$(sshpass -p 12shroot ssh nagios@141.137.208.23 "[ -f /software/autoDeploy/ERICenm_CXP9027091-$ISO_version.iso ] && echo "exist" || echo "noexist"")

if [ $ISO_check == 'exist' ]; then
    echo "Prosegue"
else
    echo "Esce"
fi



