#!/bin/bash

fix_type=$1
ne_type=$2
nodes=$3
netsim_vm=$4
SCRIPTS_DIR="/var/tmp/myscripts"


case "$fix_type" in

"Enable CM Supervision")  sh $SCRIPTS_DIR/fix_cmsupervision.sh $ne_type
    ;;
"Enable FM Supervision")  sh $SCRIPTS_DIR/fix_fmsupervision.sh $ne_type
    ;;
"Enable PM Supervision")  sh $SCRIPTS_DIR/fix_pmsupervision.sh $ne_type
    ;;
"Toggle CM Supervision") sh $SCRIPTS_DIR/fix_syncfailures.sh $ne_type "$nodes"
   ;;
"Toggle FM Supervision") sh $SCRIPTS_DIR/fix_fmhbfailures.sh $ne_type "$nodes"
   ;;
"Restore NE Database") sh $SCRIPTS_DIR/fix_restore_ne_db.sh $ne_type "$nodes"
   ;;
"Restart NE") sh $SCRIPTS_DIR/fix_restart_ne.sh $ne_type "$nodes"
   ;;
"Restore Database of All NEs") sh -x $SCRIPTS_DIR/fix_restore_ne_db_netsim.sh $netsim_vm 
   ;;
*) echo "Fix type $fix_type is not supported"
   ;;
esac
