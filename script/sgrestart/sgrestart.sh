#!/bin/bash
source ./rpmloader_functions.sh

#RPM_BACKUP_PARENT_DIR='/var/tmp/rpm_backup'
#ENM_SERVICES_DIR='/var/www/html/ENM_services'

[[ $# -eq 0 ]] && usage

while getopts "u:s:j:o:" option
do
  case "${option}"
  in
#    r) RPM_URL_LIST=${OPTARG};;
    s) SG_LIST=${OPTARG};;
    j) JIRA_ID=${OPTARG};;
    o) OFFLINE_MODE=${OPTARG};;
    u) UNDEFINE_VM=${OPTARG};;
    *) echo "Invalid input ${OPTARG}"; usage; exit 1 ;;
  esac
done

echo "$SG_LIST $JIRA_ID UNDEFINE VM: $UNDEFINE_VM" 

#RPM_URL=$(check_rpm_url $RPM_URL_LIST)

#if ! $RPM_URL; then
#  echo  `date "+%F %T.%3N"`" ERROR  RPM URL $RPM_URL FAILED"  
#  exit 1
#fi

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
echo -e "************************* SUMMARY OF SG RESTART ****************************\n"
echo -e "JIRA TICKET: $JIRA_ID"
#RPM_NAMES=$(get_rpm_names_from_rpm_url_list "$RPM_URL_LIST")
#echo -e "LIST OR RPM TO BE LOADED: $RPM_NAMES"
echo -e "LIST OF SERVICE GROUPS TO BE RESTARTED: $SG_LIST"
echo -e "UNDEFINE VM: $UNDEFINE_VM"
echo " "
echo -e "****************************************************************************\n"

#echo `date "+%F %T.%3N"`" INFO  BACKUP OLD RPM AND LOADING NEW RPM INTO REPO"
#if [[ "$OFFLINE_MODE" != "yes" ]]; then
#  if ! backup_old_rpms_and_load_new_rpms_into_repo "$RPM_URL_LIST"; then
#    exit 1
#  fi
#  echo `date "+%F %T.%3N"`" INFO  BACKUP OLD RPM AND LOADING NEW RPM INTO REPO SUCCESSFULLY COMPLETED"
#else
#  echo `date "+%F %T.%3N"`" INFO  BACKUP OLD RPM AND LOADING NEW RPM INTO REPO SUCCESSFULLY COMPLETED"
#fi

echo -e "\n"
echo `date "+%F %T.%3N"`" INFO  BEGIN PROCESSING OF SG RESTART FOR JIRA $JIRA_ID"

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
	 if [[ "$UNDEFINE_VM" == "yes" ]]; then
           echo  `date "+%F %T.%3N"`" INFO  UNDEFINE VM $vm ON BLADE $blade"
         fi
	   echo  `date "+%F %T.%3N"`" INFO  ONLINE SG $full_name_service_group_list ON BLADE $blade"
      else
        if ! offline_service_groups "$full_name_service_group_list" "$blade"; then
          echo  `date "+%F %T.%3N"`" INFO  OFFLINE OF SERVICE GROUP $full_name_service_group_list ON BLADE $blade FAILED"

#         break 1
          exit 1
        else
	  if [[ "$UNDEFINE_VM" == "yes" ]]; then
            echo  `date "+%F %T.%3N"`" INFO  UNDEFINE VM $vm ON BLADE $blade"
            if ! undefine_vms_on_blades "$blade" "$vm"; then
              echo  `date "+%F %T.%3N"`" INFO  UNDEFINE OF VM $vm ON BLADE $blade FAILED"

#             break 1
              exit 1
#            fi
#          fi   
            else
              echo  `date "+%F %T.%3N"`" INFO  ONLINE SG $full_name_service_group_list ON BLADE $blade"
              if ! online_service_groups "$full_name_service_group_list" "$blade"; then
                echo  `date "+%F %T.%3N"`" INFO  ONLINE OF SERVICE GROUP $full_name_service_group_list ON BLADE $blade FAILED"
                echo  `date "+%F %T.%3N"`" INFO  STOPPING RESTARTING OF SERVICE GROUP $full_name_service_group_list" 

#             break 1
                exit 1
              fi
            fi
          fi
        fi
      fi	
    done
  fi
done
echo `date "+%F %T.%3N"`" INFO  PROCESSING OF SG RESTART FOR JIRA $JIRA_ID SUCCESSFULLY COMPLETED"
