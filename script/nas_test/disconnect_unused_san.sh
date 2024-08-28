#!/bin/bash

DEPLOYMENT_ID=$1

. ./nas_functions_lib.sh


##MAIN

setVars

echo "INFO" "Check nas disk info"
nas_disk_info=$(checkNasDiskInfo $SFSSETUP_USERNAME $SFSSETUP_PASSWORD $SFS_CONSOLE_IP)
echo "$nas_disk_info"

echo "INFO" "Check allocation of enclosures"
echo "$nas_disk_info" > nas_disk_info.txt
lun_to_remove=""

while read -r line;do
  if [[ "$line" == *"emc"* ]];then
    if [[ "$line" != *"ENM"* ]] && [[ "$line" != *"ENIQ"* ]] && [[ "$line" != *"Private_CFG_Do_Not_Use"* ]] && [[ "$line" != *"coordinator"* ]];then
      lun_to_remove="$lun_to_remove$line\n"
    fi
  fi
done < nas_disk_info.txt

if [ ! -z "$lun_to_remove" ];then
  echo "WARNING" "Following LUN(s) have to be removed as they are not used before continuing migration !"
  echo -e "$lun_to_remove"
  exit 1
else
  echo "INFO" "No unused LUN are present. Migration can continue"
fi
