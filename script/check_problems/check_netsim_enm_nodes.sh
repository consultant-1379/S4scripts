#!/bin/bash

create_file_netsim_nodes(){

for netsim in $netsims;do
  counter="1"
  echo "SEARCHING NODES IN NETSIM VM: $netsim"
  simdirs=$(sshpass -p netsim ssh netsim@$netsim "ls $simpath")
#  echo $simdirs
  for simdir in $simdirs;do
    nodes=$(sshpass -p netsim ssh netsim@$netsim "ls $simpath/$simdir")
    echo $nodes | tr ' ' '\n' >> $netsim_nodelist_tmp_file
  done
done

sort $netsim_nodelist_tmp_file > ${netsim_nodelist_tmp_file}_sorted
}

create_file_enm_nodes(){

sshpass -p 12shroot ssh root@$wkl_vm "/opt/ericsson/enmutils/bin/cli_app 'cmedit get * CmFunction.syncStatus -t'" | awk '{print $1}' > $enm_nodelist_tmp_file

sort $enm_nodelist_tmp_file > ${enm_nodelist_tmp_file}_sorted

sed -i 's/ieatnetsimv....-.._//g' ${enm_nodelist_tmp_file}_sorted
}

get_search_string_from_netype(){

  local netype=$1
  local search_string=""

  case "$netype" in
    DSC)
      search_string="DSC"
      ;;
    SGSN-MME)
      search_string="SGSN"
      ;;
    SBG-IS)
      search_string="SBG"
      ;;
    MGW)
      search_string="K100\|K3\|MGw"
      ;;
    EPG)
      search_string="EPG"
      ;;
    MTAS)
      search_string="MTAS"
      ;;
    RadioNode)
      search_string="dg2\|MSRBS"
      ;;
    Router6672)
      search_string="R6672"
      ;;
    MINI-LINK-Indoor)
      search_string="MLTN"
      ;;
    ESC)
      search_string="ERS"
      ;;
    MINI-LINK-6352)
      search_string="6352"
      ;;
    FRONTHAUL-6080)
      search_string="FrontHaul"
      ;;
    MSC-DB-BSP)
      search_string="MSC-DB-BSP"
      ;;
    MSC-BC-IS)
      search_string="MSC-BC-IS"
      ;;
    MSC-BC-BSP)
      search_string="MSC-BC-BSP"
      ;;
    ERBS)
      search_string="ERBS"
      ;;
    *)
      echo "ERROR: NE TYPE NOT DETECTED FOR SIMULATION $sim"
  esac
  echo $search_string

}

