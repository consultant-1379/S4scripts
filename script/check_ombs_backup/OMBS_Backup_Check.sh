## CORE COMMANDS
#cat /etc/hosts | grep ombs
#sshvm [ombs-bkp1 vm]
#/ericsson/ombss_enm_XXX/ombss_enm/bin/manage_backup_images.bsh -M ieatlmsXXXX-bkp-1 -s

# Depending on the LMS number (must be gathered) we sshvm into ombs-bkp1 or ombs-bkup1 
# then run the following command:
# /ericsson/ombss_enm_XXX/ombss_enm/bin/manage_backup_images.bsh -M ieatlmsXXXX-bkp1 -s

# 623 => /ericsson/ombss_enm_623/ombss_enm/bin/manage_backup_images.bsh -M ieatlms3901-bkp1 -s
# 429 => /ericsson/ombss_enm_429/ombss_enm/bin/manage_backup_images.bsh -M ieatlms5735-bkp1 -s
# 660 => /ericsson/ombss_enm_660/ombss_enm/bin/manage_backup_images.bsh -M ieatlms7435-bkup1 -s

lms_host=$(hostname)

#get status of backups
{ # try
  case "$lms_host" in
    ieatlms8168)   
      ombs_node="ieatombs5506-bkp1"
      deployment="1088"
      bkp_vm="ieatlms8168-bkp"
      ;; #1088
    ieatlms5735-1) 
      ombs_node="ieatombs6889-bkup1"
      deployment="429"
      bkp_vm="ieatlms5735-bkp1"
      ;; #429
    ieatlms7435)   
      ombs_node="ieatombs6710-bkup1"
      deployment="660"
      bkp_vm="ieatlms7435-bkup1"
      ;; #660
    ieatlms7600)
      ombs_node="ieatombs6710-bkup"
      deployment="679"
      bkp_vm="ieatlms7600-bkup"
      ;; #679
    *) 
      echo "Invalid LMS"; exit 0 ;;
  esac
} || {
  #catch
  echo "OMBS backups could not be fetched at this time. Please try again."
  exit 1
}

BACKUPS=$(ssh -q root@$ombs_node "timeout 2m /ericsson/ombss_enm_$deployment/ombss_enm/bin/manage_backup_images.bsh -M $bkp_vm -s" | sed -n 6,20p)
SUB='No backups found'
if [[ "$BACKUPS" == *"$SUB"* ]]; then
  echo -e "EXCEPTION THROWN IN OMBS CHECK COMMAND\n"
  echo $BACKUPS
  echo -e "\nNO OMBS BACKUP(S) FOUND ON DEPLOYMENT"
  exit 0
fi

now=$(date +%s)
#echo "$BACKUPS"

while IFS= read -r line; do
  	# BKP=$(echo -e "$BACKUPS" | sed -n "$ct"p | awk '{print "Version: "$2" "$3" |   Start Time: "$4" "$5" |   Expiry Time: "$6" "$7" |   BKP ID: "$8}')
    # if [ -z "$BKP" ];
    # then
    #   echo -e "\nNO OMBS BACKUP(S) AVAILABLE"
    #   exit 0
    # else
    #   echo "LAST SUCCESSFUL BACKUP:\n"
    # fi

    echo -e "$line" | awk '{print "BKP ID: "$8", Version: "$2" "$3", Date Taken: "$4" @ "$5" GMT, Expiry Date: "$6" @ "$7" GMT"}'
    expiry=$(echo -e "$line" | awk '{print $6}')
    #echo "$expiry"

    #Get date difference
    exp=$(date -d "$expiry" +%s)
    days_exp=$(((($exp - $now) / 86400) + 1))
    if [ $days_exp -lt 0 ];
    then
      echo "Backup is expired."
      echo "------------------------------------------------"
    else
      echo "Backup is valid but expires in $days_exp day(s)."
      echo "------------------------------------------------"
    fi
done <<< "$BACKUPS"

# #echo "$expiry"
# echo "$LAST_BACKUP"
# echo "\n\n"

# #Get date difference
# now=$(date +'%s')
# exp=$(date -d $expiry +'%s')
# days_exp=$(( ($exp - $now) / 86400 ))
# if [ $days_exp -lt 0 ];
# then
#   echo "Backup is expired."
# else
#   echo "Backup expires in $days_exp days"
# fi
