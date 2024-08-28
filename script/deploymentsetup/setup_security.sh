#!/bin/bash

backup_files(){

    echo "$FUNCNAME - $(date)"
    echo "Backup existing files"
    cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.s4
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.s4
    cp /etc/ssh/ssh_config /etc/ssh/ssh_config.s4

}

setup_passwordless_access() {
    echo "$FUNCNAME - $(date)"
    cd /root/rvb/bin/teaas/s4/ssh_keys
    echo "Append ssh keys to authorized_keys file"
    for file in *
    do
        cat $file >> /root/.ssh/authorized_keys
    done
    cd -
}

create_testers_group() {
    echo "$FUNCNAME - $(date)"
    echo "Create groups for S4 users"
    groupadd -f testers
    groupadd -f privileged_testers
#    groupadd -f endurance_testers
    echo "Setup sudoers file"
    /bin/cp -f /root/rvb/bin/teaas/s4/sudoersfiles/teaas_sudoers_file /etc/sudoers.d/teaas
#    /bin/cp -f /root/rvb/post_initial_install/endurance_sudoers_file /etc/sudoers.d/endurance
}

restrict_root_ssh_with_password() {
    echo "$FUNCNAME - $(date)"
#    if [ ! -z "$PERMIT_ROOT_LOGIN" ]
#    then
        sed -i "s/#PermitRootLogin yes/PermitRootLogin without-password/g" /etc/ssh/sshd_config
        service sshd restart
#    fi
}

dont_use_strict_host_key_check_from_lms() {
    echo "$FUNCNAME - $(date)"
    sed -i "s/# Host/Host/g" /etc/ssh/ssh_config
    sed -i "s/#   StrictHostKeyChecking ask/   StrictHostKeyChecking no/g" /etc/ssh/ssh_config
}

set -ex
setup_passwordless_access
create_testers_group
#restrict_root_ssh_with_password
dont_use_strict_host_key_check_from_lms
