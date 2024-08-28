#/bin/bash

rnc_nni=1
bsc_nni=1
rbs_nni=2477

nodes_nrm_ran=18489
nodes_nrm_core=360
nodes_nrm_transport=5000

netypes_ran="BSC ERBS MSC-BC-BSP MSC-BC-IS MSC-DB-BSP RadioNode RBS RNC"

netypes_core="DSC EPG EPG-OI MGW MTAS SBG-IS SGSN-MME"

netypes_transport="ESC FRONTHAUL-6020 JUNIPER-MX MINI-LINK-6352 MINI-LINK-669x Router6274 Router6675"

echo "***************CHECKING NODES IN RAN NETWORK"

for netype in $netypes_ran;do
  num_nodes_netsim_ran=$(grep -w $netype, /opt/ericsson/enmutils/etc/nodes/*-nodes | awk -F ":" '{print $2}' | awk -F "," '{print $1}' | sort | uniq | wc -l)
  num_nodes_ran=$(/opt/ericsson/enmutils/bin/cli_app "cmedit get * NetworkElement -netype=$netype --count" | tail -1 | awk '{print $1}')
  echo "*****NUMBER OF $netype: $num_nodes_ran"
  echo "*****NUMBER OF $netype NETSIM: $num_nodes_netsim_ran"
  tot_nodes_ran=$((tot_nodes_ran+num_nodes_ran))
done

echo "***************TOTAL NUMBER OF NODES IN RAN NETWORK: $tot_nodes_ran"
echo "***************TOTAL NUMBER OF NRM NODES IN RAN NETWORK: $nodes_nrm_ran"

echo "***************CHECKING NODES IN CORE NETWORK"

for netype in $netypes_core;do
  num_nodes_netsim_core=$(grep -w $netype, /opt/ericsson/enmutils/etc/nodes/*-nodes | awk -F ":" '{print $2}' | awk -F "," '{print $1}' | sort | uniq | wc -l)
  num_nodes_core=$(/opt/ericsson/enmutils/bin/cli_app "cmedit get * NetworkElement -netype=$netype --count" | tail -1 | awk '{print $1}')
  echo "*****NUMBER OF $netype: $num_nodes_core"
  echo "*****NUMBER OF $netype NETSIM: $num_nodes_netsim_core"
  tot_nodes_core=$((tot_nodes_core+num_nodes_core))
done

echo "***************TOTAL NUMBER OF NODES IN CORE NETWORK: $tot_nodes_core"
echo "***************TOTAL NUMBER OF NRM NODES IN CORE NETWORK: $nodes_nrm_core"

echo "***************CHECKING NODES IN TRANSPORT NETWORK"

for netype in $netypes_transport;do
  num_nodes_netsim_transport=$(grep -w $netype, /opt/ericsson/enmutils/etc/nodes/*-nodes | awk -F ":" '{print $2}' | awk -F "," '{print $1}' | sort | uniq | wc -l)
  num_nodes_transport=$(/opt/ericsson/enmutils/bin/cli_app "cmedit get * NetworkElement -netype=$netype --count" | tail -1 | awk '{print $1}')
  echo "*****NUMBER OF $netype: $num_nodes_transport"
  echo "*****NUMBER OF $netype NETSIM: $num_nodes_netsim_transport"
  tot_nodes_transport=$((tot_nodes_transport+num_nodes_transport))
done

echo "***************TOTAL NUMBER OF NODES IN TRANSPORT NETWORK: $tot_nodes_transport"
echo "***************TOTAL NUMBER OF NRM NODES IN TRANSPORT NETWORK: $nodes_nrm_transport"

