#!/bin/bash
svc=$1
cate=$2
ssvm1=$(/root/rvb/bin/ssh_to_vm_and_su_root.exp $svc '/ericsson/3pp/jboss/bin/jboss-cli.sh -c "/subsystem=logging/logger='$cate':change-log-level(level=INFO)"')
echo "${ssvm1}"
ssvm2=$(/root/rvb/bin/ssh_to_vm_and_su_root.exp $svc '/ericsson/3pp/jboss/bin/jboss-cli.sh -c "./subsystem=logging/logger='$cate':read-resource"')
echo ""
if echo "${ssvm2}" | grep "success";
then
    echo ""
    echo "->      UPGRADED"
    echo " "
        if echo "${ssvm2}" | grep "INFO";
            then
                echo ""
                echo "->        INFO upgraded"
            else
                echo ""
                echo "->        INFO ERROR, please check"
        fi
else
    ssvm1=$(/root/rvb/bin/ssh_to_vm_and_su_root.exp $svc '/ericsson/3pp/jboss/bin/jboss-cli.sh -c "/subsystem=logging/logger='$cate':add(level=INFO)"')                                                                                            
    echo "${ssvm1}"
    ssvm2=$(/root/rvb/bin/ssh_to_vm_and_su_root.exp $svc '/ericsson/3pp/jboss/bin/jboss-cli.sh -c "./subsystem=logging/logger='$cate':read-resource"')
    echo "${ssvm2}"
    #echo ""
    #echo "->      UPGRADE ERROR"
fi
echo "_______________________________"
echo ""