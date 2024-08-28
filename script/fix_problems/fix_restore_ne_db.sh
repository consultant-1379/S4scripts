#!/bin/bash
NE_TYPES=$1
NE_LIST=$2

CLI_CMD="/opt/ericsson/enmutils/bin/cli_app"

TMP_DIR="/var/tmp/myscripts/restore_ne_db_tmp_files/$(date +'%H-%M-%S-%d-%m-%Y')"

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

restore_ne_db() {

  if [ -n "$sim_to_restore" ] || [ -n "$netsim_to_restore" ];then

    sshpass -p netsim ssh -o StrictHostKeyChecking=no netsim@$netsim_to_restore << EOF
cd inst
./netsim_pipe
.open $sim_to_restore
.select $nodes_to_restore
.stop -parallel
.restorenedatabase curr all force
.start -parallel
EOF

  else
    echo "$unsyn_node not found in file present under /opt/ericsson/enmutils/etc/nodes/ dir"
  fi
}

set -ex

for ne_type in $NE_TYPES;do
  echo "RESTORE NE DB ON NETYPE: $ne_type"
  if [ -z "$NE_LIST" ];then
    no_unsyn_nodes=$($CLI_CMD "cmedit get * CmFunction.syncStatus!=SYNCHRONIZED --neType=$ne_type -t" | grep 'UNSYNCHRONIZED\|TOPOLOGY\|PENDING' | wc -l)
    if [ "$no_unsyn_nodes" -eq "0" ];then
      echo "NO $ne_type UNSYNCH ARE PRESENT !"
      exit 0
    fi

    echo "NUMBER OF $ne_type NODES WITH SYNCH FAILURES BEFORE EXECUTING THE W/A: $no_unsyn_nodes"
    unsyn_node_list=$($CLI_CMD "cmedit get * CmFunction.syncStatus!=SYNCHRONIZED --neType=$ne_type -t" | grep 'UNSYNCHRONIZED\|TOPOLOGY\|PENDING' | awk '{print $1}' | sed 's/ieatnetsimv.*_//g')
    else
    unsyn_node_list=$NE_LIST
  fi

  echo $unsyn_node_list

  for unsyn_node in $unsyn_node_list;do

    sim=$(grep $unsyn_node /opt/ericsson/enmutils/etc/nodes/* | awk -F',' '{print $24}' | head -1 | sed -e 's/^[[:space:]]*//')
    netsim_host=$(grep $unsyn_node /opt/ericsson/enmutils/etc/nodes/* | awk -F',' '{print $25}' | sed -e 's/^[[:space:]]*//' | head -1)
    if [ -n "$sim" ] || [ -n "$netsim_host" ];then
      mkdir -p $TMP_DIR/$netsim_host
      mkdir -p $TMP_DIR/$netsim_host/$sim
      touch $TMP_DIR/$netsim_host/$sim/$unsyn_node
    else
      echo "$unsyn_node not found in file present under /opt/ericsson/enmutils/etc/nodes/ dir"
    fi
  done
done

cd $TMP_DIR/
pwd
ls
netsims_to_restore=$(ls)

for netsim_to_restore in $netsims_to_restore;do
  cd $netsim_to_restore
  pwd
  ls
  sims_to_restore=$(ls)
  for sim_to_restore in $sims_to_restore;do
    cd $sim_to_restore
    nodes_to_restore=$(ls)
    nodes_to_restore=$(echo $nodes_to_restore | tr '\n' ' ')
    echo $nodes_to_restore
    echo "RESTORING NE DB ON NODE(S): $nodes_to_restore"
    restore_ne_db
    cd ..
  done
  cd ..
done

rm -rf $TMP_DIR

#    if ! check_netsim_started;then
#      echo "Netsim is not started in host: $netsim_host"
#      break
#    fi
    
#    echo "RESTORING NE DB ON NODE: $unsyn_node"
#    restore_ne_db
#    sleep 2
#  no_unsyn_nodes=$($CLI_CMD "cmedit get * CmFunction.syncStatus!=SYNCHRONIZED --neType=$ne_type -t" | grep 'UNSYNCHRONIZED\|TOPOLOGY\|PENDING' | wc -l)
#  echo "NUMBER OF $ne_type NODES WITH SYNCH FAILURES AFTER EXECUTING THE W/A: $no_unsyn_nodes"

