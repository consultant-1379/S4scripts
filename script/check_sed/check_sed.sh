#!/bin/bash

DEPLOYMENT_ID=$1
ISO_VERSION=$2
DD=$3
CUSTOM_DD_URL=$4
CUSTOM_SED_URL=$5

WORKING_DIR="/tmp/check_sed-$(date '+%F-%T')/"
SED_FILE=$WORKING_DIR/MASTER_siteEngineering.txt
SED_ERROR_TO_SKIP="neo4j_reader_user_password_encrypted|Not all parameters are substituted|neo4j_ddc_user_password_encrypted|neo4j_sys_admin_user_password_encrypted|neo4j_admin_user_password_encrypted|openidm_admin_password_encrypted|idm_mysql_admin_password_encrypted|neo4j_hc_user_password_encrypted|ldap_admin_password_encrypted|neo4j_dps_user_password_encrypted|postgresql01_admin_password_encrypted|default_security_admin_password_encrypted|com_inf_ldap_admin_access_password_encrypted"

generate_sed(){

  curl https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/deployment/$DEPLOYMENT_ID/sed/master/generate/ > $SED_FILE

  if grep -q "does not exist" $SED_FILE;then
    cat $SED_FILE
    remove_temp_dir
    exit 1
  fi
}

download_dd(){

  url_ci=$(curl https://ci-portal.seli.wh.rnd.internal.ericsson.com/api/getMediaArtifactVersionData/mediaArtifact/ERICenm_CXP9027091/version/$ISO_VERSION/)
  if [[ "$url_ci" == *"error"* ]];then
    echo "$url_ci"
    remove_temp_dir
    exit 1
  fi
  url_rpm_partial=$(echo $url_ci | grep -oP "^.*ERICenmdeploymenttemplates_CXP9031758" | tail -c 230 | awk -F"," '{print $2}' | awk -F "\"" '{print $4}')
  rpm_version=$(echo $url_ci | grep -oP "^.*ERICenmdeploymenttemplates_CXP9031758" | tail -c 230 | awk -F"," '{print $2}' | awk -F "\"" '{print $4}' | awk -F"/" '{print $15}')
  echo "RPM VERSION: $rpm_version"
  echo "RPM URL PARTIAL: $url_rpm_partial"
#  exit
  url_rpm="${url_rpm_partial}-${rpm_version}.rpm"
  echo $url_rpm
#  exit 1
  wget -P $WORKING_DIR $url_rpm
}

unpack_dd_rpm(){

  cd $WORKING_DIR
  rpm2cpio ERICenmdeploymenttemplates_CXP9031758-*.rpm | cpio -idmv
}

remove_temp_dir(){
 
  rm -rf $WORKING_DIR

}


run_substitute_params(){
  echo "
  ============================================================================================================
  SUMMARY OF SED CHECK OPTIONS

  Deployment Id: $DEPLOYMENT_ID
  ENM Drop: $ISO_VERSION
  Deployment Template File: $DD
  Working Direcory: $WORKING_DIR
  ============================================================================================================
  "


  subparams_cmd=$(/opt/ericsson/enminst/bin/substituteParams.sh --xml_template $WORKING_DIR$DD --sed $SED_FILE | grep -Ev "$SED_ERROR_TO_SKIP")
  
  if [[ "$subparams_cmd" == *"Error"* ]];then
    	  
    echo "EXECUTION OF substituteParams.sh SCRIPT FAILED !"
    echo $subparams_cmd
    remove_temp_dir
    exit 1
  else
    echo $subparams_cmd
  fi

}

#rm -rf $WORKING_DIR

mkdir -p $WORKING_DIR


if [ -z "$CUSTOM_SED_URL" ];then
  generate_sed
else
  wget -P $WORKING_DIR $CUSTOM_SED_URL
  SED_FILENAME=$(echo $CUSTOM_SED_URL | awk -F '/' '{print $(NF)}')
  SED_FILE=$WORKING_DIR$SED_FILENAME
fi

if [ -z "$CUSTOM_DD_URL" ];then
  download_dd
  unpack_dd_rpm
else
  wget -P $WORKING_DIR $CUSTOM_DD_URL
#  DD=$(echo $CUSTOM_DD_URL | awk -F '/' '{print $8}')
  DD=$(echo $CUSTOM_DD_URL | awk -F '/' '{print $(NF)}')
fi  
run_substitute_params
remove_temp_dir
