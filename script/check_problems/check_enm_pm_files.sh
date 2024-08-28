
execute_ssh_netsim(){
  local netsim_host=$1
  local cmd=$2
  
  sshpass -p netsim ssh -q -o StrictHostKeyChecking=no netsim@$netsim_host "$cmd"
  
}

get_pmstatsfiles_search_path_from_netype(){
  local netype=$1
  local pmstatsfiles_search_path
 
  case "$netype" in
    DSC)
      pmstatsfiles_search_path="DSC"
      ;;
    SGSN-MME)
      pmstatsfiles_search_path="SGSN"
      ;;
    SBG-IS)
      pmstatsfiles_search_path="SBG"
      ;;
    MGW)
      pmstatsfiles_search_path="K100 K3 MGw"
      ;;
    EPG)
      pmstatsfiles_search_path="EPG"
      ;;
    MTAS)
      pmstatsfiles_search_path="MTAS"
      ;;
    RadioNode)
      pmstatsfiles_search_path="dg2 MSRBS"
      ;;
    Router6672)
      pmstatsfiles_search_path="Router6672"
      ;;
    MINI-LINK-Indoor)
      pmstatsfiles_search_path="MLTN"
      ;;
    ESC)
      pmstatsfiles_search_path="ERS"
      ;;
    MINI-LINK-6352)
      pmstatsfiles_search_path="ML6352"
      ;;
    FRONTHAUL-6080)
      pmstatsfiles_search_path="FrontHaul"
      ;;
    MSC-DB-BSP)
      pmstatsfiles_search_path="MSC-DB-BSP"
      ;;
    MSC-BC-IS)
      pmstatsfiles_search_path="MSC-BC-IS"
      ;;
    MSC-BC-BSP)
      pmstatsfiles_search_path="MSC-BC-BSP"
      ;;
    ERBS)
      pmstatsfiles_search_path="ERBS"
      ;;
    *)
      echo "ERROR: NE TYPE NOT DETECTED FOR SIMULATION $sim"
  esac
  echo $pmstatsfiles_search_path

}

get_number_pm_files_by_netype(){

  local netype=$1

  case "$netype" in
    SGSN-MME|DSC|ESC|MGW|MTAS|RadioNode|Router6672|MINI-LINK-6352|RBS|FRONTHAUL-6080|ERBS|MSC-DB-BSP)
      no_pm_files="1"
      ;;
    MSC-BC-IS|MSC-BC-BSP)
      no_pm_files="6"
      ;;
    EPG)
      no_pm_files="3"
      ;;
    MINI-LINK-Indoor)
      no_pm_files="4"
      ;;
    SBG-IS)
      no_pm_files="300"
      ;;
    *)
      echo "ERROR: NE TYPE $netype NOT DETECTED"
      no_pm_files="0"
  esac
  echo $no_pm_files

}

get_pm_quarter(){
  local cmin=$1

  if [[ $cmin -ge 0 && $cmin -lt 15 ]];then
        cmin=00
  fi

  if [[ $cmin -ge 15 && $cmin -lt 30 ]];then
        cmin=15
  fi

  if [[ $cmin -ge 30 && $cmin -lt 45 ]];then
        cmin=30
  fi

  if [[ $cmin -ge 45 && $cmin -lt 59 ]];then
        cmin=45
  fi

  if [[ $cmin -eq 59 ]];then
        cmin=45
  fi
  echo $cmin

}

get_next_pm_quarter(){
  local chour=$1
  local cmin=$2

  if [[ $cmin == "00" ]];then
        nmin=15
  fi

  if [[ $cmin -eq 15 ]];then
        nmin=30
  fi

  if [[ $cmin -eq 30 ]];then
        nmin=45
  fi

  if [[ $cmin -eq 45 ]];then
        nmin=00
        chour=$(( chour + 1 ))
  fi

  echo $chour$nmin

}



#while getopts "n:p:" option
#do
#  case "${option}"
#  in
#    n) netsims=${OPTARG};;
#    p) print_files=${OPTARG};;
#    *) echo "Invalid input ${OPTARG}"; exit 1 ;;
#  esac
#done

