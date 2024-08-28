#!/bin/bash
NODE_LIST=$1

if [ -f /opt/ericsson/enmutils/bin/netsim ];then
    NETSIM_CMD="/opt/ericsson/enmutils/bin/netsim"
else 
    NETSIM_CMD="/opt/ericsson/nssutils/bin/netsim"
fi

check_netsim_started(){

  netsim_status=$($NETSIM_CMD list $netsim_host --no-ansi)
  
  if [[ "$netsim_status" == *"[Re]start Netsim"* ]]; then
    return 1
  fi
}

change_ip_node() {

  sshpass -p netsim ssh -o StrictHostKeyChecking=no netsim@$netsim_host << EOF
cd inst
./netsim_pipe
.open $sim
.select $node_netsim
.stop
.modifyne set_subaddr $node_ip subaddr no_value
.set taggedaddr subaddr $node_ip 1
.set save
.start
EOF

}

set -ex


node_list_sorted=$(echo $NODE_LIST | tr ' ' '\n' | sort)

for node in $node_list_sorted;do
  sim=$(grep $node /opt/ericsson/enmutils/etc/nodes/* | awk -F',' '{print $24}' | head -1 | sed -e 's/^[[:space:]]*//')
  netsim_host=$(grep $node /opt/ericsson/enmutils/etc/nodes/* | awk -F',' '{print $25}' | sed -e 's/^[[:space:]]*//' | head -1)
  node_ip=$(grep $node /opt/ericsson/enmutils/etc/nodes/* | awk -F',' '{print $2}' | sed -e 's/^[[:space:]]*//' | head -1)
  if [[ $node == *"ieatnetsimv"* ]];then
    node_netsim=$(echo $node | awk -F "_" '{print $2}')
  else
    node_netsim=$node
  fi
  if [ -n "$sim" ] && [ -n "$netsim_host" ] && [ -n "$node_ip" ];then
    if ! check_netsim_started;then
      echo "Netsim is not started in host: $netsim_host"
      break
    fi
    change_ip_node
  else
    echo "Parameters not found for node $node in file present under /opt/ericsson/enmutils/etc/nodes/ dir"      
  fi
done

