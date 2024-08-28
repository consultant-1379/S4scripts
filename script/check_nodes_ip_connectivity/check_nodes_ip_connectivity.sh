#!/bin/bash

# Constants declaration

readonly SSHVM='/root/rvb/bin/ssh_to_vm_and_su_root.exp'
readonly SSHNETSIM='sshpass -p shroot ssh root@'
readonly PING6_CMD='ping6 -c 4 '
readonly PING4_CMD='ping -c 4 '
readonly TRACER4_CMD='traceroute -4 --max-hops=15 '
readonly TRACER6_CMD='traceroute -6 --max-hops=15 '

# Loading external functions
. ./netsim_nodes_files_lib
. ./common_lib
. ./enm_lib

node_names="$1"

if [ check_nodes_files_exists ];then
  print_message i "NODES FILES ARE PRESENT"
else
  print_message e "NODES FILES ARE PRESENT! EXITING..."
  exit 1
fi

for node_name in $node_names;do
  ip_address=$(get_ip_from_netsim_nodes $node_name)
  ip_type=$(check_ipv4_ipv6 $ip_address)
  netsim_host=$(get_netsim_host_from_netsim_nodes $node_name)
  netype=$(get_netype_from_netsim_nodes $node_name)
  mediation_vm=$(get_cmmediation_vm_from_netype $netype)
  enm_vm=$(get_enm_vm_from_host_file $mediation_vm)
  print_message i "CHECKING IP CONNECTIVITY FOR NODE: $node_name"

  if [ $ip_type == "v4" ];then
    print_message i "TRACEROUTE NODE IP ADDRESS $ip_address FROM MEDIATION VM: $mediation_vm"
    $SSHVM $enm_vm "$TRACER4_CMD $ip_address"
    print_message i "PINGING NODE IP ADDRESS $ip_address FROM NETSIM HOST: $netsim_host"
   $SSHNETSIM$netsim_host "$PING4_CMD $ip_address"
  else
    print_message i "TRACEROUTE NODE IP ADDRESS $ip_address FROM MEDIATION VM: $mediation_vm"
    $SSHVM $enm_vm "$TRACER6_CMD $ip_address"
    print_message i "PINGING NODE IP ADDRESS $ip_address FROM NETSIM HOST: $netsim_host"
    $SSHNETSIM$netsim_host "$PING6_CMD $ip_address"
  fi
done
