#!/bin/bash
ombs_op_type=$1

 

backup_cmd(){
local op_type=$1

 

sudo -u brsadm /opt/ericsson/itpf/bur/bin/bos --operation $op_type

 

}

 

case $ombs_op_type in

 

  activate)
    op_type="activate_backup"
    if backup_cmd $op_type;then
      echo "INFO: Activation of OMBS backup has been successfully completed"
    else
      echo "ERROR: Activation of OMBS backup has failed!"
    fi
    ;;

 

  deactivate)
    op_type="deactivate_backup"
    if backup_cmd $op_type;then
      echo "INFO: Deactivation of OMBS backup has been successfully completed"
    else
      echo "ERROR: Deactivation of OMBS backup has failed!"
    fi
    ;;

 

  status)
    op_type="is_backup_activated"
    bkp_status=$(backup_cmd $op_type)
    if [ $bkp_status == "true" ];then
      echo "INFO: OMBS Backup is activated"
    else
      if [ $bkp_status == "false" ];then
        echo "INFO: OMBS Backup is not activated"
      else
        echo "ERROR: Command to check status of ombs backup failed!"
      fi
    fi
    ;;

 

  *)
    echo -n "unknown option"
    ;;
esac