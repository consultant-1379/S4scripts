#!/bin/bash

MAIL_BODY=$1
SERVER_STATUS=$2
enm_iso_version=$3
nrm=$4
nss_version=$5
nss_utils_version=$6
genstats_version=$7
enm_torutils_version=$8
enm_torutils_int_version=$9
no_synch_nodes=${10}
HIGHLIGHTED_ISSUES="${11}"
NAGIOS_STATUS=${12}
status_nagios="${13}"
OPEN_SUPPORT_TICKETS="${14}"
tickets="${15}"
summaries="${16}"
DAILY_PLANNED_ACTIVITIES="${17}"
username="${18}"

read -r -a array_open_tickets <<< "$tickets"

IFS="|" read -r -a array_open_tickets_summaries <<< "$summaries"


if [[ $NAGIOS_STATUS == "true" ]];then

  IFS=";" read -r -a array_status_nagios <<< $status_nagios
#  echo "${array_status_nagios[*]}"
fi

if [[ $SERVER_STATUS == "AVAILABLE" ]];then
  server_status_color="#00ff00"
else
  server_status_color="#ff0000"
fi


cat <<_EOF >>$MAIL_BODY
<!doctype html>
<html>
<head>
<style>
table {
  border: 3px solid black;
  border-collapse: collapse;
th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
</style>
</head>
<body>
<h1><span style="color: #0000ff;"><strong>Deployment Status Report</strong></span></h1>
<hr />
<table>
<tbody>
<tr>
<td>
<h3>OPERATIONAL STATUS:</h3>
</td>
<td>
<h3><span style="color: $server_status_color;"><strong>${SERVER_STATUS}</strong></span></h3>
</td>
</tr>
<tr>
<td>
<h3>ENM ISO:</h3>
</td>
<td>
<h3>$enm_iso_version</h3>
</td>
</tr>
<tr>
<td>
<h3>NRM:</h3>
</td>
<td>
<h3>$nrm</h3>
</td>
</tr>
<tr>
<td>
<h3>NSS SIMULATIONS:</h3>
</td>
<td>
<h3>$nss_version</h3>
</td>
</tr>
<tr>
<td>
<h3>NSS UTILS:</h3>
</td>
<td>
<h3>$nss_utils_version</h3>
</td>
</tr>
<tr>
<td>
<h3>GENSTATS:</h3>
</td>
<td>
<h3>$genstats_version</h3>
</td>
</tr>
<tr>
<td>
<h3>TORUTILS:</h3>
</td>
<td>
<h3>$enm_torutils_version</h3>
</td>
</tr>
<tr>
<td>
<h3>INTERNAL TORUTILS:</h3>
</td>
<td>
<h3>$enm_torutils_int_version</h3>
</td>
</tr>
<tr>
<td>
<h3>SYNCH NODES:</h3>
</td>
<td>
<h3>$no_synch_nodes</h3>
</td>
</tr>
</tbody>
</table>
_EOF

cat <<_EOF1 >>$MAIL_BODY
<h1><span style="color: #0000ff;"><strong>Summary of Status</strong></span></h1>
<hr />
<table>
<tbody>
_EOF1

OLD_IFS=$IFS
IFS=$'\n'

for issue in ${HIGHLIGHTED_ISSUES};do
  echo "<tr>" >>$MAIL_BODY
  echo "<td>$issue</td>" >>$MAIL_BODY
  echo "</tr>" >>$MAIL_BODY
done

IFS=$OLD_IFS

if [[ $NAGIOS_STATUS == "true" ]];then
  echo "<tr>" >>$MAIL_BODY
  echo "<td><h3><span style=\"color: #ff6600;\">Critical/Warning Checks (Nagios)</strong></span></h3></td>" >>$MAIL_BODY
  echo "</tr>" >>$MAIL_BODY
  for m in "${array_status_nagios[@]}";do
    echo "<tr>" >>$MAIL_BODY
    echo "<td>$m</td>" >>$MAIL_BODY
    echo "</tr>" >>$MAIL_BODY
  done
fi

cat <<_EOF2 >>$MAIL_BODY
</tbody>
</table>
_EOF2

cat <<_EOF >>$MAIL_BODY
<h1><span style="color: #0000ff;"><strong>Jira Tickets (Issues)</strong></span></h1>
<hr />
<table>
<tbody>
_EOF

OLD_IFS=$IFS
IFS=$'\n'

for support_ticket in ${OPEN_SUPPORT_TICKETS};do
  echo "<tr>" >>$MAIL_BODY
  echo "<td>$support_ticket</td>" >>$MAIL_BODY
  echo "</tr>" >>$MAIL_BODY
done

IFS=$OLD_IFS

n=0

for i in "${array_open_tickets[@]}";do
  echo "<tr>" >>$MAIL_BODY
  echo "<td>$i ** ${array_open_tickets_summaries[$n]}</td>" >>$MAIL_BODY
  echo "</tr>" >>$MAIL_BODY
  n=$((n + 1))
done

cat <<_EOF0 >>$MAIL_BODY
</tbody>
</table>
_EOF0


cat <<_EOF3 >>$MAIL_BODY
<h1><span style="color: #0000ff;"><strong>Daily Planned Activities</strong></span></h1>
<hr />
<table>
<tbody>
_EOF3

OLD_IFS=$IFS
IFS=$'\n'

for planned_activity in ${DAILY_PLANNED_ACTIVITIES};do
  echo "<tr>" >>$MAIL_BODY
  echo "<td>$planned_activity</td>" >>$MAIL_BODY
  echo "</tr>" >>$MAIL_BODY
done

IFS=$OLD_IFS

cat <<_EOF4 >>$MAIL_BODY
</tbody>
</table>
<p>&nbsp;</p>
<h3>Report Created By:&nbsp;$username</h3>
</body>
</html>
_EOF4


#cat $MAIL_BODY

