#!/bin/bash

#set -x

source ./functions.sh

RPM_BACKUP_PARENT_DIR='/var/tmp/rpm_backup'
ENM_SERVICES_DIR='/var/www/html/ENM_services'

[[ $# -eq 0 ]] && usage

while getopts "r:s:j:o:" option
do
  case "${option}"
  in
    r) RPMS_URL_LIST_W_REPO=${OPTARG};;
    s) SG_LIST=${OPTARG};;
    j) JIRA_ID=${OPTARG};;
    o) OFFLINE_MODE=${OPTARG};;
    *) echo "Invalid input ${OPTARG}"; usage; exit 1 ;;
  esac
done

echo $RPMS_URL_LIST_W_REPO $SG_LIST $JIRA_ID

#DEF_IFS=$IFS
#IFS="@"

RPMS_URL_LIST_W_REPO=$(echo $RPMS_URL_LIST_W_REPO | sed "s/@@/ /g")


for rpm_url_list_w_repo in "$RPMS_URL_LIST_W_REPO";do
#  echo $RPMS_URL_LIST_W_REPO | awk -F"::" '{print $2}' | awk '{print $1}'
   echo $rpm_url_list_w_repo
done

#IFS=$DEF_IFS

exit


message_log INFO "CHECKING THAT RPM URL ARE VALID"

for rpm_url in $RPM_URL_LIST;do
  
  if ! check_rpm_url $rpm_url;then
    echo  `date "+%F %T.%3N"`" ERROR  RPM URL $rpm_url FAILED"
    exit 1
  fi  

#  check_rpm_url $rpm_url
#  rvalue=$?
#  echo $rvalue

#  if [[ $rvalue -eq 1 ]];then
#    echo  `date "+%F %T.%3N"`" ERROR  RPM URL $rpm_url FAILED"  
#    exit 1
#  fi
done

for sg_name in $SG_LIST;do

  if ! check_sg_name_cloud $sg_name;then
    echo  `date "+%F %T.%3N"`" ERROR  SG $sg_name NOT FOUND"
    exit 1
  fi  

#  check_sg_name_cloud $sg_name
#  rvalue=$?

#  if [[ $rvalue -eq 1 ]]; then
#    echo  `date "+%F %T.%3N"`" ERROR  SG $sg_name NOT FOUND"
#    exit 1
#  fi
done




exit

echo -e "************************* SUMMARY OF RPM LOADING ***************************\n"
echo -e "JIRA TICKET: $JIRA_ID"
RPM_NAMES=$(get_rpm_names_from_rpm_url_list "$RPM_URL_LIST")
echo -e "LIST OR RPM TO BE LOADED: $RPM_NAMES"
echo -e "LIST OF SERVICE GROUPS TO BE RESTARTED: $SG_LIST"
echo " "
echo -e "****************************************************************************\n"

echo `date "+%F %T.%3N"`" INFO  BACKUP OLD RPM AND LOADING NEW RPM INTO REPO"
if [[ "$OFFLINE_MODE" != "yes" ]]; then
  if ! backup_old_rpms_and_load_new_rpms_into_repo "$RPM_URL_LIST"; then
    exit 1
  fi
  echo `date "+%F %T.%3N"`" INFO  BACKUP OLD RPM AND LOADING NEW RPM INTO REPO SUCCESSFULLY COMPLETED"
else
  echo `date "+%F %T.%3N"`" INFO  BACKUP OLD RPM AND LOADING NEW RPM INTO REPO SUCCESSFULLY COMPLETED"
fi

echo -e "\n"
echo `date "+%F %T.%3N"`" INFO  BEGIN PROCESSING OF RPM LOADING FOR JIRA $JIRA_ID"

short_name_service_group_list=$SG_LIST

echo $short_name_service_group_list

for short_name_service_group in $short_name_service_group_list; do
  full_name_service_group_list=$(get_full_name_service_group_list "$short_name_service_group")
  blades=$(get_list_of_blades_where_vms_must_be_undefined "$short_name_service_group")
  echo $full_name_service_group_list
  echo $blades
  if [ -z $full_name_service_group_list ]; then
     exit 1
  else
    echo `date "+%F %T.%3N"`" INFO  PROCESSING SERVICE GROUP $short_name_service_group"
    vm=$(echo $full_name_service_group_list | sed -e 's/Grp_CS_svc_cluster_\(.*\)/\1/g')
    for blade in $blades; do
      echo  `date "+%F %T.%3N"`" INFO  OFFLINE SG $full_name_service_group_list ON BLADE $blade"
      if [[ "$OFFLINE_MODE" == "yes" ]]; then
         echo  `date "+%F %T.%3N"`" INFO  UNDEFINE VM $vm ON BLADE $blade"
	 echo  `date "+%F %T.%3N"`" INFO  ONLINE SG $full_name_service_group_list ON BLADE $blade"
      else
        if ! offline_service_groups "$full_name_service_group_list" "$blade"; then
          echo  `date "+%F %T.%3N"`" INFO  OFFLINE OF SERVICE GROUP $full_name_service_group_list ON BLADE $blade FAILED"
          echo  `date "+%F %T.%3N"`" INFO  IT WILL BE NEEDED TO ROLLBACK RPM $full_name_service_group_list"
#         break 1
          exit 1
        else
          echo  `date "+%F %T.%3N"`" INFO  UNDEFINE VM $vm ON BLADE $blade"
          if ! undefine_vms_on_blades "$blade" "$vm"; then
            echo  `date "+%F %T.%3N"`" INFO  UNDEFINE OF VM $vm ON BLADE $blade FAILED"
            echo  `date "+%F %T.%3N"`" INFO  IT WILL BE NEEDED TO ROLLBACK RPM $full_name_service_group_list"
#           break 1
            exit 1
          else
            echo  `date "+%F %T.%3N"`" INFO  ONLINE SG $full_name_service_group_list ON BLADE $blade"
            if ! online_service_groups "$full_name_service_group_list" "$blade"; then
              echo  `date "+%F %T.%3N"`" INFO  ONLINE OF SERVICE GROUP $full_name_service_group_list ON BLADE $blade FAILED"
              echo  `date "+%F %T.%3N"`" INFO  STOPPING RESTARTING OF SERVICE GROUP $full_name_service_group_list" 
              echo  `date "+%F %T.%3N"`" INFO  IT WILL BE NEEDED TO ROLLBACK RPM $full_name_service_group_list"
#             break 1
             exit 1
            fi
          fi
        fi
      fi	
    done
  fi
done
echo `date "+%F %T.%3N"`" INFO  PROCESSING OF RPM LOADING FOR JIRA $JIRA_ID SUCCESSFULLY COMPLETED"
