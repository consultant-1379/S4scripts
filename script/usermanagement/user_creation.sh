#!/bin/bash

is_user_created() {
  local lms_ip=$2
  local user=$1
  if [ -z $lms_ip ];then
    id -u $user >/dev/null 2>&1
  else
    ssh -o StrictHostKeyChecking=no root@$lms_ip "id -u $user" >/dev/null 2>&1
  fi
  return $?
}

change_user_passwd() {
  local lms_ip=$3
  local user=$1
  local password=$2
  if [ -z $lms_ip ];then
    echo $password | passwd --stdin $user >/dev/null 2>&1
  else
    ssh -o StrictHostKeyChecking=no root@$lms_ip "echo $password | passwd --stdin $user" >/dev/null 2>&1
  fi
  return $?
}

create_user() {
  local lms_ip=$3
  local user_type=$1
  local user=$2
  if [ -z $lms_ip ];then
    useradd -g $user_type -m $user >/dev/null 2>&1
  else
    ssh -o StrictHostKeyChecking=no root@$lms_ip "useradd -g $user_type -m $user" >/dev/null 2>&1
  fi
  return $?
}

delete_user() {
  local lms_ip=$2
  local user=$1
  if [ -z $lms_ip ];then
    pkill -9 -u $user;userdel -r $user >/dev/null 2>&1
  else
    ssh -o StrictHostKeyChecking=no root@$lms_ip "pkill -9 -u $user;userdel -r $user" >/dev/null 2>&1
  fi
  return $?
}

create_enm_user() {
  local user=$1
  local password=$2
  /opt/ericsson/enmutils/bin/user_mgr create $user $password ADMINISTRATOR
  return $?
}

delete_enm_user() {
  local user=$1
  /opt/ericsson/enmutils/bin/user_mgr delete $user
  return $?
}

banner() {
  cat << EOF
***********************************************************************************************
*                                                                                             *
*                               LMS/ENM USER MANAGEMENT SCRIPT                                *
*                                                                                             *
***********************************************************************************************
EOF
}

end_banner() {
  cat << EOF
***********************************************************************************************
*                                                                                             *
*                           LMS/ENM USER MANAGEMENT SCRIPT COMPLETED                          *
*                                                                                             *
***********************************************************************************************
EOF

}

#set -ex
set -x

[[ $# -eq 0 ]] && usage

while getopts "l:e:o:u:t:p:" option
do
  case "${option}"
  in
    l) lms_ip=${OPTARG};;
    e) env_type=${OPTARG};;
    o) cmd_user_option=${OPTARG};;
    u) user=${OPTARG};;
    t) user_type=${OPTARG};;
    p) password=${OPTARG};;
    *) echo "Invalid input ${OPTARG}"; usage; exit 1 ;;
  esac
done

#password=$(gpg --gen-random --armor 1 10)

banner

if [[ $cmd_user_option == "create" ]];then
  if [[ $env_type == "Physical" ]];then
#    echo  $(date "+%F %T.%3N")" INFO CHECKING IF UNIX USER $user IS ALREADY PRESENT IN WORKLOAD VM"
    if is_user_created $user;then
      echo $(date "+%F %T.%3N")" ERROR UNIX USER $user IS ALREADY PRESENT AND IT CANNOT BE CREATED IN WORKLOAD VM"
    else
      echo $(date "+%F %T.%3N")" INFO ADDING UNIX USER $user TO WORKLOAD VM"
      if ! create_user $user_type $user;then
        echo $(date "+%F %T.%3N")" ERROR UNIX USER $user CANNOT BE CREATED IN WORKLOAD VM"
      else
        if ! change_user_passwd $user "$password";then
          echo  $(date "+%F %T.%3N")" ERROR PASSWORD FOR UNIX USER $user CANNOT BE ASSIGNED IN WORKLOAD VM"
	fi
      fi
    fi
#    echo  $(date "+%F %T.%3N")" INFO CHECKING IF UNIX USER $user IS ALREADY PRESENT IN LMS"
    if is_user_created $user $lms_ip;then
      echo $(date "+%F %T.%3N")" ERROR UNIX USER $user IS ALREADY PRESENT AND IT CANNOT BE CREATED IN LMS"
    else
      echo $(date "+%F %T.%3N")" INFO ADDING UNIX USER $user TO LMS"
      if ! create_user $user_type $user $lms_ip;then
        echo  $(date "+%F %T.%3N")" ERROR UNIX USER $user CANNOT BE CREATED IN LMS"
      else
        if ! change_user_passwd $user "$password" $lms_ip;then
          echo  $(date "+%F %T.%3N")" ERROR PASSWORD FOR UNIX USER $user CANNOT BE ASSIGNED"
        fi
      fi
    fi

#  echo  $(date "+%F %T.%3N")" INFO CREATING ENM USER $user"
    if ! create_enm_user $user "$password";then
      echo  $(date "+%F %T.%3N")" ERROR ENM USER $user CANNOT BE CREATED"
    else
      echo  $(date "+%F %T.%3N")" INFO ENM USER $user HAS BEEN SUCCESSFULLY CREATED"
    fi
  fi
fi

if [[ $cmd_user_option == "delete" ]];then
  if [[ $env_type == "Physical" ]];then
    echo  $(date "+%F %T.%3N")" INFO CHECKING IF UNIX USER $user IS PRESENT IN LMS"
    if ! is_user_created $user $lms_ip;then
      echo  $(date "+%F %T.%3N")" ERROR UNIX USER $user IS NOT PRESENT IN LMS"
      end_banner
    else
      echo  $(date "+%F %T.%3N")" INFO DELETING UNIX USER $user IN LMS"
      if ! delete_user $user $lms_ip;then
        echo  $(date "+%F %T.%3N")" INFO UNIX USER $user CANNOT BE DELETED"
        end_banner
      fi
    fi
    echo  $(date "+%F %T.%3N")" INFO CHECKING IF UNIX USER $user IS PRESENT IN WORKLOAD VM"
    if ! is_user_created $user;then
      echo  $(date "+%F %T.%3N")" ERROR UNIX USER $user IS NOT PRESENT IN WORKLOAD VM"
      end_banner
    else
      echo  $(date "+%F %T.%3N")" INFO DELETING UNIX USER $user IN WORKLOAD VM"
      if ! delete_user $user;then
        echo  $(date "+%F %T.%3N")" INFO UNIX USER $user CANNOT BE DELETED"
        end_banner
      fi
    fi

    echo  $(date "+%F %T.%3N")" INFO DELETING ENM USER $user"
    if ! delete_enm_user $user;then
      echo  $(date "+%F %T.%3N")" INFO ENM USER $user CANNOT BE DELETED"
      end_banner
    fi
    echo  $(date "+%F %T.%3N")" INFO DELETION OF ENM USER $user HAS BEEN SUCCESSFULLY COMPLETED"
    end_banner
  fi
fi
