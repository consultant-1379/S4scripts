#!/bin/bash

get_rpm_names_from_rpm_url_list() {
    RPM_URL_LIST="$1"
    RPM_NAMES=''
    for RPM_URL in $RPM_URL_LIST
    do
        RPM_NAME=$(echo "${RPM_URL}" | awk -F"/" '{print $NF}' | awk -F '-' '{print $1}')
        RPM_NAMES="$RPM_NAMES $RPM_NAME"
    done
    echo "$RPM_NAMES"
}


if [ $# -eq 0 ]; then
#  echo "Missing parameter! Usage ./rpm_loader.sh <csv filename>"
  echo "Missing parameter! Usage ./rpm_loader.sh -r <rpm_list> -s <sg_list> -j <jira_id>"
  exit 1
fi 

#CSV_FILE=$1

SCRIPT_PATH="/root/rvb/bin/teaas/s4/rpmloadercloud"

declare -a RPMS_LIST
declare -a SERVICE_GROUPS_LIST
declare -a JIRA_ID_LIST

clear

let i=0

#if [ -f $CSV_FILE ]; then
#   while IFS=, read -r RPMS SERVICE_GROUPS JIRA_ID
#   do
#      RPMS_LIST[i]="${RPMS}"
#      SERVICE_GROUPS_LIST[i]="${SERVICE_GROUPS}"
#      JIRA_ID_LIST[i]="${JIRA_ID}"
#      ((++i))
#   done < $CSV_FILE
#else
#   echo "$CSV_FILE not found!"
#fi

while getopts "r:s:j:" option
do
  case "${option}"
  in
    r) RPMS_LIST=${OPTARG};;
    s) SERVICE_GROUPS_LIST=${OPTARG};;
    j) JIRA_ID_LIST=${OPTARG};;
    *) echo "Invalid input ${OPTARG}"; echo "Missing parameter! Usage ./rpm_loader.sh -r <rpm_list> -s <sg_list> -j <jira_id>"; exit 1 ;;
  esac
done

echo $RPMS_LIST $SERVICE_GROUPS_LIST $JIRA_ID_LIST


let i==0

#for ((i=0; i<${#RPMS_LIST[@]}; i++)); do
#    echo -e "${RPMS_LIST[i]}"
#    echo -e "${SERVICE_GROUPS_LIST[i]}"
#    echo -e "${JIRA_ID_LIST[i]}"
#done

for ((i=0; i<${#RPMS_LIST[@]}; i++)); do
#    echo -e "${RPMS_LIST[i]}"
    URLS="${RPMS_LIST[i]}"
    for url in $URLS; do

#       url="${RPMS_LIST[i]}"
       if ! wget -q --spider "$url"; then
          if curl --output /dev/null --silent --head --fail "$url"; then
             echo "URL exists: $url"
          else
             echo " ERROR  URL DOES NOT EXIST: $url"
             exit 1
          fi
       fi
    done
done

    echo -e "****************************************************************************\n"
    echo -e "************************* SUMMARY OF RPM LOADING ***************************\n"

let i==0

for ((i=0; i<${#JIRA_ID_LIST[@]}; i++)); do
    
    echo -e "JIRA TICKET: ${JIRA_ID_LIST[i]}"
#    echo "${RPMS_LIST[i]}"
    RPM_NAMES=$(get_rpm_names_from_rpm_url_list "${RPMS_LIST[i]}")
    echo -e "LIST OR RPM TO BE LOADED: $RPM_NAMES"
    echo -e "LIST OF SERVICE GROUPS TO BE RESTARTED: ${SERVICE_GROUPS_LIST[i]}"
    echo " "
done

echo -e "****************************************************************************\n"

let i==0

for ((i=0; i<${#JIRA_ID_LIST[@]}; i++)); do
    echo `date "+%F %T.%3N"`" INFO  BEGIN PROCESSING OF RPM LOADING FOR JIRA ${JIRA_ID_LIST[i]}"
#    echo "${RPMS_LIST[i]}"
    sudo sh -x $SCRIPT_PATH/copyrpmtoyum_cloud.sh "${JIRA_ID_LIST[i]}" "${RPMS_LIST[i]}"
    echo `date "+%F %T.%3N"`" INFO  END PROCESSING OF RPM LOADING FOR JIRA ${JIRA_ID_LIST[i]}"
done

#if [ -f $CSV_FILE ]; then
#   while IFS=, read -r RPMS SERVICE_GROUPS JIRA_ID
#   do
#      echo `date "+%F %T.%3N"`" INFO  BEGIN PROCESSING OF RPM LOADING FOR JIRA $JIRA_ID"
#      sh ./copyrpmtoyum.sh $JIRA_ID $RPMS
#      echo `date "+%F %T.%3N"`" INFO  END PROCESSING OF RPM LOADING FOR JIRA $JIRA_ID"
#   done < $CSV_FILE
#else
#   echo "$CSV_FILE not found!"
#fi

let i==0

for ((i=0; i<${#JIRA_ID_LIST[@]}; i++)); do
    echo `date "+%F %T.%3N"`" INFO  BEGIN PROCESSING OF SG RESTART FOR JIRA ${JIRA_ID_LIST[i]}"
#    echo "${SERVICE_GROUPS_LIST[i]}"
    SERVICE_GROUPS="${SERVICE_GROUPS_LIST[i]}"
   sudo sh -x $SCRIPT_PATH/apply_services_rpm_cloud.sh -g "${SERVICE_GROUPS_LIST[i]}" -i ${JIRA_ID_LIST[i]}

done


#if [ -f $CSV_FILE ]; then
#   while IFS=, read -r RPMS SERVICE_GROUPS JIRA_ID
#   do
#      echo `date "+%F %T.%3N"`" INFO  BEGIN PROCESSING OF SG RESTART FOR JIRA $JIRA_ID"
#      sh ./apply_services_rpms_new.sh -g "$SERVICE_GROUPS" -i "$JIRA_ID"&
#   done < $CSV_FILE
#else
#   echo "$CSV_FILE not found!"
#fi
