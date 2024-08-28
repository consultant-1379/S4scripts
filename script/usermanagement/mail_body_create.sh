#!/bin/bash

mail_reporter=$1
mail_assignee=$2
password=$3
jira_ticket=$4
cluster_id=$5
lms_ip=$6
workload_vm=$7
ddpi=$8
enm_gui_url=$9
mail_body_create=$10


cat <<_EOF >>$mail_body_create
<p>Hi ${reporter},<br>
<br>
Regarding ticket <a href="https://jira-nam.lmera.ericsson.se/browse/${jira_ticket}">${jira_ticket}</a>.<br>
<br>
A user has been created for you on deployment <a
href="https://cifwk-oss.lmera.ericsson.se/dmt/clusters/${clusterId}/details/">${clusterId}</a>.<br>
<br>
Username: <b>${jira_ticket}</b><br>
Password: <b>${password}</b><br>
<br>
Credentials are valid for both LMS (<a href="ssh://${jira_ticket}@10.210.217.10">ssh://${jira_ticket}@${lms_ip}</a>)
and <a href="${enm_gui_url}">ENM GUI</a><br>
Connect to the Deployment using: 'ssh ${jira_ticket}@${lms_ip}'
Connect to the Workload VM using: 'ssh  ${jira_ticket}@${workload_vm}'

DDP page for this deployment is available <a ref="https://${ddpi}.athtem.eei.ericsson.se/php/index.php?site=LMI_${clusterId}">here.

The LMS user has <a
href="https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/4/html/Security_Guide/s3-wstation-privileges-limitroot-sudo.html">sudo</a>
rights but the ENM user is somewhat restricted.<br>
To SSH to a Service Group VM you will need to run: <br>
<b>sudo ssh -i /root/.ssh/vm_private_key cloud-user@[target_vm]</b><br>
<br>
This user and its home directory <em><b><span style='font-family:"Calibri",sans-serif'>will
be deleted when <a href="https://jira-nam.lmera.ericsson.se/browse/${jira_ticket}">${jira_ticket}</a>
moves out of its testing slot</span></b></em>.<br>
Please contact ${assignee} if any support is needed. 
Regards,<br>
Team Grifone
</p>
_EOF
