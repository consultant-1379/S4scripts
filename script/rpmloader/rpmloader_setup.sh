#!/bin/bash
source ./rpmloader_functions.sh

SCRIPT_DIRECTORY='/var/tmp/myscripts/rpm_loader_lib_version'

[[ $# -eq 0 ]] && usage

while getopts "r:s:j:m:o:u:" option
do
  case "${option}"
  in
    r) RPM_URL_LIST=${OPTARG};;
    s) SG_LIST=${OPTARG};;
    j) JIRA_ID=${OPTARG};;
    m) MS_IP=${OPTARG};;
    o) OFFLINE_MODE=${OPTARG};;
    u) ENM_SERVICES_DIR=${OPTARG};; 
    :) echo "Option -${OPTARG} requires an argument."; exit 1;;
    *) echo "Invalid input ${OPTARG}"; usage; exit 1 ;;
  esac
done

#if [ -d "$SCRIPT_DIRECTORY" ]; then
#  rm -rf $SCRIPT_DIRECTORY
#  echo `date "+%F %T.%3N"`" INFO  DELETING EXISTING DIRECTORY $SCRIPT_DIRECTORY"
#fi
echo `date "+%F %T.%3N"`" INFO  CREATING DIRECTORY $SCRIPT_DIRECTORY AND COPYING SCRIPT FILES"
#sshpass -p '12shroot' ssh -q root@$MS_IP "sudo mkdir -p $SCRIPT_DIRECTORY"
#sshpass -p '12shroot' ssh -q root@$MS_IP "sudo chmod 777 $SCRIPT_DIRECTORY" 
#sshpass -p "12shroot" scp -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r *.sh root@$MS_IP:$SCRIPT_DIRECTORY/

#ssh -q root@$MS_IP "sudo mkdir -p $SCRIPT_DIRECTORY"
#ssh -q root@$MS_IP "sudo chmod 777 $SCRIPT_DIRECTORY"
#scp -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r *.sh root@$MS_IP:$SCRIPT_DIRECTORY/

ssh -q root@$MS_IP "mkdir -p $SCRIPT_DIRECTORY"
ssh -q root@$MS_IP "chmod 777 $SCRIPT_DIRECTORY"
scp -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r *.sh root@$MS_IP:$SCRIPT_DIRECTORY/

#cp *.sh $SCRIPT_DIRECTORY/.

echo `date "+%F %T.%3N"`" INFO  LAUNCHING rpmloader.sh SCRIPT"
if [[ "$OFFLINE_MODE" == "yes" ]]; then
  echo `date "+%F %T.%3N"`" INFO  LAUNCHING rpmloader.sh SCRIPT IN OFFLINE MODE"
#  sshpass -p '12shroot' ssh -q root@$MS_IP "cd $SCRIPT_DIRECTORY;./rpmloader.sh -r \"$RPM_URL_LIST\" -s \"$SG_LIST\" -j $JIRA_ID -o yes"
else
  echo `date "+%F %T.%3N"`" INFO  LAUNCHING rpmloader.sh SCRIPT IN NORMAL MODE"
fi  
#sshpass -p '12shroot' ssh -q root@$MS_IP "cd $SCRIPT_DIRECTORY;./rpmloader.sh -r \"$RPM_URL_LIST\" -s \"$SG_LIST\" -j $JIRA_ID -o $OFFLINE_MODE"

ssh -q root@$MS_IP "cd $SCRIPT_DIRECTORY;./rpmloader.sh -r \"$RPM_URL_LIST\" -s \"$SG_LIST\" -j $JIRA_ID -o $OFFLINE_MODE -u $ENM_SERVICES_DIR"

RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo success
else
  echo failed
  exit 1
fi

