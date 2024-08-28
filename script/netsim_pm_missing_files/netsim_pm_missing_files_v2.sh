#!/bin/bash

workload_vm=$1
pmtype=$2
rop_time=$3
netsims=$4


next_quarter=15
rop_time2=$(date -d"$next_quarter minutes $rop_time" '+%H%M')
rop_date=$(date +'%Y%m%d')
rop_date_time="${rop_date}.${rop_time}*${rop_time2}"
echo "ROP date and time: $rop_date_time"


netsim_get_sims() {
local sims
sims=$(ssh -q -o StrictHostKeyChecking=no netsim@$netsim << EOF1	
echo '.show simulations' | /netsim/inst/netsim_pipe
EOF1
)

echo $sims | sed 's/\.show simulations//g' | sed 's/>>//g'
}

netsim_get_sim_nodes() {
local sim=$1 nodes
nodes=$(ssh -q -o StrictHostKeyChecking=no netsim@$netsim << EOF1
for i in 1;do
echo ".open $sim" 
echo '.selectallsimne'
done | /netsim/inst/netsim_pipe
EOF1
)

echo "$nodes" | grep 'select ' | sed 's/>> .select //g'


}

pm_stats_file="A$rop_date_time*.xml*"
pm_cell_dul_file="A${rop_date_time}_CellTrace_DUL*"

celltrace_nodes=$(ssh -q -o StrictHostKeyChecking=no root@$workload_vm "/opt/ericsson/enmutils/bin/cli_app 'cmedit get * enodebfunction -ne=RadioNode -t' | awk '{print \$1}' | sort | grep -v 'NodeId\|SubNetwork'")

echo "$celltrace_nodes" > enm_celltrace_nodes.txt

for netsim in $netsims;do
  echo "==========================================================================="
  echo "INFO: Checking Netsim VM $netsim"

sims=$(netsim_get_sims)

for sim in $sims;do
  node_not_conf=0
  node_pm_files_missing=0
  if [[ $sim == *"ML"* ]];then
    echo "INFO: Minilinks nodes of simulation $sim not supported by Genstats! Skipping ..."
    continue
  fi
  if [[ $sim == *"DSC"* ]];then
    echo "INFO: DSC nodes of simulation $sim not supported by Genstats! Skipping ..."
    continue
  fi
  if [[ $sim == *"SCU"* ]];then
    echo "INFO: SCU simulations are not supported! Skipping ..."
    continue
  fi

  if [[ $sim == *"default"* ]];then
    continue
  fi
  echo "INFO: Simulation $sim"
  if [[ $sim == *"LTE"* ]];then
    pms_dir=$(echo $sim | awk -F'-' '{print $NF}')
  else
    pms_dir=$sim
  fi
  pms_nodes=$(ssh -q -o StrictHostKeyChecking=no netsim@$netsim "ls /pms_tmpfs/*$pms_dir")
#  echo "INFO: Nodes configured in Genstats: $pms_nodes"
  nodes=$(netsim_get_sim_nodes $sim)
#  echo "INFO: Nodes present in Netsim simulation: $nodes"
#  echo "INFO: Checking that nodes of simulation $sim are configured in Genstats"
  for node in $nodes;do
    no_cell_dul_pm_files=0
    if [[ $pms_nodes != *$node* ]];then
      echo "ERROR: Genstats files are not configured for node $node !"
      node_not_conf=1
    fi
#    r_cmd=$(sshpass -p netsim ssh -q -o StrictHostKeyChecking=no netsim@$netsim "ls /pms_tmpfs/*$pms_dir/$node/c/pm_data/A20240119.2000-2015:1.xml* 1>/dev/null 2>/dev/null;echo \$?")
    if [[ $pmtype == *"PM_STATISTICAL"* ]];then
      if [[ $node == *"PCG"* ]];then
        stat_files_cmd=$(ssh -q -o StrictHostKeyChecking=no netsim@$netsim "ls /pms_tmpfs/*$pms_dir/$node/eric-pmbr-rop-file-store/$pm_stats_file 2>&1")
      else
        stat_files_cmd=$(ssh -q -o StrictHostKeyChecking=no netsim@$netsim "ls /pms_tmpfs/*$pms_dir/$node/c/pm_data/$pm_stats_file 2>&1")
      fi
      if [[ "$stat_files_cmd" == *"No such file or directory"* ]];then
        echo "ERROR: Statistical PM file $pm_stats_file has not been found for node $node !"
        node_pm_files_missing=1
      fi
    fi
#    if [[ $pmtype == *"PM_CELLTRACE"* ]] && [[ $node == *$celltrace_nodes* ]];then
     if [[ $pmtype == *"PM_CELLTRACE"* ]] && grep -q $node enm_celltrace_nodes.txt;then
      cell_dul_files_cmd=$(ssh -q -o StrictHostKeyChecking=no netsim@$netsim "ls /pms_tmpfs/*$pms_dir/$node/c/pm_data/$pm_cell_dul_file 2>&1")
      if [[ "$cell_dul_files_cmd" == *"No such file or directory"* ]];then
        echo "ERROR: Celltrace PM files $pm_cell_dul_file have not been found for node $node !"
        node_pm_files_missing=1
      else
        no_cell_dul_pm_files=$(echo "$cell_dul_files_cmd" | wc -l)
	if [ $no_cell_dul_pm_files -eq 1 ];then
	  echo "ERROR: Only one Celltrace PM file $pm_cell_dul_file has been found for node $node (expected 2 files) !"
	  echo $cell_dul_files_cmd
	  node_pm_files_missing=1
        fi
      fi
    fi
    
  done
if [ $node_not_conf -eq 0 ] && [ $node_pm_files_missing -eq 0 ];then
  echo "INFO: OK"
fi
#  if [ $node_not_conf -eq 0 ];then
#    echo "INFO: All nodes of simulation $sim are configured in Genstats"
#  fi
#  if [ $node_stat_pm -eq 0 ] && [[ $pmtype == *"PM_STATISTICAL"* ]];then
#    echo "INFO: All PM Statistical files of simulation $sim are present"
#  fi
#  if [ $node_cell_dul_pm -eq 0 ] && [[ $pmtype == *"PM_CELLTRACE"* ]] && [[ $sim != @(*"ML"*|*"SCU"*|*"Router"*) ]];then 
#    echo "INFO: All PM Celltrace files of simulation $sim are present"
#  fi
done

 done
