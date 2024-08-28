collect_ddc_from_remote_hosts() {
    echo "$FUNCNAME - $(date)"
#    touch /var/ericsson/ddc_data/config/server.txt
    if [ ! -f "/var/ericsson/ddc_data/config/server.txt" ]; then
      echo -n "" > /var/ericsson/ddc_data/config/server.txt
    fi
#    echo -n "" > /var/ericsson/ddc_data/config/server.txt
    for NETSIM in $NETSIMS
    do
      if ! grep -q "$NETSIM" /var/ericsson/ddc_data/config/server.txt;then
        echo "$NETSIM=NETSIM" >> /var/ericsson/ddc_data/config/server.txt
      fi
    done
}

setup_ddc_sfs_clariion() {
    echo "$FUNCNAME - $(date)"
    touch /var/ericsson/ddc_data/config/MONITOR_SFS
    touch /var/ericsson/ddc_data/config/MONITOR_CLARIION
}

setup_ddc_nonlive_mo(){
    echo "$FUNCNAME - $(date)"
    touch /var/ericsson/ddc_data/config/MONITOR_DPS_NONLIVE
}

setup_ddc_fls(){
    echo "$FUNCNAME - $(date)"
    touch /var/ericsson/ddc_data/config/MONITOR_FLS
}
setup_ddc_vc(){
    echo "$FUNCNAME - $(date)"
    SED=/software/autoDeploy/MASTER_siteEngineering.txt
    MONITOR_VC=/var/ericsson/ddc_data/config/MONITOR_VC

    if [ -f ${SED} ]; then

        echo "Setting up Virtual Connect info. for DDC upload"
        /bin/touch ${MONITOR_VC}
        /bin/egrep VC_IP. ${SED} |awk -F = '{print $2}' | awk '{print}' ORS=',' | sed '$s/.$//' > ${MONITOR_VC}
        yum install -y net-snmp-utils
        service ddc restart
    else
        echo "Expected SED file $SED does not exist!!"
    fi
}
copy_ssh_keys_to_netsims() {
#        NETSIM_TARGETS=$@
    echo "$FUNCNAME - $(date)"
    for NETSIM in $NETSIMS
    do
        /root/rvb/copy-rsa-key-to-remote-host.exp $NETSIM root
        /root/rvb/copy-rsa-key-to-remote-host.exp $NETSIM netsim
    done
}

mount_ddp_to_lms() {
    echo "$FUNCNAME - $(date)"
    mkdir -p /net/ddpi/data/stats;
    [[ -z $(mount | egrep ddpi:) ]] && mount ddpi:/data/stats /net/ddpi/data/stats || echo "already mounted"
    mkdir -p /net/ddp/data/stats;
    [[ -z $(mount | egrep ddp:) ]] && mount ddp:/data/stats /net/ddp/data/stats || echo "already mounted"
    mkdir -p /net/$DDP_SERVER/data/stats;
    [[ -z $(mount | egrep $DDP_SERVER:) ]] && mount $DDP_SERVER:/data/stats /net/$DDP_SERVER/data/stats || echo "already mounted"
}

install_sysstat_netsim() {
    echo "$FUNCNAME - $(date)"
    for NETSIM in $NETSIMS;do
      ssh root@$NETSIM "if ! rpm -qa | grep -qw sysstat;then yum install glibc-static -y;fi"
    done  
}

install_ddccore_netsim(){
    echo "$FUNCNAME - $(date)"
    DDC_CORE_VER=$(rpm -qa | grep ERICddccore_CXP9035927 | awk -F'-' '{print $2}')
    for NETSIM in $NETSIMS;do
      scp /var/www/html/ENM_common_rhel7/ERICddccore_CXP9035927-$DDC_CORE_VER.rpm root@$NETSIM://var/tmp
      ssh root@$NETSIM "yum install /var/tmp/ERICddccore_CXP9035927-$DDC_CORE_VER.rpm -y"
    done
}

change_sysstat_history() {
    echo "$FUNCNAME - $(date)"
    for NETSIM in $NETSIMS;do
      ssh root@$NETSIM "sed -i 's/HISTORY=28/HISTORY=7/g' /etc/sysconfig/sysstat"
    done  
}


NETSIMS=$1
set -ex
#set -o functrace
copy_ssh_keys_to_netsims
collect_ddc_from_remote_hosts
setup_ddc_sfs_clariion
setup_ddc_nonlive_mo
setup_ddc_fls
setup_ddc_vc
mount_ddp_to_lms
install_sysstat_netsim
install_ddccore_netsim
change_sysstat_history
