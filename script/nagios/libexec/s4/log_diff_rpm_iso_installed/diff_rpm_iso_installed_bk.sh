#!/bin/bash

# ************************************************************
# Company:      Ericsson
# Autor:        Enrico Alletto
# Description:  check for different rpm install in system 
# Note:         for Nagios
# ************************************************************

#Check ISO version
ISO_version=$(sshpass -p 12shroot ssh nagios@141.137.208.23 "sudo cat /var/log/enminst.log" | grep "ENM Version info" | tail -1 | awk '{print$14;}' | sed 's/)//')

#ISO in system corresponds to valid ISO
ISO_check=$(sshpass -p 12shroot ssh nagios@141.137.208.23 "[ -f /software/autoDeploy/ERICenm_CXP9027091-$ISO_version.iso ] && echo "exist" || echo "noexist"")

# If valid ISO is present
if [ $ISO_check == 'exist' ]; then

    #ISO mount
    sshpass -p 12shroot ssh nagios@141.137.208.23 "sudo mount -o loop /software/autoDeploy/ERICenm_CXP9027091-$ISO_version.iso /media/ENM;"
    #Create .txt file with list rpm installed
    sshpass -p 12shroot ssh nagios@141.137.208.23 "sudo ls -l -R /var/www/html/ENM_* | grep ".rpm" | awk '{print $ 9;}' > /tmp/rpm_installed.txt"
    #Create .txt file with list rpm ISO
    sshpass -p 12shroot ssh nagios@141.137.208.23 "sudo ls -l -R /media/ENM/repos/ENM | grep ".rpm" | awk '{print $ 9;}' > /tmp/rpm_iso.txt"
    #diff between installed and iso 
    sshpass -p 12shroot ssh nagios@141.137.208.23 "sudo diff -u /tmp/rpm_iso.txt /tmp/rpm_installed.txt | grep -v ' ' | grep -v \"+\" > /tmp/rpm_compare.txt"
    #move rpm_compare file in Nagios server
    sshpass -p 12shroot scp nagios@141.137.208.23://tmp/rpm_compare.txt /usr/local/nagios/libexec/s4/log_diff_rpm_iso_installed/rpm_compare.txt
    #Umount ISO
    sshpass -p 12shroot ssh nagios@141.137.208.23 "sudo umount /media/ENM"

    #Message to video
    echo "---------------------------- "
    echo "ISO version "
    echo $ISO_version
    echo "---------------------------- "
    echo "RPM diff number "
    wc -l /usr/local/nagios/libexec/s4/log_diff_rpm_iso_installed/rpm_compare.txt | awk '{print $1}'
    echo "---------------------------- "
    echo "RPM list"
    cat /usr/local/nagios/libexec/s4/log_diff_rpm_iso_installed/rpm_compare.txt
    echo "---------------------------- "

# If valid ISO NOT is present
else
    echo "ATTENTION!!! ISO version is not present"
fi

