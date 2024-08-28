#!/bin/bash

source /usr/local/nagios/libexec/s4/common_functions.sh

lms_ip=$1
wkl_vm_ip=$2

cluster_id=$(get_deployment_id_from_ms_ip $lms_ip)

config_file="${cluster_id}_configuration.sh"

source /usr/local/nagios/libexec/s4/$config_file

# Crea lista su workload 623
sshpass -p 12shroot ssh nagios@$lms_ip "sudo ssh root@$wkl_vm_ip ls /opt/ericsson/enmutils/etc/nodes/* | sort > /tmp/my_list.txt"
# Sposta lista su Nagios
sshpass -p 12shroot ssh nagios@$lms_ip "sudo cat /tmp/my_list.txt" > /tmp/my_list.txt
#cancella file precendete
#rm /tmp/netsim_ok.txt
cp /tmp/my_list.txt /tmp/new_list.txt

i=0
CRITICAL=0

for netsim in $netsims;do 
  if grep -Fxq "/opt/ericsson/enmutils/etc/nodes/$netsim.athtem.eei.ericsson.se-nodes" /tmp/my_list.txt #133
    then
      #echo "/opt/ericsson/enmutils/etc/nodes/$netsim.athtem.eei.ericsson.se-nodes" >> /tmp/netsim_ok.txt
      grep -v "/opt/ericsson/enmutils/etc/nodes/$netsim.athtem.eei.ericsson.se-nodes" /tmp/new_list.txt > temp && cp temp /tmp/new_list.txt
    else
      CRITICAL=1
  fi
i=$(($i + 1))
done
#echo $i 

if [ $CRITICAL == 1 ]; then
    echo "CRITICAL - NUMBER OF NODES TYPE DOES NOT MATCH"
    echo "Different rows numbers:"
    wc --lines new_list.txt | egrep -o '[0-9]*'
    echo "Different rows list:"
    vi new_list.txt 
    exit 2
fi

sed -i '1d' /tmp/new_list.txt
echo "OK - NUMBER OF NODES TYPE ARE $i"
exit 0

#diff -u my_list.txt netsim_ok.txt | grep -v ' ' | grep -v "+"



