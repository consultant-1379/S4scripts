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
clusterId="${19}"

read -r -a array_open_tickets <<< "$tickets"

IFS="|" read -r -a array_open_tickets_summaries <<< "$summaries"


if [[ $NAGIOS_STATUS == "true" ]];then

  IFS=";" read -r -a array_status_nagios <<< $status_nagios
#  echo "${array_status_nagios[*]}"
fi

if [[ $SERVER_STATUS == "AVAILABLE" ]];then
  server_status_color="greenyellow"
else
  server_status_color="red"
fi


cat <<_EOF >>$MAIL_BODY
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head><META http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body style="background-color: whitesmoke">
<table style="width: 640px; height: 24px; margin-left: auto; margin-right: auto;border-collapse: collapse;">
<tbody>
<tr>
<td style="background-color: #4BA9FA; text-align: left;color: #082970;font-size:24px;padding-top:5px;padding-bottom:5px;padding-left: 5px;font-weight:bold;font-style: italic"><a href="https://confluence-oss.seli.wh.rnd.internal.ericsson.com/pages/viewpage.action?pageId=96996108">TEaaS S4</a></td>
</tr>
<tr>
<td style="background-color: #03045e; text-align: center;color: #ffff00;font-family:helvetica,courier,arial;font-size:28px;padding-top:5px;padding-bottom:5px;padding-left: 15px">Deployment Status Report: $clusterId </td>
</tr>
</tbody>
</table>
<table style="width: 640px; height: 24px; margin-left: auto; margin-right: auto;border-collapse: collapse;background-color:#023e8a;text-align: center;">
<tbody>
<tr>
<td style="color: #ffff00;font-family:helvetica,courier,arial;font-size:24px;padding-top:5px;padding-bottom:5px">General Info</td>
</tr>
</tbody>
</table>
<table style="width: 640px; margin-left: auto; margin-right: auto;background-color:#4BA9FA;font-family:helvetica,courier,arial;color:white;">
<tbody>
<tr>
<td style="width: 160px;text-align:left;"></td>
<td style="width: 160px;text-align:left;border:1px solid white;">Operational Status:</td>
<td style="width: 160px;text-align:left;color: $server_status_color ;font-weight:bold;border:1px solid white;">$SERVER_STATUS</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
<tr>
<td style="width: 160px;text-align:left;"></td>
<td style="width: 160px;text-align:left;border:1px solid white;">ENM ISO:</td>
<td style="width: 160px;text-align:left;font-weight:bold;border:1px solid white;">$enm_iso_version</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
<tr>
<td style="width: 160px;text-align:left;"></td>
<td style="width: 160px;text-align:left;border:1px solid white;">NRM:</td>
<td style="width: 160px;text-align:left;font-weight:bold;border:1px solid white;">$nrm</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
<tr>
<td style="width: 160px;text-align:left;"></td>
<td style="width: 160px;text-align:left;border:1px solid white;">NSS Simulations:</td>
<td style="width: 160px;text-align:left;font-weight:bold;border:1px solid white;">$nss_version</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
<tr>
<td style="width: 160px;text-align:left;"></td>
<td style="width: 160px;text-align:left;border:1px solid white;">NssUtils:</td>
<td style="width: 160px;text-align:left;font-weight:bold;border:1px solid white;">$nss_utils_version</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
<tr>
<td style="width: 160px;text-align:left;"></td>
<td style="width: 160px;text-align:left;border:1px solid white;">Genstats:</td>
<td style="width: 160px;text-align:left;font-weight:bold;border:1px solid white;">$genstats_version</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
<tr>
<td style="width: 160px;text-align:left;"></td>
<td style="width: 160px;text-align:left;border:1px solid white;">TorUtils:</td>
<td style="width: 160px;text-align:left;font-weight:bold;border:1px solid white;">$enm_torutils_version</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
<tr>
<td style="width: 160px;text-align:left;"></td>
<td style="width: 160px;text-align:left;border:1px solid white;">Internal TorUtils:</td>
<td style="width: 160px;text-align:left;font-weight:bold;border:1px solid white;">$enm_torutils_int_version</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
<tr>
<td style="width: 160px;text-align:left;"></td>
<td style="width: 160px;text-align:left;border:1px solid white;">Synchronized Nodes:</td>
<td style="width: 160px;text-align:left;font-weight:bold;border:1px solid white;">$no_synch_nodes</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
</tbody>
</table>
<table style="width: 640px; height: 24px; margin-left: auto; margin-right: auto;border-collapse: collapse;background-color:#023e8a;text-align: center;">
<tbody>
<tr>
<td style="color: #ffff00;font-family:helvetica,courier,arial;font-size:24px;padding-top:5px;padding-bottom:5px">Status Summary</td>
</tr>
</tbody>
</table>
<table style="width: 640px; margin-left: auto; margin-right: auto;background-color:#4BA9FA;font-family:helvetica,courier,arial;color:white;">
<tbody>
_EOF


