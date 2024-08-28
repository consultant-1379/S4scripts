#!/bin/bash

NODES=$1

BASEDIR=`dirname $0`
CLI_APP_CMD=/opt/ericsson/enmutils/bin/cli_app



extract_node_from_node_files(){
  echo "$FUNCNAME - $(date)"
  nodes_node=$(cat ${NODES_DIR}*nodes | grep -w $node)
  if [ -z "$nodes_node" ];then
    echo "NODE $node HAS NOT BEEN FOUND IN NODES FILES !"
  else
    echo $nodes_node >> $NODES_WORKING_FILE
  fi
}

set -ex

NODES_FULL=$(echo $NODES | sed 's/ /,/g')

echo "INFO: Setting secureusername and securepassword on BSC nodes"
$CLI_APP_CMD "secadm credentials update --secureusername LocalCOMUser --secureuserpassword LocalCOMUser --nodelist $NODES_FULL"

echo "INFO: Enabling CM Supervision on BSC nodes"
for node in $NODES;do
  $CLI_APP_CMD "cmedit set NetworkElement=$node,CmNodeHeartbeatSupervision=1 active=false"
  $CLI_APP_CMD "cmedit set NetworkElement=$node,CmNodeHeartbeatSupervision=1 active=true"
  $CLI_APP_CMD "cmedit action NetworkElement=$node,CmFunction=1 sync"
  sleep 5
done

echo "INFO: Checking synchronized BSC node (600 seconds)"
counter=1

node_list=$NODES

while [ $counter -le 20 ];do
  if [ $(echo $sync_bsc | wc -w) -eq $(echo $NODES | wc -w) ];then
    break
  fi
  for node in $node_list;do
    sync_node=$($CLI_APP_CMD "cmedit get $node CmFunction.syncStatus==SYNCHRONIZED -t --netype=BSC")
    if [[ $sync_node == *"1 instance"* ]];then	  
      sync_bsc="$sync_bsc $node"      
      node_list=$(echo $node_list | sed "s/$node//")
    fi
  done
  ((counter++))
  sleep 30
done

echo "INFO: Trying to resync nodes which are unsync"
for node in $node_list;do
  unsync_node=$($CLI_APP_CMD "cmedit get $node CmFunction.syncStatus==UNSYNCHRONIZED -t --netype=BSC")
  if [[ $unsync_node == *"1 instance"* ]];then
    $CLI_APP_CMD "cmedit set $node CmNodeHeartbeatSupervision active=false"
    $CLI_APP_CMD "cmedit set $node CmNodeHeartbeatSupervision active=true"
    $CLI_APP_CMD "cmedit action $node CmFunction sync"
  fi
done

counter=1
while [ $counter -le 18 ];do
  if [ $(echo $sync_bsc | wc -w) -eq $(echo $NODES | wc -w) ];then
    break
  fi
  for node in $node_list;do
    sync_node=$($CLI_APP_CMD "cmedit get $node CmFunction.syncStatus==SYNCHRONIZED -t --netype=BSC")
    if [[ $sync_node == *"1 instance"* ]];then
      sync_bsc="$sync_bsc $node"
      node_list=$(echo $node_list | sed "s/$node//")
    fi
  done
  ((counter++))
  sleep 20
done

echo "INFO: Following BSC nodes are synchronized: $sync_bsc"



echo "INFO: Create xml file for issuing certificates"
#echo "<?xml version="1.0" encoding="UTF-8"?>" > $BASEDIR/oam.xml
echo "<Nodes>" > $BASEDIR/oam.xml
for node in $sync_bsc;do
  echo "  <Node>" >> $BASEDIR/oam.xml
  echo "    <NodeFdn>$node</NodeFdn>" >> $BASEDIR/oam.xml
  echo "  </Node>" >> $BASEDIR/oam.xml
done
echo "</Nodes>" >> $BASEDIR/oam.xml

cat $BASEDIR/oam.xml


echo "INFO: Issuing OAM certificates in BSC nodes"

cert_issue_cmd=$($CLI_APP_CMD "secadm certificate issue --certtype OAM --xmlfile file:oam.xml" $BASEDIR/oam.xml)

if [[ "$cert_issue_cmd" == *"uccessful"* ]];then
   echo "$cert_issue_cmd"
#  job_id=$(echo $cert_issue_cmd | grep -Po "\-j.*" | awk '{print $2}' | sed "s/'//")
else
  echo "ERROR: Command to issue certificates has failed!"
  exit 1
fi

echo "INFO: Waiting for completion of certificate issue workflow (600 sec)"
sleep 600

echo "INFO: Checking issue of OAM certificates in BSC nodes"

$CLI_APP_CMD "secadm certificate get --certtype OAM --nodelist $(echo $sync_bsc | sed 's/ /,/g')" > $BASEDIR/oam_cert.txt

cat $BASEDIR/oam_cert.txt

for node in $sync_bsc;do
  oam_cert_status=$(grep $node $BASEDIR/oam_cert.txt)
  if [[ $oam_cert_status != *"uccessful"* ]];then
    echo "ERROR: OAM certificate not successfully installed for node $node"
  else
    oam_bsc="$oam_bsc $node"
  fi
done

echo "INFO: Following nodes have OAM certificates properly installed: $oam_bsc"

