#!/bin/bash

MAIL_BODY=$1
ActivitiesString=$2
TicketNumber429=$3
TicketNumber623=$4
TicketNumber660=$5
TicketNumber625=$6
TicketNumber1514=$7
Summary429=$8
Summary623=$9
Summary660=${10}
Summary665=${11}
Summary1514=${12}
S4TeamMembersOnCall=${13}
WeekNumber=${14}
username=${15}
ExtraOnCall=${16}

Activities429=()
Activities623=()
Activities660=()
Activities625=()
Activities1514=()

IFS=',' read -r -a array <<< "${ActivitiesString}"

for element in "${array[@]}"
do
    if [[ "$element" =~ "429".* ]]; then
  		Activities429+=( ${element#"429: "} )
	fi
    if [[ "$element" =~ "623".* ]]; then
  		Activities623+=( ${element#"623: "} )
	fi
    if [[ "$element" =~ "660".* ]]; then
  		Activities660+=( ${element#"660: "} )
	fi
	if [[ "$element" =~ "625".* ]]; then
  		Activities625+=( ${element#"625: "} )
	fi
	if [[ "$element" =~ "1514".* ]]; then
  		Activities1514+=( ${element#"1514: "} )
	fi
done

cat <<_EOF >>$MAIL_BODY
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head><META http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body style="background-color: whitesmoke">
<table style="width: 640px; height: 24px; margin-left: auto; margin-right: auto;border-collapse: collapse;">
<tbody>
<tr>
<td style="background-color: #4BA9FA; text-align: left;color: #082970;font-size:24px;padding-top:5px;padding-bottom:5px;padding-left: 5px;font-weight:bold;font-style: italic">&nbsp;<a href="https://confluence-oss.seli.wh.rnd.internal.ericsson.com/pages/viewpage.action?pageId=96996108">TEaaS S4</a></td>
</tr>
<tr>
<td style="background-color: #03045e; text-align: center;color: #ffff00;font-family:helvetica,courier,arial;font-size:28px;padding-top:5px;padding-bottom:5px;padding-left: 15px">Weekend On Call Report: Week $WeekNumber</td>
</tr>
<tr>
<td style="background-color: #03045e; text-align: center;color: #ffff00;font-family:helvetica,courier,arial;font-size:28px;padding-top:5px;padding-bottom:5px;padding-left: 15px">On Call: $S4TeamMembersOnCall</td>
</tr>
</tbody>

</table>
_EOF
if [ ! -z "$ExtraOnCall" ]
	then
	cat <<_EOF >>$MAIL_BODY
	<table style="width: 640px; height: 24px; margin-left: auto; margin-right: auto;border-collapse: collapse;">
<tbody>
<td style="background-color: #03045e; text-align: center;color: #ffff00;font-family:helvetica,courier,arial;font-size:28px;padding-top:5px;padding-bottom:5px;padding-left: 15px">Additional Support From: $ExtraOnCall </td>
</tr>
</tbody>
</table>
_EOF
fi
for i in 1 2 3 4 5
do
	if [ $i == 1 ]
	then
		Activities=("${Activities429[@]}")
		Ticket=$TicketNumber429
		Summary=$Summary429
		Deployment="Deployment 429"
	fi
	if [ $i == 2 ]
	then
		Activities=("${Activities623[@]}")
		Ticket=$TicketNumber623
		Summary=$Summary623
		Deployment="Deployment 623"
	fi
	if [ $i == 3 ]
	then
		Activities=("${Activities660[@]}")
		Ticket=$TicketNumber660
		Summary=$Summary660
		Deployment="Deployment 660"
	fi
	if [ $i == 4 ]
	then
		Activities=("${Activities625[@]}")
		Ticket=$TicketNumber625
		Summary=$Summary625
		Deployment="Deployment 625"
	fi
	if [ $i == 5 ]
	then
		Activities=("${Activities1514[@]}")
		Ticket=$TicketNumber1514
		Summary=$Summary1514
		Deployment="Deployment 1514"
	fi
	
	if [ ! -z "$Ticket" ]
	then
		cat <<_EOF >>$MAIL_BODY
<table style="width: 640px; height: 24px; margin-left: auto; margin-right: auto;border-collapse: collapse;background-color:#023e8a;text-align: center;">
<tbody>
<tr>
<td style="color: #ffff00;font-family:helvetica,courier,arial;font-size:24px;padding-top:5px;padding-bottom:5px">$Deployment</td>
</tr>
</tbody>
</table>

<table style="width: 640px; margin-left: auto; margin-right: auto;background-color:#0077b6;font-family:helvetica,courier,arial;color:white;">
<tbody>
<tr>
<td style="width: 300px;text-align:left;font-weight:bold;"><a href="https://jira-oss.seli.wh.rnd.internal.ericsson.com/browse/$Ticket" style="color:yellow;font-family:helvetica,courier,arial;font-size:24px;">$Ticket</a></td>

</tr>
</tbody>
</table>

<table style="width: 640px; margin-left: auto; margin-right: auto;background-color:#0077b6;font-family:helvetica,courier,arial;color:white;">
<tbody>
_EOF
	for element in "${Activities[@]}"
	do
		cat <<_EOF >>$MAIL_BODY
<tr>
<td style="width: 160px;text-align:left;border:3px solid white;font-family:helvetica,courier,arial;font-size:24px;">$element</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
_EOF
	done
			cat <<_EOF >>$MAIL_BODY
</tbody>
</table>
<table style="width: 640px; margin-left: auto; margin-right: auto;background-color:#0077b6;font-family:helvetica,courier,arial;color:white;">
<tbody>
<tr>
<td style="width: 300px;font-family:helvetica,courier,arial;font-size:24px;">Summary:</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
<tr>
<td style="width: 300px;text-align:left;font-family:helvetica,courier,arial;font-size:16px;">$Summary</td>
<td style="width: 160px;text-align:left;"></td>
</tr>
</tbody>
</table>
_EOF
	fi
done

cat <<_EOF >>$MAIL_BODY
<table style="width: 640px; height: 24px; margin-left: auto; margin-right: auto;border-collapse: collapse;">
<tbody>
<tr>
<td style="background-color: #03045e; text-align: left;color: #ffff00;font-family:helvetica,courier,arial;font-size:12px;padding-top:10px;padding-bottom:10px;padding-left: 15px">Report Generated by: $username </td>
<td style="background-color: #03045e; text-align: right;color: #ffff00;font-family:helvetica,courier,arial;font-size:12px;padding-top:10px;padding-bottom:10px;padding-left: 15px">Version 1</td>
</tr>
</tbody>
</table>
_EOF