#!/bin/bash

RPM_BACKUP_PARENT_DIR='/var/tmp/rpm_backup'
ENM_SERVICES_DIR='/ericsson/www/html/enm/repos/ENM/services'
JIRA_ID=$1
RPM_URL_LIST=$2


create_backup_directory() {
    JIRA_ID=$1
    TIMESTAMP=$(date '+%Y_%m_%d_%H:%M:%S')
    BACKUP_DIR=$RPM_BACKUP_PARENT_DIR/$JIRA_ID/$TIMESTAMP
    mkdir -p "$BACKUP_DIR"
    echo "$BACKUP_DIR"
}

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

move_old_rpms_to_backup_directory() {
    BACKUP_DIR=$1
    RPM_NAMES="$2"
    SOURCE_FILE_PATHS=''
    for RPM_NAME in $RPM_NAMES
    do
        SOURCE_FILE_PATH="$ENM_SERVICES_DIR/$RPM_NAME*"
        SOURCE_FILE_PATHS="$SOURCE_FILE_PATHS $SOURCE_FILE_PATH"
    done

#    mv --verbose -t $BACKUP_DIR $SOURCE_FILE_PATHS > /dev/null
    CMD_SILENT=$(scp -i /var/tmp/private_key.pem cloud-user@repo:"$SOURCE_FILE_PATHS" "$BACKUP_DIR")
    CMD_SILENT=$(/root/rvb/bin/ssh_to_vm_and_su_root.exp repo "rm -rf $SOURCE_FILE_PATHS")
}

move_old_rpms_to_enm_services_dir() {
    BACKUP_DIR=$1
    mv --verbose -t $ENM_SERVICES_DIR $BACKUP_DIR/* > /dev/null
}

load_new_rpms_into_repo() {
	JIRA_ID=$1
	RPM_URL_LIST=$2
	RPM_NAMES=$3
	TMP_RPMFILES=/tmp/$JIRA_ID
	rm -rf $TMP_RPMFILES
	mkdir -p $TMP_RPMFILES
	cd $TMP_RPMFILES
	CMD_SILENT=$(wget -q $RPM_URL_LIST)
    TARGET_FILE_PATHS=''
    for RPM_NAME in $RPM_NAMES
    do
        TARGET_FILE_PATH="$ENM_SERVICES_DIR/$RPM_NAME*"
        TARGET_FILE_PATHS="$TARGET_FILE_PATHS $TARGET_FILE_PATH"
    done
#	echo $TARGET_FILE_PATHS
	CMD_SILENT=$(/root/rvb/bin/ssh_to_vm_and_su_root.exp repo "mkdir -p $TMP_RPMFILES;chmod 777 $TMP_RPMFILES")
	CMD_SILENT=$(scp -i /var/tmp/private_key.pem $TMP_RPMFILES/*.rpm cloud-user@repo:$TMP_RPMFILES)
	CMD_SILENT=$(/root/rvb/bin/ssh_to_vm_and_su_root.exp repo "mv $TMP_RPMFILES/* $ENM_SERVICES_DIR;rm -rf $TMP_RPMFILES;/usr/bin/createrepo --update /ericsson/www/html/enm/;sleep 10;yum clean all")
#	rm -rf $TMP_RPMFILES
	

#    cd $ENM_SERVICES_DIR
#    if wget -q $RPM_URL_LIST
#    then
#       while pgrep -f "createrepo/worker.py" >/dev/null 2>&1 ; do
#           echo `date "+%F %T.%3N"`" INFO  createrepo IS ALREADY RUNNING WAITING .... "
#           sleep 15
#       done
#        createrepo . > /dev/null
#        yum clean all > /dev/null
#        return 0
#    else
#        return 1
#    fi
}

backup_old_rpms_and_load_new_rpms_into_repo() {
    RPM_URL_LIST="$1"
    BACKUP_DIR=$(create_backup_directory $JIRA_ID)
    RPM_NAMES=$(get_rpm_names_from_rpm_url_list "$RPM_URL_LIST")
    move_old_rpms_to_backup_directory $BACKUP_DIR "$RPM_NAMES"
    if ! load_new_rpms_into_repo $JIRA_ID "$RPM_URL_LIST" "$RPM_NAMES"
    then
        move_old_rpms_to_enm_services_dir $BACKUP_DIR
        return 1
    fi
    return 0
}

get_service_group_regex() {
    SHORT_NAME_SERVICE_GROUP_LIST="$1"
    SERVICE_GROUP_LIST_REGEX=''
    for SERVICE_GROUP in $SHORT_NAME_SERVICE_GROUP_LIST
    do
        if [ -z $SERVICE_GROUP_LIST_REGEX ]
        then
            SERVICE_GROUP_LIST_REGEX="_$SERVICE_GROUP "
        else
            SERVICE_GROUP_LIST_REGEX="$SERVICE_GROUP_LIST_REGEX|_$SERVICE_GROUP "
        fi
    done
    echo "$SERVICE_GROUP_LIST_REGEX"
}

get_full_name_service_group_list() {
    SHORT_NAME_SERVICE_GROUP_LIST="$1"
    SERVICE_GROUP_REGEX=$(get_service_group_regex "$SHORT_NAME_SERVICE_GROUP_LIST")
    FULL_NAME_SERVICE_GROUP_LIST=$(/opt/ericsson/enminst/bin/vcs.bsh --groups | egrep "$SERVICE_GROUP_REGEX" | awk '{print $2}' | sort | uniq)
    echo "$FULL_NAME_SERVICE_GROUP_LIST"
}


echo `date "+%F %T.%3N"`" INFO  BACKUP OLD RPM AND LOADING NEW RPM INTO REPO"
if ! backup_old_rpms_and_load_new_rpms_into_repo "$RPM_URL_LIST"
then
    exit 1
fi
echo `date "+%F %T.%3N"`" INFO  BACKUP OLD RPM AND LOADING NEW RPM INTO REPO SUCCESSFULLY COMPLETED"

 