echo "INFO: Create xml file for configuring ldap"

echo "<Nodes>" > $BASEDIR/ldap.xml
for node in $oam_bsc;do
  echo "<Node>" >> $BASEDIR/ldap.xml
  echo "<nodeFdn>NetworkElement=$node</nodeFdn>" >> $BASEDIR/ldap.xml
  echo "<tlsMode>LDAPS</tlsMode>" >> $BASEDIR/ldap.xml
  echo "<userLabel>ENM</userLabel>" >> $BASEDIR/ldap.xml
  echo "<useTls>true</useTls>" >> $BASEDIR/ldap.xml
  echo "</Node>" >> $BASEDIR/ldap.xml
done
echo "</Nodes>" >> $BASEDIR/ldap.xml

echo "INFO: Configure ldap"

ldap_issue_cmd=$($CLI_APP_CMD "secadm ldap configure --xmlfile file:ldap.xml" $BASEDIR/ldap.xml)

if [[ "$ldap_issue_cmd" == *"uccessful"* ]];then
   echo "$ldap_issue_cmd"
else
  echo "ERROR: Command to configure ldap has failed!"
  exit 1
fi

echo "INFO: Waiting for completion of ldap configuration workflow (240 sec)"
sleep 240

echo "INFO: Checking ldap configuration of BSC nodes"

for node in $oam_bsc;do
  ldap_status_cmd=$($CLI_APP_CMD "cmedit get SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SecM=1,UserManagement=1,LdapAuthenticationMethod=1,Ldap=1")
  ldap_id=$(echo "$ldap_status_cmd" | grep ldapId)
  ldap_ip=$(echo "$ldap_status_cmd" | grep ldapIpAddress)
  tls_mode=$(echo "$ldap_status_cmd" | grep tlsMode)
  if [[ $ldap_id != *"1"* ]] && [[ $ldap_ip == *"null"* ]] && [[ $tls_mode != *"LDAPS"* ]];then
    echo "ERROR: LDAP has not been properly configured for node $node"
    continue
  fi
  echo "INFO: Setting profile filter for node $node"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SecM=1,UserManagement=1,LdapAuthenticationMethod=1,Ldap=1 profileFilter=ERICSSON_FILTER"
  echo "INFO: Set the administrative status of LdapAuthenticationMethod to UNLOCKED for node $node"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SecM=1,UserManagement=1,LdapAuthenticationMethod=1 administrativeState=UNLOCKED"
  echo "INFO: Setting nodeCredential for CliTls of node $node"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SysM=1,CliTls=1 nodeCredential=\"ManagedElement=$node,SystemFunctions=1,SecM=1,CertM=1,NodeCredential=oamNodeCredential\""
  echo "INFO: Setting Trust Category for CliTls of node $node"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SysM=1,CliTls=1 trustCategory=\"ManagedElement=$node,SystemFunctions=1,SecM=1,CertM=1,TrustCategory=oamTrustCategory\""
  echo "INFO: Setting nodeCredential for FtpTlsServer of node $node"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SysM=1,FileTPM=1,FtpServer=1,FtpTlsServer=1 nodeCredential=\"ManagedElement=$node,SystemFunctions=1,SecM=1,CertM=1,NodeCredential=oamNodeCredential\""
  echo "INFO: Setting Trust Category for FtpTlsServer of node $node"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SysM=1,FileTPM=1,FtpServer=1,FtpTlsServer=1 trustCategory=\"ManagedElement=$node,SystemFunctions=1,SecM=1,CertM=1,TrustCategory=oamTrustCategory\""
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SysM=1,FileTPM=1,FtpServer=1,FtpTlsServer=1 port=990"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SysM=1,FileTPM=1,FtpServer=1,FtpTlsServer=1 minDataPort=30200"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SysM=1,FileTPM=1,FtpServer=1,FtpTlsServer=1 maxDataPort=30300"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SysM=1,NetconfTls=1 administrativeState=UNLOCKED"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SysM=1,CliTls=1 administrativeState=UNLOCKED"
  $CLI_APP_CMD "cmedit set SubNetwork=Europe,SubNetwork=Ireland,SubNetwork=NETSimG,MeContext=$node,ManagedElement=$node,SystemFunctions=1,SysM=1,FileTPM=1,FtpServer=1,FtpTlsServer=1 administrativeState=UNLOCKED"

$CLI_APP_CMD "secadm credentials update --ldapuser enable --nodelist $node"
$CLI_APP_CMD "cmedit get NetworkElement=$node,SecurityFunction=1,NetworkElementSecurity=1"
$CLI_APP_CMD "cmedit set NetworkElement=$node,BscConnectivityInformation=1 transportProtocol=TLS"
$CLI_APP_CMD "cmedit set NetworkElement=$node,BscConnectivityInformation=1 port=6513"
$CLI_APP_CMD "cmedit set NetworkElement=$node,BscConnectivityInformation=1 fileTransferProtocol=FTPS"
$CLI_APP_CMD "cmedit set NetworkElement=$node,CmNodeHeartbeatSupervision=1 active=true"
$CLI_APP_CMD "cmedit get NetworkElement=$node,CmFunction=1"


done


echo "OPERATIONS COMPLETED - $(date)"


