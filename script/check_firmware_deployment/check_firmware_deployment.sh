#!/bin/bash

HW_COMM="/opt/ericsson/hw_comm/bin/hw_comm.sh"
SED_FILE="/software/autoDeploy/MASTER_siteEngineering.txt"
PYTHON_SCRIPT="/opt/ericsson/hw_comm/lib/config_file_loader.py"

#set -ex

echo "INFO: CHECK IF hw_comm.sh SCRIPT IS PRESENT IN LMS"

if ! test -f "$HW_COMM"; then
  echo "ERROR: hw_comm.sh SCRIPT IS NOT PRESENT IN LMS !"
  exit 1
else
  echo "INFO: hw_comm.sh SCRIPT IS PRESENT IN LMS"
fi

echo "INFO: CHECK IF SED FILE IS PRESENT IN LMS"

if ! test -f "$SED_FILE"; then
  echo "ERROR: SED FILE IS NOT PRESENT IN LMS !"
  exit 1
else
  echo "INFO: SED FILE IS PRESENT IN LMS"
fi

echo "INFO: CREATE A BACKUP COPY OF $PYTHON_SCRIPT FILE"

if ! cp $PYTHON_SCRIPT ${PYTHON_SCRIPT}.bkp;then
  echo "ERROR: CREATION OF BACKUP FILE HAS FAILED !"
  exit 1
fi

echo "INFO: APPLY WA FOR DEFAULT PASSWORD TO $PYTHON_SCRIPT FILE"

if ! sed -i '/max_retries:$/a \            default_pass="12shroot"' $PYTHON_SCRIPT;then
  echo "ERROR: MODIFICATION OF $PYTHON_SCRIPT FILE HAS FAILED !"
  exit 1
fi

echo "INFO: LAUNCHING hw_comm.sh SCRIPT WITH check_firmware OPTION"

if ! $HW_COMM check_firmware $SED_FILE;then
  echo "ERROR: EXECUTION OF hw_comm.sh SCRIPT HAS FAILED"
  echo "INFO: RESTORING ORIGINAL $PYTHON_SCRIPT FILE"
  mv -f ${PYTHON_SCRIPT}.bkp $PYTHON_SCRIPT
  exit 1
else
  echo "INFO: EXECUTION OF hw_comm.sh SCRIPT HAS BEEN SUCCESSFULLY COMPLETED"
  echo "INFO: RESTORING ORIGINAL $PYTHON_SCRIPT FILE"
  mv -f ${PYTHON_SCRIPT}.bkp $PYTHON_SCRIPT
fi




