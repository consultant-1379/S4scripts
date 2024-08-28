#!/bin/bash

YUM_REPO_PATH=/var/www/html

rpms_to_search="$1"
rpm_present=""


for rpm_to_search in $rpms_to_search;do
#  echo "CHECKING RPM: $rpm_to_search"
  if [[ -n $(find $YUM_REPO_PATH -name "$rpm_to_search") ]];then
#    echo "$rpm_to_search IS PRESENT IN YUM REPO PATH"
    rpm_present="$rpm_present $rpm_to_search"
#  else
#    echo "$rpm_to_search IS NOT PRESENT IN YUM REPO PATH"
  fi
done

echo "$rpm_present"
