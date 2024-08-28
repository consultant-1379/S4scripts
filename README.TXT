+----------------------------+
WHERE TO PUT THINGS?
+----------------------------+


SCRIPT
================================



+----------------------------+
getmails4
+----------------------------+

script/getmails4/
get_email_addresses_for_deployment.sh

This script is used in following jenkins job:
https://fem120-eiffel004.lmera.ericsson.se:8443/jenkins/view/S4/job/S4_Deployment_Based_Mail_v2/



+----------------------------+
NAGIOS
+----------------------------+

script/nagios/etc/objects/
deployment429.cfg deployment623.cfg

script/nagios/etc/libexec/
check_breeze                    check_oracle
check_cmsupervision_nodes.sh    check_pm_collection_statistical.sh
check_enm_hc.sh                 check_pmsupervision_nodes.sh
check_file_age                  check_rpc
check_flexlm                    check_sensors
check_fm_hb_failures.sh         check_snapshots.sh
check_fmsupervision_nodes.sh    check_synchronized.sh
check_ifoperstatus              check_unsync_nodes.sh
check_ifstatus                  check_vcs_sg.sh
check_ircd                      check_wave
check_log                       check_workload_pool_files.sh
check_mailq                     check_workload_pool_nodes.sh
check_netsim_cpu.sh             check_workloads.sh
check_netsim_disk.sh            check_workloads_started.sh
check_netsim_nodes.sh           s4/
check_node_fs.sh                test.sh
check_number_nodes.sh           utils.pm
check_number_nodes_workload.s*  utils.sh

script/nagios/etc/libexec/s4/
check_pm_collection_stat.sh  check_sync_nodes.sh



+----------------------------+
RPMLOADER
+----------------------------+

/script/rpmloader/
comando.txt  rpmloader.sh  rpmloader_functions.sh  rpmloader_setup.sh

These scripts are used in following jenkins job:
https://fem120-eiffel004.lmera.ericsson.se:8443/jenkins/view/S4/job/S4_RPM_Deployment_v2/



+----------------------------+
SGRESTART
+----------------------------+

/script/sgrestart/
comando.txt  rpmloader_functions.sh  sgrestart.sh  sgrestart_setup.sh


This script is used in following jenkins job (not run) :
https://fem120-eiffel004.lmera.ericsson.se:8443/jenkins/view/S4/job/S4_VCS_Management/


+----------------------------+
CHECKSTATUS
+----------------------------+

script/checkstatus/
DiskSpaceCheck.sh  IanWorkloadCheck.sh  RPMCheck.sh  rpmyesterday.txt



RPM
================================

This .rpm must be installed on the server after "initial install"
sshpass-1.06-1.el6.x86_64.rpm



JENKINS
================================




+----------------------------+
ENM
+----------------------------+

/jenkins/enm/
5319enmRuns/               copy-rsa-key-to-remote-host.exp*  pre_install_teardown.sh*
5335enmRuns/               deployment_conf/                  python_scripts/
amos/                      dumps_dir/                        rv_full_schedule.py
apply_workload_simple.sh*  enmutils_cleanup.sh*              send_status_mail.bsh*
assertion_configurations/  functions*                        setup_ddc.sh*
bin/                       guestfish_installer.exp*          ssh_keys/
bur/                       licenses/                         teaas/
clear_versant_on_enm.sh*   netsim/                           tester_utils/
cloud_post_install/        post_initial_install/             upgrades/
cm_event_nbi_client/       pre_initial_install/




+----------------------------+
JOB_XMLS
+----------------------------+
jenkins/job_xmls/
ii/  misc/  netsim/  upgrade/




+----------------------------+
SLAVE
+----------------------------+

jenkins/slave/
copy_ssh_key.py     get_pom_from_nexus.py  job_setup_vapp.sh
copy_ssh_key_dv.py  job_setup.sh