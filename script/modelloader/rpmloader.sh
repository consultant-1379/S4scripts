#!/bin/bash
#set -ex

source ./rpmloader_functions.sh

RPM_BACKUP_PARENT_DIR='/var/tmp/rpm_backup'
#ENM_SERVICES_DIR='/var/www/html/ENM_models'

[[ $# -eq 0 ]] && usage

while getopts "r:s:j:u:" option
do
  case "${option}"
  in
    r) RPM_URL_LIST=${OPTARG};;
#    s) SG_LIST=${OPTARG};;
    j) JIRA_ID=${OPTARG};;
    u) if [[ ${OPTARG} == "yes" ]];then
         ENM_SERVICES_DIR='/var/www/html/ENM_models_rhel7'
       else
         ENM_SERVICES_DIR='/var/www/html/ENM_models'
       fi
       ;;
    *) echo "Invalid input ${OPTARG}"; usage; exit 1 ;;
  esac
done

#echo $RPM_URL_LIST $SG_LIST $JIRA_ID

RPM_URL=$(check_rpm_url $RPM_URL_LIST)

if ! $RPM_URL; then
  echo  `date "+%F %T.%3N"`" ERROR  RPM URL $RPM_URL FAILED"  
  exit 1
fi

#for rpm_url in $RPM_URL_LIST; do
#  if ! wget -q --spider "$rpm_url"; then
#    if curl --output /dev/null --silent --head --fail "$rpm_url"; then
#      echo "URL exists: $rpm_url"
#    else
#      echo " ERROR  URL DOES NOT EXIST: $rpm_url"
#      exit 1
#    fi
#  fi
#done

echo -e "****************************************************************************\n"
echo -e "************************* SUMMARY OF RPM LOADING ***************************\n"
echo -e "JIRA TICKET: $JIRA_ID"
RPM_NAMES=$(get_rpm_names_from_rpm_url_list "$RPM_URL_LIST")
echo -e "LIST OR RPM TO BE LOADED: $RPM_NAMES"
#echo -e "LIST OF SERVICE GROUPS TO BE RESTARTED: $SG_LIST"
echo " "
echo -e "****************************************************************************\n"

echo `date "+%F %T.%3N"`" INFO  EXECUTING YUM REMOVE OF MODEL RPM FROM MS"
if ! yum remove -q -y $RPM_NAMES >/dev/null 2>&1;then
  echo `date "+%F %T.%3N"`" ERROR  YUM REMOVE OF MODEL RPM FROM MS HAS FAILED !"
  exit 1
fi

echo `date "+%F %T.%3N"`" INFO  BACKUP OLD RPM AND LOADING NEW RPM INTO REPO"
if ! backup_old_rpms_and_load_new_rpms_into_repo "$RPM_URL_LIST";then
  echo `date "+%F %T.%3N"`" ERROR  BACKUP OF OLD RPM HAS FAILED !"
  exit 1
fi

echo `date "+%F %T.%3N"`" INFO  EXECUTING YUM INSTALL OF MODEL RPM ON MS"

if ! yum install -q -y $RPM_NAMES >/dev/null 2>&1;then
    echo `date "+%F %T.%3N"`" ERROR  YUM INSTALL OF MODEL RPM HAS FAILED !"
fi

#INSTALL_MODEL_RPM=$(yum install -y $RPM_NAMES)

echo `date "+%F %T.%3N"`" INFO  RUN LAYOUT SCRIPT WHICH WILL SETUP MODEL JARS"

JAR_FILES=$(find /var/opt/ericsson/ERICmodeldeployment/data/install/ -type f -name "*.jar")

if [ ! -z "$JAR_FILES" ];then
  if ! /opt/ericsson/nms/litp/etc/mcollective/mcollective/agent/create_modelRpm_deployment_layout.sh /var/opt/ericsson/ERICmodeldeployment/data/install/ >/dev/null 2>&1;then
    echo `date "+%F %T.%3N"`" ERROR  PROCESSING OF MODEL JAR FILE HAS FAILED !"
    exit 1
  fi
