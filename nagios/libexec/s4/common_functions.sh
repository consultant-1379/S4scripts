#!/bin/bash -x

execute_ssh_cmd_wkl() {
  
  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  cmd="$4"

  sshpass -p 12shroot ssh -q nagios@$lms_ip "sudo ssh root@$wkl_vm_ip \"/opt/ericsson/enmutils/bin/cli_app '$cmd'\""
}

count_number_nodes_syn(){

  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  cmd="cmedit get * CmFunction.syncStatus==SYNCHRONIZED --neType=$netype -t"

  local number_nodes_syn
  number_nodes_syn=$(execute_ssh_cmd_wkl $lms_ip $wkl_vm_ip $netype "$cmd" | grep SYNCHRONIZED | wc -l)
  echo $"number_nodes_syn"
}

count_nodes_hb_fail() {

  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  cmd="cmedit get * FmFunction.currentServiceState==HEART_BEAT_FAILURE --neType=$ne_type -t"

  local nodes_hb_fail

  nodes_hb_fail=$(execute_ssh_cmd_wkl $lms_ip $wkl_vm_ip $netype "$cmd" | grep HEART_BEAT_FAILURE | wc -l)
  echo "$nodes_hb_fail"
}

count_number_nodes_enm() {

  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  cmd="cmedit get * NetworkElement.neType==$netype -t"
  local number_nodes_enm

  number_nodes_enm=$(execute_ssh_cmd_wkl $lms_ip $wkl_vm_ip $netype "$cmd" | grep -i $netype | wc -l)
  echo "$number_nodes_enm"
}

count_number_nodes_cmsuperv() {

  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  cmd="cmedit get * CmNodeHeartbeatSupervision.active==true -neType=$netype -t"
  local number_nodes_cmsuperv

  number_nodes_cmsuperv=$(execute_ssh_cmd_wkl $lms_ip $wkl_vm_ip $netype "$cmd" | grep true | wc -l)
  echo "$number_nodes_cmsuperv"
}

count_number_nodes_fmsuperv() {

  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  cmd="cmedit get * FmAlarmSupervision.active -neType=$netype -t"

  number_nodes_fmsuperv=$(execute_ssh_cmd_wkl $lms_ip $wkl_vm_ip $netype "$cmd" | grep true | wc -l)
  echo "$number_nodes_fmsuperv"
}

count_number_nodes_pmsuperv() {

  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  cmd="cmedit get * PmFunction.pmEnabled==true -neType=$netype -t"
  local number_nodes_pmsuperv

  number_nodes_pmsuperv=$(execute_ssh_cmd_wkl $lms_ip $wkl_vm_ip $netype "$cmd" | grep true | wc -l)
  echo "$number_nodes_pmsuperv"
}

count_number_nodes_syn() {

  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  cmd="cmedit get * CmFunction.syncStatus==SYNCHRONIZED --neType=$netype -t"
  local number_nodes_pmsuperv

  number_nodes_syn=$(execute_ssh_cmd_wkl $lms_ip $wkl_vm_ip $netype "$cmd" | grep SYNCHRONIZED | wc -l)
  echo "$number_nodes_syn"
}

count_number_nodes_unsyn() {

  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  cmd="cmedit get * CmFunction.syncStatus!=SYNCHRONIZED --neType=$netype -t"
  local number_nodes_pmsuperv

  number_nodes_syn=$(execute_ssh_cmd_wkl $lms_ip $wkl_vm_ip $netype "$cmd" | grep SYNCHRONIZED | wc -l)
  echo "$number_nodes_syn"
}

count_nodes_hb_fail() {

  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  cmd="cmedit get * FmFunction.currentServiceState==HEART_BEAT_FAILURE --neType=$netype -t"
  local nodes_hb_fail

  nodes_hb_fail=$(execute_ssh_cmd_wkl $lms_ip $wkl_vm_ip $netype "$cmd" | grep HEART_BEAT_FAILURE | wc -l)
  echo "$nodes_hb_fail"
}

get_deployment_id_from_ms_ip(){

  lms_ip=$1
  case "$lms_ip" in

    141.137.208.23)  echo "623"
    ;;
    131.160.170.194)  echo  "429"
    ;;
    10.210.245.3)  echo  "660"
    ;;
    *) echo "ERROR: Unrecognized deployment !"
    ;;
  esac


}

count_number_nodes_netsim_files() {

  lms_ip=$1
  wkl_vm_ip=$2
  netype=$3
  local number_nodes_netsim_files

case "$netype" in

  MSC-BC-BSP)
    netype=" MSC-BC-BSP" 
    ;;
  MSC-BC-IS)  
    netype=" MSC-BC-IS"
    ;;
  MSC-DB-BSP)  
    netype=" MSC-DB-BSP"
    ;;
  FRONTHAUL-6080)
    netype="Fronthaul-6080"
    ;;
  SGSN-MME)
    netype="SGSN"
    ;;
  MINI-LINK-Indoor)
    netype="MLTN"
    ;;
  CISCO-ASR900)
    netype="CISCO"
    ;;
esac
  
#  number_nodes_netsim_files=$(sshpass -p 12shroot ssh -q nagios@$lms_ip "sudo ssh root@$wkl_vm_ip \"grep -w \'$netype\' /opt/ericsson/enmutils/etc/nodes/*\" | awk -F \":\" '{print \$2}' | awk -F \",\" '{print \$1}' | sort | uniq | wc -l")


	if [ $netype == 'EPG' ]; then # EPG-OI excluded from counting 	
    number_nodes_netsim_files=$(sshpass -p 12shroot ssh -q nagios@$lms_ip "sudo ssh root@$wkl_vm_ip 'grep -w \"$netype\" /opt/ericsson/enmutils/etc/nodes/*'" | awk -F ":" '{print $2}' | sort | uniq | grep -v 'EPG-OI' | wc -l)
		echo "$number_nodes_netsim_files"
    exit		
	fi

  number_nodes_netsim_files=$(sshpass -p 12shroot ssh -q nagios@$lms_ip "sudo ssh root@$wkl_vm_ip 'grep -w \"$netype\" /opt/ericsson/enmutils/etc/nodes/*'" | awk -F ":" '{print $2}' | awk -F "," '{print $1}' | sort | uniq | wc -l)
  echo "$number_nodes_netsim_files"
}