#case "$print_files" in
#    [yY] | [yY][eE][sS]) 
#      echo "List of pm files found will be printed"
#      print_files_opt="1" 
#      ;;
#    [nN] | [nN][oO]) 
#      echo "List of pm files found will not be printed"
#      print_files_opt="0"
#      ;;
#    *) echo "I don't understand '$print_files'" ;;
#esac
#netsims=$1

#cyear=$(date -d '-60 min' +%Y)
#cmonth=$(date -d '-60 min' +%m)
#cday=$(date -d '-60 min' +%d)
#cmin=$(date -d '-60 min' +%M)
#chour=$(date -d '-60 min' +%H)

#cmin=$(echo "${cmin##0}")

#pm_quarter=$(get_pm_quarter $cmin)


CLUSTER=$1
netype=$2

pm_quarter_date_time=$3

debug_mode=$4

if [[ $debug_mode == "yes" ]];then
  set -x
  set -o functrace
fi

cyear="${pm_quarter_date_time:0:4}"
cmonth="${pm_quarter_date_time:5:2}"
cday="${pm_quarter_date_time:8:2}"
chour="${pm_quarter_date_time:11:2}"
cmin="${pm_quarter_date_time:14:2}"

tmp_files_dir="/tmp/check_enm_pm_files"
pmstats_pmic1_tmp_file="$tmp_files_dir/pmstats_files_list_pmic1_"
pmstats_pmic2_tmp_file="$tmp_files_dir/pmstats_files_list_pmic2_"
pmstats_all_tmp_file="$tmp_files_dir/pmstats_files_list_all_"

wkl_vm_url=$(wget -q -O - --no-check-certificate "https://cifwk-oss.lmera.ericsson.se/generateTAFHostPropertiesJSON/?clusterId=$CLUSTER&tunnel=true")
wkl_vm=$(echo $wkl_vm_url | grep -oP "^.*workload" | tail -c 34 | awk -F "," '{print $1}' | sed -r 's/"//g')

expected_pm_files_by_ne=$(get_number_pm_files_by_netype $netype)
pmstatsfiles_search_paths=$(get_pmstatsfiles_search_path_from_netype "$netype")


#CLUSTER=`grep -ri san_siteId /software/autoDeploy/*site*|head -1 | awk -F '=ENM' '{print $2}'`
nas_vip_enm_1=`grep -ri nas_vip_enm_1 /software/autoDeploy/*site*|head -1 | awk -F '=' '{print $2}'`
nas_vip_enm_2=`grep -ri nas_vip_enm_2 /software/autoDeploy/*site*|head -1 | awk -F '=' '{print $2}'`

echo "
********************************CHECKING PM FILES COLLECTED FOR NETYPE: $netype********************************

TMP FILES DIR: $tmp_files_dir
PM FILES DATE/TIME: $pm_quarter_date_time
EXPECTED PM FILES BY NE: $expected_pm_files_by_ne
PATTERNS USED FOR SEARCHING PM FILES: $pmstatsfiles_search_paths
"
echo "MOUNT PMIC1 AND PMIC2 SHARED FILESYSTEMS IN LMS"
mkdir -p /ericsson/pmic1
mkdir -p /ericsson/pmic2
mount ${nas_vip_enm_1}:/vx/ENM${CLUSTER}-pm1 /ericsson/pmic1
mount ${nas_vip_enm_2}:/vx/ENM${CLUSTER}-pm2 /ericsson/pmic2

mkdir -p $tmp_files_dir

next_pm_quarter=$(get_next_pm_quarter $chour $cmin)

pmstatsfiles_search_paths=$(get_pmstatsfiles_search_path_from_netype "$netype")

i=1

