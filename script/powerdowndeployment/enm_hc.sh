#!/bin/bash
# NAS Upgrade Patch Script
# ********************************************************************
# Ericsson Radio Systems AB                                     SCRIPT
# ********************************************************************
#
#
# (c) Ericsson Radio Systems AB 2021 - All rights reserved.
#
# The copyright to the computer program(s) herein is the property
# of Ericsson Radio Systems AB, Sweden. The programs may be used
# and/or copied only with the written permission from Ericsson Radio
# Systems AB or in accordance with the terms and conditions stipulated
# in the agreement/contract under which the program(s) have been
# supplied.
#
# ********************************************************************
# Name    : upgrade_va_rhel_patches.bsh
# Date    : 15/12/2021
# Revision: A
# Purpose : This script performs upgrade of NAS RHEL patches
#
#
# Version Information:
#       Version Who             Date            Comment
#       0.1     estmann         15/12/2021      Initial draft
#
# Usage   : "upgrade_va_rhel_patches.bsh -h" to give usage
#
# ********************************************************************

#CLUSTER_ID=$1

. ./functions_lib.sh

setVars

echo "INFO: Executing ENM hc"
if executeEnmHc;then
  echo "INFO: ENM hc have been successfully completed"
else
  echo "ERROR: ENM hc have failed !"
  exit 1
fi
