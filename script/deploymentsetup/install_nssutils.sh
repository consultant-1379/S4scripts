#!/bin/bash

NEXUS='https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus'
GR='com.ericsson.oss.services.nss.nssutils'
ART='ERICTWnssutils_CXP9036352'
VER=$1
IS_WORKLOAD_VM=$2

install_nss_utils(){
  echo "$FUNCNAME - $(date)"
  echo "Downloading $ART $VER from Nexus"
  if [ "$IS_WORKLOAD_VM" == "yes" ]; then
    wget -e use_proxy=yes -e https_proxy=atproxy1:3128 -O $ART-$VER.rpm "$NEXUS/service/local/artifact/maven/redirect?r=releases&g=${GR}&a=${ART}&v=${VER}&e=rpm"
  else
    wget -O $ART-$VER.rpm "$NEXUS/service/local/artifact/maven/redirect?r=releases&g=${GR}&a=${ART}&v=${VER}&e=rpm"
  fi
  echo "Installing $ART $VER"
  yum install -y $ART-$VER.rpm
}
install_nss_utils
