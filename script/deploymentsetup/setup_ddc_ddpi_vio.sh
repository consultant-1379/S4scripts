#!/bin/bash

#FUNCTION TO CONNECT TO A VM

execute_cmd_on_vm() {
   
  local vm
  local cmd
  vm=$1
  cmd="$2"
  /root/rvb/bin/ssh_to_vm_and_su_root.exp $vm $cmd
  
}

get_enm_vm() {
  local enm_vm
  local enm_vm_to_get
  enm_vm_to_get=$1
  enm_vm=$(/usr/bin/consul members list | grep $enm_vm_to_get | awk '{print \$1}')
  echo $enm_vm
}

remove_existing_ssh_key() {
  local cmd
  local enm_vm
  enm_vm=$1
  cmd="rm -f ~/.ssh/id_rsa"
  execute_cmd_on_vm $enm_vm $cmd
}

create_new_ssh_key() {
  local cmd
  local enm_vm
  enm_vm=$1
  cmd="/usr/bin/ssh-keygen -b 2048 -t rsa -f .ssh/id_rsa -q -N \"\""
  execute_cmd_on_vm $enm_vm $cmd

}

cp_rvb_script_rsa_key_to_remote_host() {
  local enm_vm
  enm_vm=$1
  scp -i /var/tmp/<pem_key> /root/rvb/copy-rsa-key-to-remote-host.exp cloud-user@$enm_vm:/tmp

}


#GET ESMON VM
enm_vm=$(get_enm_vm esmon)

#CONNECT TO ESMON VM AND CREATE KEY
#IT IS NECESSARY FIRST TO REMOVE EXISTING KEY (IF PRESENT)

remove_existing_ssh_key $enm_vm

create_new_ssh_key $enm_vm









