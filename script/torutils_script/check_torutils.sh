IP_lms=$1 #ieatlms5735-1
TOR_WK=$(cat /etc/torutils-version | awk '{print $ 2;}')
echo "WORKLOAD " $TOR_WK

TOR_LMS=$(ssh -q root@$IP_lms "rpm -qa | egrep ERICtorutilities_")
echo "LSM " ${TOR_LMS:28:7}

if [ "$TOR_WK" = "${TOR_LMS:28:7}" ]; then
    echo "TorUtils version is equal"
else
    echo "TorUtils version is not equal."
    /opt/ericsson/enmutils/.deploy/update_enmutils_rpm ${TOR_LMS:28:7}
    cat /etc/torutils-version | awk '{print $ 2;}'
fi