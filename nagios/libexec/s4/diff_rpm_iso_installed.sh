#!/bin/bash

# ************************************************************
# Company:      Ericsson
# Autor:        Enrico Alletto
# Description:  check for different rpm install in system for Nagios
# Note:         this script save some files in:
#               /usr/local/nagios/libexec/s4/log_diff_rpm_iso_installed
# ************************************************************

#Server IP
#IPserver=141.137.208.23
IPserver=$1

#Check ISO version
ISO_version=$(sshpass -p 12shroot ssh nagios@$IPserver "sudo cat /var/log/enminst.log" | grep "ENM Version info" | tail -1 | awk '{print$14;}' | sed 's/)//')

#ISO in system corresponds to valid ISO
ISO_check=$(sshpass -p 12shroot ssh nagios@$IPserver "[ -f /software/autoDeploy/ERICenm_CXP9027091-$ISO_version*.iso ] && echo "exist" || echo "noexist"")

# If valid ISO is present
if [ $ISO_check == 'exist' ]; then

    #ISO mount
    sshpass -p 12shroot ssh nagios@$IPserver "sudo mount -o loop /software/autoDeploy/ERICenm_CXP9027091-$ISO_version*.iso /media/ENM;"
    #Create .txt file with list rpm installed
    sshpass -p 12shroot ssh nagios@$IPserver "sudo ls -l -R /var/www/html/ENM_* | grep ".rpm" | awk '{print $ 9;}' > /tmp/rpm_installed.txt"
    #Create .txt file with list rpm ISO
    sshpass -p 12shroot ssh nagios@$IPserver "sudo ls -l -R /media/ENM/repos/ENM | grep ".rpm" | awk '{print $ 9;}' > /tmp/rpm_iso.txt"
    #diff between installed and iso 
    sshpass -p 12shroot ssh nagios@$IPserver "sudo diff -u /tmp/rpm_iso.txt /tmp/rpm_installed.txt | grep -v ' ' > /tmp/rpm_compare.txt"
    #move rpm_compare file in Nagios server
    sshpass -p 12shroot scp nagios@$IPserver:/tmp/rpm_compare.txt /usr/local/nagios/libexec/s4/log_diff_rpm_iso_installed/rpm_compare.txt
    #Umount ISO
    sshpass -p 12shroot ssh nagios@$IPserver "sudo umount /media/ENM"

# If valid ISO NOT is present
#else
    #echo "ATTENTION!!! ISO version is not present"

fi

#echo on Nagios

if [ $ISO_check != 'exist' ]; then
        echo "ATTENTION!!! ISO version is not present !!!"
        exit 2
fi
if [ $(wc -l /usr/local/nagios/libexec/s4/log_diff_rpm_iso_installed/rpm_compare.txt | awk '{print $1}') != 0 ]; then
        echo "RPM ON SERVER ARE DIFFERENT FROM ISO ($ISO_version)"

        #Message to video
        echo "---------------------------- "
        echo "NOTE: + Management Server ; - ISO"
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
        exit 1
fi
if [ $(wc -l /usr/local/nagios/libexec/s4/log_diff_rpm_iso_installed/rpm_compare.txt | awk '{print $1}') == 0 ]; then
        echo "RPM are aligned"
fi




