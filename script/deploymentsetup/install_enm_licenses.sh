#!/bin/bash

BASENAME=$(dirname $0)

install_available_licenses() {

    echo "$FUNCNAME - $(date)"
    cd /root/rvb/bin/teaas/s4/licenses/
    for LICENSE in *
    do
        /opt/ericsson/enmutils/bin/cli_app "lcmadm install file:$LICENSE" /root/rvb/bin/teaas/s4/licenses/$LICENSE
    done
}

list_installed_licenses() {

  echo "$FUNCNAME - $(date)"
  /opt/ericsson/enmutils/bin/cli_app "lcmadm list"
}


install_available_licenses
list_installed_licenses