extract_nodes_and_compare(){

  local netype=$1

  search_string=$(get_search_string_from_netype $netype)

  case "$netype" in

    ERBS)
    cat ${netsim_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "dg2\|MSRBS" | sort > $tmp_files_dir$netype.txt
    cat ${enm_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "dg2\|MSRBS" | sort > $tmp_files_dir${netype}_enm.txt
    number_nodes_netsim=$(cat ${netsim_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "dg2\|MSRBS" | wc -l)
    number_nodes_enm=$(cat ${enm_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "dg2\|MSRBS" | wc -l)  
    ;;
    
    EPG) 
    cat ${netsim_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "EPGOI" | sort > $tmp_files_dir$netype.txt
    cat ${enm_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "EPGOI" | sort > $tmp_files_dir${netype}_enm.txt
    number_nodes_netsim=$(cat ${netsim_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "EPGOI" | wc -l)
    number_nodes_enm=$(cat ${enm_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "EPGOI" | wc -l)
    ;;

    *)
    grep "$search_string" ${netsim_nodelist_tmp_file}_sorted | sort > $tmp_files_dir$netype.txt
    grep "$search_string" ${enm_nodelist_tmp_file}_sorted | sort > $tmp_files_dir${netype}_enm.txt
    number_nodes_netsim=$(grep "$search_string" ${netsim_nodelist_tmp_file}_sorted | wc -l)
    number_nodes_enm=$(grep "$search_string" ${enm_nodelist_tmp_file}_sorted | wc -l)
    ;;

  esac
   
  
  
  
#  if [[ "$netype" == "ERBS" ]];then
#    cat ${netsim_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "dg2\|MSRBS" | sort > $tmp_files_dir$netype.txt
#    cat ${enm_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "dg2\|MSRBS" | sort > $tmp_files_dir${netype}_enm.txt
#    number_nodes_netsim=$(cat ${netsim_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "dg2\|MSRBS" | wc -l)
#    number_nodes_enm=$(cat ${enm_nodelist_tmp_file}_sorted | grep "$search_string" | grep -v "dg2\|MSRBS" | wc -l) 
#  else
#    grep "$search_string" ${netsim_nodelist_tmp_file}_sorted | sort > $tmp_files_dir$netype.txt
#    grep "$search_string" ${enm_nodelist_tmp_file}_sorted | sort > $tmp_files_dir${netype}_enm.txt
#    number_nodes_netsim=$(grep "$search_string" ${netsim_nodelist_tmp_file}_sorted | wc -l)
#    number_nodes_enm=$(grep "$search_string" ${enm_nodelist_tmp_file}_sorted | wc -l)
#  fi
  echo "NUMBER OF $netype IN NETSIM: $number_nodes_netsim NUMBER OF NODES IN ENM: $number_nodes_enm"
  diff -u $tmp_files_dir$netype.txt $tmp_files_dir${netype}_enm.txt > $tmp_files_dir${netype}_diff.txt
  if [ -s "$tmp_files_dir${netype}_diff.txt" ];then
    diff_file="$tmp_files_dir${netype}_diff.txt" 
    echo "THERE ARE MISMATCHES FOR NETYPE $netype (CHECK FILE $tmp_files_dir${netype}_diff.txt)"
    exit_status="ERROR"
  else
    echo "NO MISMATCHES FOUND FOR NETYPE $netype"
  fi
#  cat ${netype}_diff.txt
#  echo $diff_files
}

clusterId=$1
netsims="$2"
debug_mode=$3

if [[ $debug_mode == "yes" ]];then
  set -x
  set -o functrace
fi

wkl_vm_url=$(wget -q -O - --no-check-certificate "https://cifwk-oss.lmera.ericsson.se/generateTAFHostPropertiesJSON/?clusterId=${clusterId}&tunnel=true")
wkl_vm=$(echo $wkl_vm_url | grep -oP "^.*workload" | tail -c 34 | awk -F "," '{print $1}' | sed -r 's/"//g')

simpath="/netsim/netsim_dbdir/simdir/netsim/netsimdir"
tmp_files_dir="/tmp/check_netsim_enm_nodes/"
netsim_nodelist_tmp_file=${tmp_files_dir}netsim_nodelist.txt
enm_nodelist_tmp_file=${tmp_files_dir}enm_nodelist.txt
rm -rf $tmp_files_dir

#netsims="ieatnetsimv5116-01.athtem.eei.ericsson.se ieatnetsimv5116-02.athtem.eei.ericsson.se"

#netsims="ieatnetsimv5116-01.athtem.eei.ericsson.se ieatnetsimv5116-02.athtem.eei.ericsson.se ieatnetsimv5116-03.athtem.eei.ericsson.se ieatnetsimv5116-04.athtem.eei.ericsson.se ieatnetsimv5116-05.athtem.eei.ericsson.se ieatnetsimv5116-06.athtem.eei.ericsson.se ieatnetsimv5116-07.athtem.eei.ericsson.se ieatnetsimv5116-08.athtem.eei.ericsson.se ieatnetsimv5116-09.athtem.eei.ericsson.se ieatnetsimv5116-10.athtem.eei.ericsson.se ieatnetsimv5116-11.athtem.eei.ericsson.se ieatnetsimv5116-12.athtem.eei.ericsson.se ieatnetsimv5116-13.athtem.eei.ericsson.se ieatnetsimv5116-14.athtem.eei.ericsson.se ieatnetsimv5116-15.athtem.eei.ericsson.se ieatnetsimv5116-16.athtem.eei.ericsson.se ieatnetsimv5116-17.athtem.eei.ericsson.se ieatnetsimv5116-18.athtem.eei.ericsson.se ieatnetsimv5116-19.athtem.eei.ericsson.se ieatnetsimv5116-20.athtem.eei.ericsson.se ieatnetsimv5116-21.athtem.eei.ericsson.se ieatnetsimv5116-22.athtem.eei.ericsson.se ieatnetsimv5116-23.athtem.eei.ericsson.se ieatnetsimv5116-24.athtem.eei.ericsson.se ieatnetsimv5116-25.athtem.eei.ericsson.se ieatnetsimv5116-26.athtem.eei.ericsson.se ieatnetsimv5116-27.athtem.eei.ericsson.se ieatnetsimv5116-28.athtem.eei.ericsson.se ieatnetsimv5116-29.athtem.eei.ericsson.se ieatnetsimv5116-30.athtem.eei.ericsson.se ieatnetsimv5116-31.athtem.eei.ericsson.se ieatnetsimv5116-32.athtem.eei.ericsson.se ieatnetsimv5116-33.athtem.eei.ericsson.se ieatnetsimv5116-34.athtem.eei.ericsson.se ieatnetsimv5116-35.athtem.eei.ericsson.se ieatnetsimv5116-36.athtem.eei.ericsson.se ieatnetsimv5116-37.athtem.eei.ericsson.se ieatnetsimv5116-38.athtem.eei.ericsson.se ieatnetsimv5116-39.athtem.eei.ericsson.se ieatnetsimv5116-40.athtem.eei.ericsson.se ieatnetsimv5116-41.athtem.eei.ericsson.se ieatnetsimv5116-42.athtem.eei.ericsson.se ieatnetsimv5116-43.athtem.eei.ericsson.se ieatnetsimv5116-44.athtem.eei.ericsson.se ieatnetsimv5116-45.athtem.eei.ericsson.se ieatnetsimv5116-46.athtem.eei.ericsson.se ieatnetsimv5116-47.athtem.eei.ericsson.se ieatnetsimv5116-48.athtem.eei.ericsson.se ieatnetsimv5116-49.athtem.eei.ericsson.se ieatnetsimv5116-50.athtem.eei.ericsson.se ieatnetsimv5116-51.athtem.eei.ericsson.se ieatnetsimv5116-52.athtem.eei.ericsson.se ieatnetsimv5116-53.athtem.eei.ericsson.se ieatnetsimv5116-54.athtem.eei.ericsson.se ieatnetsimv5116-55.athtem.eei.ericsson.se ieatnetsimv5116-56.athtem.eei.ericsson.se ieatnetsimv5116-57.athtem.eei.ericsson.se ieatnetsimv5116-58.athtem.eei.ericsson.se ieatnetsimv5116-59.athtem.eei.ericsson.se ieatnetsimv5116-60.athtem.eei.ericsson.se ieatnetsimv5116-61.athtem.eei.ericsson.se ieatnetsimv5116-62.athtem.eei.ericsson.se ieatnetsimv5116-63.athtem.eei.ericsson.se ieatnetsimv5116-64.athtem.eei.ericsson.se ieatnetsimv5116-65.athtem.eei.ericsson.se ieatnetsimv5116-66.athtem.eei.ericsson.se ieatnetsimv5116-67.athtem.eei.ericsson.se ieatnetsimv5116-68.athtem.eei.ericsson.se ieatnetsimv5116-69.athtem.eei.ericsson.se ieatnetsimv5116-70.athtem.eei.ericsson.se ieatnetsimv5116-71.athtem.eei.ericsson.se ieatnetsimv5116-72.athtem.eei.ericsson.se ieatnetsimv5116-73.athtem.eei.ericsson.se ieatnetsimv5116-74.athtem.eei.ericsson.se ieatnetsimv5116-75.athtem.eei.ericsson.se ieatnetsimv5116-76.athtem.eei.ericsson.se ieatnetsimv5116-77.athtem.eei.ericsson.se ieatnetsimv5116-78.athtem.eei.ericsson.se ieatnetsimv5116-79.athtem.eei.ericsson.se ieatnetsimv5116-80.athtem.eei.ericsson.se ieatnetsimv5116-81.athtem.eei.ericsson.se ieatnetsimv5116-82.athtem.eei.ericsson.se ieatnetsimv5116-83.athtem.eei.ericsson.se ieatnetsimv5116-84.athtem.eei.ericsson.se ieatnetsimv5116-85.athtem.eei.ericsson.se ieatnetsimv5116-86.athtem.eei.ericsson.se ieatnetsimv5116-87.athtem.eei.ericsson.se ieatnetsimv5116-88.athtem.eei.ericsson.se ieatnetsimv5116-89.athtem.eei.ericsson.se ieatnetsimv5116-90.athtem.eei.ericsson.se ieatnetsimv5116-91.athtem.eei.ericsson.se ieatnetsimv5116-92.athtem.eei.ericsson.se ieatnetsimv5116-93.athtem.eei.ericsson.se ieatnetsimv5116-94.athtem.eei.ericsson.se ieatnetsimv5116-95.athtem.eei.ericsson.se ieatnetsimv5116-96.athtem.eei.ericsson.se ieatnetsimv5116-97.athtem.eei.ericsson.se ieatnetsimv5116-98.athtem.eei.ericsson.se ieatnetsimv5116-99.athtem.eei.ericsson.se ieatnetsimv5116-100.athtem.eei.ericsson.se ieatnetsimv5116-101.athtem.eei.ericsson.se ieatnetsimv5116-102.athtem.eei.ericsson.se ieatnetsimv5116-103.athtem.eei.ericsson.se ieatnetsimv5116-104.athtem.eei.ericsson.se ieatnetsimv5116-105.athtem.eei.ericsson.se ieatnetsimv5116-106.athtem.eei.ericsson.se ieatnetsimv5116-107.athtem.eei.ericsson.se ieatnetsimv5116-108.athtem.eei.ericsson.se ieatnetsimv5116-109.athtem.eei.ericsson.se ieatnetsimv5116-110.athtem.eei.ericsson.se ieatnetsimv5116-111.athtem.eei.ericsson.se ieatnetsimv5116-112.athtem.eei.ericsson.se ieatnetsimv5116-113.athtem.eei.ericsson.se ieatnetsimv5116-114.athtem.eei.ericsson.se ieatnetsimv5116-115.athtem.eei.ericsson.se ieatnetsimv5116-116.athtem.eei.ericsson.se ieatnetsimv5116-117.athtem.eei.ericsson.se ieatnetsimv5116-118.athtem.eei.ericsson.se ieatnetsimv5116-119.athtem.eei.ericsson.se ieatnetsimv5116-120.athtem.eei.ericsson.se ieatnetsimv017-01.athtem.eei.ericsson.se ieatnetsimv017-02.athtem.eei.ericsson.se ieatnetsimv017-03.athtem.eei.ericsson.se ieatnetsimv017-04.athtem.eei.ericsson.se ieatnetsimv017-05.athtem.eei.ericsson.se ieatnetsimv017-06.athtem.eei.ericsson.se ieatnetsimv017-07.athtem.eei.ericsson.se ieatnetsimv017-08.athtem.eei.ericsson.se ieatnetsimv017-09.athtem.eei.ericsson.se ieatnetsimv017-10.athtem.eei.ericsson.se ieatnetsimv017-11.athtem.eei.ericsson.se ieatnetsimv017-12.athtem.eei.ericsson.se ieatnetsimv017-13.athtem.eei.ericsson.se"

#netypes="ERBS RadioNode"

netypes="DSC SGSN-MME SBG-IS MGW EPG MTAS RadioNode Router6672 MINI-LINK-Indoor ESC MINI-LINK-6352 FRONTHAUL-6080 MSC-DB-BSP MSC-BC-IS MSC-BC-BSP ERBS"

echo "*************************CHECKING NETSIM NODES CREATED IN ENM********************************"
echo ""
echo "NETYPES: $netypes"
echo ""
echo "TMP FILES DIR: $tmp_files_dir"
echo ""
echo "NETSIM VMS: $netsims"
echo ""
echo ""
mkdir -p $tmp_files_dir

create_file_netsim_nodes
create_file_enm_nodes
#extract_radionode_nodes
#extract_minilink_outdoor_nodes
for netype in $netypes;do
  echo "******************PROCESSING NETYPE: $netype"
  extract_nodes_and_compare $netype
  diff_files="$diff_files $diff_file" 
  echo ""
done

#echo $diff_files

for file_diff in $diff_files;do
  echo "**********************FILE: $file_diff"
  cat $file_diff | tr '\n' ' '
  echo "****************************************************************************************************"
  echo ""
done

if [[ $exit_status=="ERROR" ]];then
  exit 0
fi