else
  JAR_FILES=$(find /var/opt/ericsson/ERICmodeldeployment/data/post_install/ -type f -name "*.jar")
  if [ ! -z "$JAR_FILES" ];then
    if ! /opt/ericsson/nms/litp/etc/mcollective/mcollective/agent/create_modelRpm_deployment_layout.sh /var/opt/ericsson/ERICmodeldeployment/data/post_install/ >/dev/null 2>&1;then
      echo `date "+%F %T.%3N"`" ERROR  PROCESSING OF MODEL JAR FILE HAS FAILED !"
      rm -rf /etc/opt/ericsson/ERICmodeldeployment/data/execution/toBeInstalled/* 
      exit 1
    fi
  else
    echo `date "+%F %T.%3N"`" ERROR  MODEL JAR FILE NOT PRESENT !"
    rm -rf /etc/opt/ericsson/ERICmodeldeployment/data/execution/toBeInstalled/*
    exit 1
  fi
fi

echo `date "+%F %T.%3N"`" INFO  GETTING DB HOST WHERE MODEL DEPLOYMENT IS RUNNING"

MODEL_DEPLOYMENT_HOST=$(/opt/ericsson/enminst/bin/vcs.bsh --groups | grep modeldeployment | grep ONLINE | awk '{print $3}')

if [ -z "$MODEL_DEPLOYMENT_HOST" ];then
  echo `date "+%F %T.%3N"`" ERROR  GETTING DB HOST WHERE MODEL DEPLOYMENT IS RUNNING!"
  rm -rf /etc/opt/ericsson/ERICmodeldeployment/data/execution/toBeInstalled/*
  exit 1
fi

curr_date=$(date "+%Y-%m-%d %H:%M")

echo `date "+%F %T.%3N"`" INFO  RUNNING MODEL DEPLOYMENT TOOL (MDT) ON HOST $MODEL_DEPLOYMENT_HOST"

if ! RUN_MDT=$(/root/rvb/bin/ssh_to_vm_and_su_root.exp $MODEL_DEPLOYMENT_HOST 'java -cp "/opt/ericsson/ERICmodeldeploymentclient/lib/*" com.ericsson.oss.itpf.modeling.model.deployment.client.main.ModelDeploymentClientStart /etc/opt/ericsson/ERICmodeldeployment/data/execution/toBeInstalled');then

  echo `date "+%F %T.%3N"`" ERROR  INSTALLATION OF MODELS FAILED! "
  rm -rf /etc/opt/ericsson/ERICmodeldeployment/data/execution/toBeInstalled/*
  exit 1
else
  rm -rf /etc/opt/ericsson/ERICmodeldeployment/data/execution/toBeInstalled/*
fi

if [[ "$RUN_MDT" == *"Error"* ]] || [[ "$RUN_MDT" == *"ERROR"* ]]; then
  echo "$RUN_MDT"
  echo "echo `date "+%F %T.%3N"`" ERROR  INSTALLATION OF MODELS FAILED! PLEASE CHECK /var/log/mdt.log FILE ON HOST $MODEL_DEPLOYMENT_HOST""
#  /root/rvb/bin/ssh_to_vm_and_su_root.exp $MODEL_DEPLOYMENT_HOST 'tail -80 /var/log/mdt.log'
  /root/rvb/bin/ssh_to_vm_and_su_root.exp $MODEL_DEPLOYMENT_HOST "sed -n '/^$curr_date/, \$p' /var/log/mdt.log" 2> /dev/null
  exit 1
else
  echo `date "+%F %T.%3N"`" INFO  MODELS HAVE BEEN SUCCESSFULLY INSTALLED"
  echo `date "+%F %T.%3N"`" INFO  CHECK ALSO BELOW OUTPUT OF mdt.log FILE FOR MORE INFO"
  /root/rvb/bin/ssh_to_vm_and_su_root.exp $MODEL_DEPLOYMENT_HOST "sed -n '/^$curr_date/, \$p' /var/log/mdt.log" 2> /dev/null
  echo `date "+%F %T.%3N"`" INFO  REMOVING PROCESSED MODEL FILES FROM LMS DIR /etc/opt/ericsson/ERICmodeldeployment/data/execution/toBeInstalled/"
  if ! rm -rf /etc/opt/ericsson/ERICmodeldeployment/data/execution/toBeInstalled/*;then
    echo `date "+%F %T.%3N"`" WARNING  REMOVAL OF PROCESSED MODEL FILES FROM LMS FAILED !"
    exit 0
  fi
fi