OLD_IFS=$IFS
IFS=$'\n'

for issue in ${HIGHLIGHTED_ISSUES};do
  echo "<tr><td style=\"width: 640px;text-align:left;padding-left:15px\">$issue</td></tr>" >>$MAIL_BODY
done
----
IFS=$OLD_IFS

cat <<_EOF1 >>$MAIL_BODY
<tr><td style=\"height: 20px !important;width: 640px;text-align:left;padding-left:15px\"></td></tr>
_EOF1

if [[ $NAGIOS_STATUS == "true" ]];then
  echo "<tr>" >>$MAIL_BODY
  echo "<td style=\"width: 640px;text-align:left;padding-left:15px;font-weight:bold;color:black;padding-top:3px;padding-bottom:3px;text-decoration:underline;\">Nagios Warning/Critical Checks:</td>" >>$MAIL_BODY
  echo "</tr>" >>$MAIL_BODY
cat <<_EOF3 >>$MAIL_BODY
<ul>
_EOF3
  
  for m in "${array_status_nagios[@]}";do
    echo "<tr>" >>$MAIL_BODY
    echo "<td style=\"width: 640px;text-align:left;padding-left:15px;font-size:12px;font-weight:bold;color:black\"><li>$m</li></td>" >>$MAIL_BODY
    echo "</tr>" >>$MAIL_BODY
  done
fi

cat <<_EOF2 >>$MAIL_BODY
</ul>
</tbody>
</table>
<table style="width: 640px; height: 24px; margin-left: auto; margin-right: auto;border-collapse: collapse;background-color:#023e8a;text-align: center;">
<tbody>
<tr>
<td style="color: #ffff00;font-family:helvetica,courier,arial;font-size:24px;padding-top:5px;padding-bottom:5px">Jira Tickets (Issues)</td>
</tr>
</tbody>
</table>
<table style="width: 640px; margin-left: auto; margin-right: auto;background-color:#4BA9FA;font-family:helvetica,courier,arial;color:white;">
<tbody>
_EOF2

OLD_IFS=$IFS
IFS=$'\n'


for support_ticket in ${OPEN_SUPPORT_TICKETS};do  

IFS='=' 
read -ra ADDR <<< "$support_ticket" # str is read into an array as tokens separated by IFS
echo "<tr>${ADDR[2]}</tr>">>$MAIL_BODY
echo "<tr>${ADDR[0]}</tr>">>$MAIL_BODY
 
  IFS=$'\n'
done

IFS=$OLD_IFS

n=0

for i in "${array_open_tickets[@]}";do
  echo "<tr>${array_open_tickets_summaries[$n]}</tr><tr>$i</tr>" >>$MAIL_BODY
  n=$((n + 1))
done

cat <<_EOF0 >>$MAIL_BODY
</tbody>
</table>
<table style="width: 640px; height: 24px; margin-left: auto; margin-right: auto;border-collapse: collapse;background-color:#023e8a;text-align: center;">
<tbody>
<tr>
<td style="color: #ffff00;font-family:helvetica,courier,arial;font-size:24px;padding-top:5px;padding-bottom:5px">Daily Planned Activities</td>
</tr>
</tbody>
</table>
<table style="width: 640px; margin-left: auto; margin-right: auto;background-color:#4BA9FA;font-family:helvetica,courier,arial;color:white;">
<tbody>
<tr>
<td style="width: 640px;text-align:left;padding-left:15px">Please follow FEM120 email notifications sent to ENM RA test leads and ticket reporters and watchers.
</tr>
</tbody>
</table>
<table style="width: 640px; height: 24px; margin-left: auto; margin-right: auto;border-collapse: collapse;">
<tbody>
<tr>
<td style="background-color: #03045e; text-align: left;color: #ffff00;font-family:helvetica,courier,arial;font-size:12px;padding-top:10px;padding-bottom:10px;padding-left: 15px">Report Generated by: $username</td>
<td style="background-color: #03045e; text-align: right;color: #ffff00;font-family:helvetica,courier,arial;font-size:12px;padding-top:10px;padding-bottom:10px;padding-left: 15px">Version 2</td>
</tr>
</tbody>
</table>
</body></html>


_EOF0



#cat $MAIL_BODY

