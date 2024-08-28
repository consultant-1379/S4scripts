
execute_ssh_netsim(){
  local netsim_host=$1
  local cmd=$2
  
  sshpass -p netsim ssh -q -o StrictHostKeyChecking=no netsim@$netsim_host "$cmd"
  
}

get_netype_from_sim(){
  local sim=$1
 
  case "$sim" in
    *"DSC"*)
      netype="DSC"
      ;;
    *"SGSN"*)
      netype="SGSN-MME"
      ;;
    *"DSC"*)
      netype="DSC"
      ;;
    *"SBG-IS"*)
      netype="SBG-IS"
      ;;
    *"MGw"*)
      netype="MGW"
      ;;
    *"EPG"*)
      netype="EPG"
      ;;
    *"MTAS"*)
      netype="MTAS"
      ;;
    *"MSRBS"*)
      netype="RadioNode"
      ;;
    *"Router6274"*)
      netype="Router6274"
      ;;
    *"Router6672"*)
      netype="Router6672"
      ;;
    *"MLTN"*)
      netype="MINI-LINK-Indoor"
      ;;
    *"ERS"*)
      netype="ESC"
      ;;
    *"ML6352"*)
      netype="MINI-LINK-6352"
      ;;
    *"RBS"*)
      netype="RBS"
      ;;
    *"FrontHaul"*)
      netype="FRONTHAUL-6080"
      ;;
    *"MSC-DB-BSP"*)
      netype="MSC-DB-BSP"
      ;;
    *"MSC-BC-IS"*)
      netype="MSC-BC-IS"
      ;;
    *"MSC-BC-BSP"*)
      netype="MSC-BC-BSP"
      ;;
    *"J2"*)
      netype="ERBS"
      ;;
    *"J1"*)
      netype="ERBS"
      ;;
    *"DG2"*)
      netype="RadioNode"
      ;;
    *"ASR900"*)
      netype="CISCO-ASR900"
      ;;

    *)
      echo "ERROR: NE TYPE NOT DETECTED FOR SIMULATION $sim"
  esac
  echo $netype


}

get_number_pm_files_by_netype(){

  local netype=$1

  case "$netype" in
    SGSN-MME|DSC|ESC|MGW|MTAS|RadioNode|Router6672|Router6274|MINI-LINK-6352|RBS|FRONTHAUL-6080|ERBS|MSC-DB-BSP)
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
    CISCO-ASR900)
      no_pm_files="1"
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

while getopts "n:p:" option
do
  case "${option}"
  in
    n) netsims=${OPTARG};;
    p) print_files=${OPTARG};;
    *) echo "Invalid input ${OPTARG}"; exit 1 ;;
  esac
done

case "$print_files" in
    [yY] | [yY][eE][sS]) 
      echo "List of pm files found will be printed"
      print_files_opt="1" 
      ;;
    [nN] | [nN][oO]) 
      echo "List of pm files found will not be printed"
      print_files_opt="0"
      ;;
    *) echo "I don't understand '$print_files'" ;;
esac
#netsims=$1

cyear=$(date -d '-60 min' +%Y)
cmonth=$(date -d '-60 min' +%m)
cday=$(date -d '-60 min' +%d)
cmin=$(date -d '-60 min' +%M)
chour=$(date -d '-60 min' +%H)

cmin=$(echo "${cmin##0}")

pm_quarter=$(get_pm_quarter $cmin)

echo "SEARCHING PM FILES FOR 15MIN QUARTER: $cyear-$cmonth-$cday $chour:$pm_quarter"

next_pm_quarter=$(get_next_pm_quarter $chour $pm_quarter)

pm_filename="A$cyear$cmonth$cday.$chour$pm_quarter*$next_pm_quarter*"

echo "PM FILENAME: $pm_filename"
for netsim in $netsims;do
  
  echo ""
  echo ""
  echo "********PROCESSING NETSIM HOST: $netsim"
  sims=$(execute_ssh_netsim $netsim "ls /netsim/netsim_dbdir/simdir/netsim/netsimdir")

  for sim in $sims;do
    echo ""
    touch /tmp/pmfiles_all_ne.tmp
    netype=$(get_netype_from_sim $sim)
    echo "SIMULATION: $sim WITH NE TYPE: $netype HAS BEEN FOUND"
    no_pm_files_by_netype=$(get_number_pm_files_by_netype $netype)
# echo $no_pm_files_by_netype
    nodes=$(execute_ssh_netsim $netsim "ls /netsim/netsim_dbdir/simdir/netsim/netsimdir/$sim")
  #echo $nodes
    no_nodes=$(echo $nodes | wc -w)
    expected_pm_files=$(( no_nodes * no_pm_files_by_netype ))
    echo "NUMBER OF NODES PRESENT IN THE SIMULATION: $no_nodes EXPECTED PM FILES: $expected_pm_files"  
    execute_ssh_netsim $netsim "find /netsim/netsim_dbdir/simdir/netsim/netsimdir/$sim -name $pm_filename" > /tmp/pmfiles_all_ne.tmp
    no_pm_files_nodes=$(cat /tmp/pmfiles_all_ne.tmp | grep xml | wc -l)
  
    if [ $no_pm_files_nodes -eq $expected_pm_files ];then
      echo "********SUCCESS: NUMBER OF PM FILES EXPECTED $expected_pm_files MATCHES NUMBER OF PM FILES FOUND $no_pm_files_nodes"
    else
      echo "********FAILURE: NUMBER OF PM FILES EXPECTED $expected_pm_files IS NOT MATCHING NUMBER OF PM FILES FOUND $no_pm_files_nodes"

      failed_netsim="$failed_netsim $netsim"
      check_failed="1"
    fi
    no_pm_files_nodes=""
    if [[ "$print_files_opt" -eq "1" ]];then
      cat /tmp/pmfiles_all_ne.tmp | grep xml
    fi

    rm -rf /tmp/pmfiles_all_ne.tmp
  
  done
done
if [[ "$check_failed" -eq "1" ]];then
  echo "CHECK FAILED IN THE FOLLOWING NETSIM VM: $failed_netsim"
  exit 1
else
  exit 0
fi