for pmstatsfiles_search_path in $pmstatsfiles_search_paths;do

  if [[ $pmstatsfiles_search_path == "ERBS" ]];then
    echo "APPLYING SEARCH FILES WORKAROUND FOR ERBS NODES ...."
    find /ericsson/pmic1/XML/*$pmstatsfiles_search_path* -type f -name "*A$cyear$cmonth$cday.$chour$cmin*$next_pm_quarter*" | grep -v "dg2" > $pmstats_pmic1_tmp_file${netype}_${i}.tmp &
    pid_1=$!
    pids="$pids $pid_1"
    find /ericsson/pmic2/XML/*$pmstatsfiles_search_path* -type f -name "*A$cyear$cmonth$cday.$chour$cmin*$next_pm_quarter*" |  grep -v "dg2" > $pmstats_pmic2_tmp_file${netype}_${i}.tmp &
    pid_2=$!
    pids="$pids $pid_2"
  else
    find /ericsson/pmic1/XML/*$pmstatsfiles_search_path* -type f -name "*A$cyear$cmonth$cday.$chour$cmin*$next_pm_quarter*" > $pmstats_pmic1_tmp_file${netype}_${i}.tmp &
    pid_1=$!
    pids="$pids $pid_1"
    find /ericsson/pmic2/XML/*$pmstatsfiles_search_path* -type f -name "*A$cyear$cmonth$cday.$chour$cmin*$next_pm_quarter*" > $pmstats_pmic2_tmp_file${netype}_${i}.tmp &
    pid_2=$!
    pids="$pids $pid_2"
  fi
  i=$(( i + 1 ))
done
echo "SEARCHING PM FILES ... PLEASE WAIT"

#echo $pids

for pid in $pids;do
 wait $pid
done
 
cat $pmstats_pmic1_tmp_file${netype}_* $pmstats_pmic2_tmp_file${netype}_* > $pmstats_all_tmp_file${netype}.tmp


rm -rf $pmstats_pmic1_tmp_file${netype}_*
rm -rf $pmstats_pmic2_tmp_file${netype}_*


echo ""
echo "CHECK 1: SEARCH DUPLICATED PM FILES"
current_time=$(date "+%Y.%m.%d-%H.%M.%S")

sort $pmstats_all_tmp_file${netype}.tmp | uniq -cd > /tmp/cmd_out_${current_time}.tmp
if [ -s "/tmp/cmd_out_${current_time}.tmp" ] 
then
  echo "DUPLICATED PM FILES HAVE BEEN FOUND"
  cat /tmp/cmd_out_${current_time}.tmp
else
  echo "NO DUPLICATED PM FILES HAVE BEEN FOUND"
fi

echo ""
echo "CHECK 2: VERIFY MISSING PM FILES"

nodes_pm_enabled=$(sshpass -p 12shroot timeout 40 ssh root@$wkl_vm "/opt/ericsson/enmutils/bin/cli_app \"cmedit get * PmFunction.pmEnabled==true -neType=$netype -t\"" | grep true | awk '{print $1}')

no_nodes_pm_enabled=$(echo $nodes_pm_enabled | wc -w)

echo "NUMBER OF NODES WITH PM ENABLED: $no_nodes_pm_enabled"

tot_expected_pm_files=$((expected_pm_files_by_ne * $no_nodes_pm_enabled))

echo "TOTAL NUMBER OF EXPECTED PM FILES: $tot_expected_pm_files"

no_files_pm=$(cat $pmstats_all_tmp_file${netype}.tmp | grep statsfile | wc -l)

echo "NUMBER OF PM FILES FOUND: $no_files_pm"


if [ $no_files_pm -lt $tot_expected_pm_files ];then
  echo "SEARCHING NODES WITH PM FILES MISSING"
 
  for node in $nodes_pm_enabled;do
    no_files_pm_ne=$(grep $node $pmstats_all_tmp_file${netype}.tmp | wc -l)
    if [ $no_files_pm_ne -lt $expected_pm_files_by_ne ];then
      missing_nodes="$missing_nodes $node files:$no_files_pm_ne"
#    if ! grep -q $node $pmstats_all_tmp_file${netype}.tmp; then
#      missing_nodes="$missing_nodes $node"
    fi
  done
  echo "PM file missing for nodes $missing_nodes"
  exit 1
else
  echo "NO PM FILES ARE MISSING"
  exit 0
fi

#rm -rf $node $pmstats_all_tmp_file${netype}.tmp

