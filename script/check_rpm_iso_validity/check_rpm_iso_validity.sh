#!/bin/bash

rpms_to_check="$1"
is_failed="false"

check_rpm_url() {
  if ! wget -q --spider --no-check-certificate "$rpm_url"; then
    if curl --output /dev/null --silent --head --fail "$rpm_url"; then
      return 0
    else
      return 1
    fi
  fi
}


check_rpms_url() {
  rpm_info_list=$(echo $rpms_to_check | sed 's/@@/ /g')	
  for rpm_info in $rpm_info_list;do
    rpm_info_new=$rpm_info
    if [[ "$rpm_info" != *"https"* ]];then
      echo "FINDING NEXUS URL FOR $rpm_info"	    
      rpm_name=$(echo $rpm_info | awk -F'::' '{print $1}')
      rpm_version=$(echo $rpm_info | awk -F'::' '{print $2}')
#      echo $rpm_name
#      echo $rpm_version
      rpm_url=$(wget -q -O - --no-check-certificate "https://ci-portal.seli.wh.rnd.internal.ericsson.com/getArtifactFromLocalNexus/?artifactID=$rpm_name&version=$rpm_version" | sed 's/Local Nexus URL for Artifact is; //g')
      if [[ "$rpm_url" == *"Warning"* ]];then
        echo "$rpm_info URL CANNOT BE FOUND!"
	rpm_info_new=""
      else
        rpm_info_new="$rpm_name::$rpm_url"
      fi	
    fi
    rpm_info_list_new="$rpm_info_list_new $rpm_info_new"
  done

  rpm_url_list=$(echo $rpm_info_list_new | tr ' ' '\n' | awk -F '::' '{print $2}')
  echo ""
  echo "CHECKING RPM URL"
  echo ""
  for rpm_url in $rpm_url_list; do
    if check_rpm_url; then
      echo -e "$rpm_url -->\e[1;32m OK \e[0m"
    else
      echo -e "$rpm_url -->\e[1;31m NOK \e[0m"
      is_failed="true"
    fi
  done
}

banner(){
  echo "*******************************************************************"
  echo "*                     CHECK KGB+N RPM LINKS                       *"
  echo "*******************************************************************"
}	

banner
check_rpms_url


