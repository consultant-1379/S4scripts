#!/bin/bash

MAIL_BODY_DELETE=$1
mail_list=$2


#gets report and assignee names
IFS=','
read -ra ADDR <<< "${mail_list}"
reporter=${ADDR[0]}
assignee=${ADDR[1]}
IFS='@'
read -ra ADDR1 <<< "${reporter}"
reporter=${ADDR1[0]}
read -ra ADDR2 <<< "${assignee}"
assignee=${ADDR2[0]}
IFS='.'
read -ra ADDR3 <<< "${reporter}"
reporter="${ADDR3[0]} ${ADDR3[1]}"
read -ra ADDR4 <<< "${assignee}"
assignee="${ADDR4[0]} ${ADDR4[1]}"

cat <<_EOF >>$MAIL_BODY_DELETE
<p>Hi ${reporter},<br>
<br>
Regarding ticket <a href="https://jira-nam.lmera.ericsson.se/browse/${jira_ticket}">${jira_ticket}</a>.<br>
This ticket has been moved out of its testing slot.<br>
<br>
The user ${jira_ticket} has been deleted from deployment ${clusterId}.<br>
All processes owned by the user have been killed and the home directory has
been deleted.<br>
<br>
Regards,<br>
${assignee}
</p>
_EOF