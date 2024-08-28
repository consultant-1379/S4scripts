#!/bin/bash

while getopts "c:d:n:p:q:s:t:" option
do
  case "${option}"
  in
    c) cluster_id=${OPTARG};;
    d) debug_mode=${OPTARG};;
    n) netsims=${OPTARG};;
    p) print_files=${OPTARG};;
    q) pm_quarter=${OPTARG};;
    s) check_type=${OPTARG};;
    t) ne_type=${OPTARG};;
    *) echo "Invalid input ${OPTARG}"; exit 1 ;;
  esac
done

SCRIPTS_DIR="/var/tmp/myscripts"


case "$check_type" in

"Check Netsim PM Files") sh $SCRIPTS_DIR/check_netsim_pm_files.sh -n "$netsims" -p "$print_files"
    ;;
"Check ENM PM Files") sh $SCRIPTS_DIR/check_enm_pm_files.sh $cluster_id $ne_type "$pm_quarter" $debug_mode
    ;;
"Check Netsim ENM Nodes") sh $SCRIPTS_DIR/check_netsim_enm_nodes.sh $cluster_id "$netsims" $debug_mode
    ;;

*) echo "Fix type $fix_type is not supported"
   ;;
esac
