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
OMBS_STATUS="${20}"

read -r -a array_open_tickets <<< "$tickets"

IFS="|" read -r -a array_open_tickets_summaries <<< "$summaries"


if [[ $NAGIOS_STATUS == "true" ]];then

  IFS=";" read -r -a array_status_nagios <<< $status_nagios
#  echo "${array_status_nagios[*]}"
fi


if [[ $SERVER_STATUS == *"AVAILABLE"* ]];then
  server_status_color="#0FC373"
  server_status_H="H3"
fi

if [[ $SERVER_STATUS == *"DEGRADED"* ]];then
  server_status_color="#ff8c0a"
  server_status_H="H3"
fi

if [[ $SERVER_STATUS == *"EXCLUSIVE"* ]];then
  server_status_color="#ff8c0a"
  server_status_H="H3"
fi

if [[ $SERVER_STATUS == *"DEPLOYMENT ISSUES"* ]];then
  server_status_color="#ff3232"
  server_status_H="H3"
fi

if [[ $SERVER_STATUS == *"MAINTENANCE ACTIVITIES"* ]];then
  server_status_color="#ff3232"
  server_status_H="H3"
fi



cat <<_EOF >>$MAIL_BODY
<!DOCTYPE html><html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Status Mail - Team Grifone</title>
    <style id="53898_style" class="codeStyle">* {
        box-sizing: border-box;
      }
      @font-face{font-family:EricssonHilda;
    src:local(EricssonHilda-Light),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Light.woff2) format("woff2"),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Light.woff) format("woff"),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Light.eot) format("truetype");
    font-weight:300;font-style:normal;font-stretch:normal}
    @font-face{font-family:EricssonHilda;
    src:local(EricssonHilda-Regular),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Regular.woff2) format("woff2"),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Regular.woff) format("woff"),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Regular.eot) format("truetype");
    font-weight:normal;font-style:normal;font-stretch:normal}
    @font-face{font-family:EricssonHilda;src:local(EricssonHilda-Medium),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Medium.woff2) format("woff2"),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Medium.woff) format("woff"),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Medium.eot) format("truetype");font-weight:500;font-style:normal;font-stretch:normal}@font-face{font-family:EricssonHilda;src:local(EricssonHilda-Bold),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Bold.woff2) format("woff2"),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Bold.woff) format("woff"),url(https://brandhouse.ericsson.net/theme/css/hilda-font/EricssonHilda-Bold.eot) format("truetype");
    font-weight:700;font-style:normal;font-stretch:normal}
      .eds-btn {
          display: inline-block;
          padding: .5rem 1rem;
          min-width: 4.5rem;
          max-width: 100%;
          border-radius: .1875rem;
          white-space: nowrap;
          text-overflow: ellipsis;
          overflow: hidden;
          -webkit-transition: ease-in .2s;
          transition: ease-in .2s;
          -webkit-transition-property: background-color, color;
          transition-property: background-color, color;
          font-family: EricssonHilda, Helvetica, Arial, sans-serif;
          font-size: 1rem;
          font-weight: normal;
          font-stretch: normal;
          font-style: normal;
          line-height: 1.5;
          letter-spacing: normal;
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale
      }
      .eds-btn:focus {
          outline: none
      }
      .eds-btn:hover {
          cursor: pointer
      }
      .eds-btn.primary {
          display: inline-block;
          padding: .5rem 1rem;
          min-width: 4.5rem;
          max-width: 100%;
          border-radius: .1875rem;
          white-space: nowrap;
          text-overflow: ellipsis;
          overflow: hidden;
          -webkit-transition: ease-in .2s;
          transition: ease-in .2s;
          -webkit-transition-property: background-color, color;
          transition-property: background-color, color;
          font-family: EricssonHilda, Helvetica, Arial, sans-serif;
          font-size: 1rem;
          font-weight: normal;
          font-stretch: normal;
          font-style: normal;
          line-height: 1.5;
          letter-spacing: normal;
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
          background-color: #0082f0;
          color: #fafafa;
          border: none
      }
      .eds-btn.primary:focus {
          outline: none
      }
      .eds-btn.primary:hover {
          cursor: pointer
      }
      .eds-btn.primary:focus {
          color: #fafafa;
          border: none
      }
      .eds-btn.primary:hover {
          background-color: #4d97ed;
          color: #fafafa
      }
      .eds-btn.primary:active {
          background-color: #105ab0;
          color: #fafafa
      }
      .eds-btn.primary:disabled,
      .eds-btn.primary.disabled {
          cursor: default;
          background-color: rgba(0, 130, 240, 0.4);
          color: rgba(250, 250, 250, 0.6)
      }
      .touch .eds-btn.primary:hover {
          background-color: #0082f0;
          color: #fafafa
      }
      .touch .eds-btn.primary:active {
          background-color: #105ab0;
          color: #fafafa
      }
      .eds-btn.secondary {
          display: inline-block;
          padding: .5rem 1rem;
          min-width: 4.5rem;
          max-width: 100%;
          border-radius: .1875rem;
          white-space: nowrap;
          text-overflow: ellipsis;
          overflow: hidden;
          -webkit-transition: ease-in .2s;
          transition: ease-in .2s;
          -webkit-transition-property: background-color, color;
          transition-property: background-color, color;
          font-family: EricssonHilda, Helvetica, Arial, sans-serif;
          font-size: 1rem;
          font-weight: normal;
          font-stretch: normal;
          font-style: normal;
          line-height: 1.5;
          letter-spacing: normal;
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
          background-color: rgba(0, 0, 0, 0);
          color: #242424;
          border: 1px solid #242424
      }
      .eds-btn.secondary:focus {
          outline: none
      }
      .eds-btn.secondary:hover {
          cursor: pointer
      }
      .eds-btn.secondary:focus {
          color: #242424
      }
      .eds-btn.secondary:hover {
          background-color: #4a4a4a;
          color: #fafafa
      }
      .eds-btn.secondary:active {
          background-color: #3a3a3a;
          color: #fafafa
      }
      .eds-btn.secondary:disabled,
      .eds-btn.secondary.disabled {
          cursor: default;
          background-color: rgba(0, 0, 0, 0);
          color: rgba(36, 36, 36, 0.4)
      }
      .touch .eds-btn.secondary:hover {
          background-color: rgba(0, 0, 0, 0);
          color: #242424
      }
      .touch .eds-btn.secondary:active {
          background-color: #3a3a3a;
          color: #fafafa
      }
      .eds-btn.secondary:hover {
          border-color: #4a4a4a
      }
      .eds-btn.secondary:active {
          border-color: #3a3a3a
      }
      .eds-btn.secondary:disabled,
      .eds-btn.secondary.disabled {
          border-color: rgba(36, 36, 36, 0.4)
      }
      .eds-btn.secondary-inverse {
          display: inline-block;
          padding: .5rem 1rem;
          min-width: 4.5rem;
          max-width: 100%;
          border-radius: .1875rem;
          white-space: nowrap;
          text-overflow: ellipsis;
          overflow: hidden;
          -webkit-transition: ease-in .2s;
          transition: ease-in .2s;
          -webkit-transition-property: background-color, color;
          transition-property: background-color, color;
          font-family: EricssonHilda, Helvetica, Arial, sans-serif;
          font-size: 1rem;
          font-weight: normal;
          font-stretch: normal;
          font-style: normal;
          line-height: 1.5;
          letter-spacing: normal;
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
          background-color: rgba(0, 0, 0, 0);
          color: #fafafa;
          border: 1px solid #fafafa
      }
      .eds-btn.secondary-inverse:focus {
          outline: none
      }
      .eds-btn.secondary-inverse:hover {
          cursor: pointer
      }
      .eds-btn.secondary-inverse:focus {
          color: #fafafa
      }
      .eds-btn.secondary-inverse:hover {
          background-color: #fafafa;
          color: #242424
      }
      .eds-btn.secondary-inverse:active {
          background-color: #e0e0e0;
          color: #242424
      }
      .eds-btn.secondary-inverse:disabled,
      .eds-btn.secondary-inverse.disabled {
          cursor: default;
          background-color: rgba(0, 0, 0, 0);
          color: rgba(250, 250, 250, 0.4)
      }
      .touch .eds-btn.secondary-inverse:hover {
          background-color: rgba(0, 0, 0, 0);
          color: #fafafa
      }
      .touch .eds-btn.secondary-inverse:active {
          background-color: #e0e0e0;
          color: #242424
      }
      .eds-btn.secondary-inverse:hover {
          border-color: #fafafa
      }
      .eds-btn.secondary-inverse:active {
          border-color: #e0e0e0
      }
      .eds-btn.secondary-inverse:disabled,
      .eds-btn.secondary-inverse.disabled {
          border-color: rgba(250, 250, 250, 0.4)
      }</style>                    
<style type="text/css">
    .myTable { width:90%; border-collapse:collapse; font-family:EricssonHilda;font-size:0.9rem}
    .myTable th { border-bottom:#a0a0a0 1px solid; line-height: 25px; }
    .myTable td { padding:7px; border-top:#e0e0e0 1px solid; border-bottom:#e0e0e0 1px solid; line-height: 25px; }
    .myTableA { width:50%; border-collapse:collapse; font-family:EricssonHilda;font-size:1rem}
    .myTableA th { border-bottom:#a0a0a0 1px solid; line-height: 25px; }
    .myTableA td { padding:7px; border-top:#e0e0e0 1px solid; border-bottom:#e0e0e0 1px solid; line-height: 25px; }
    p { font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:20px; }
</style>
<style type="text/css">
    .ReadMsgBody {
        width: 100%;
    }
    .ExternalClass {
        width: 100%;
    }
    .ExternalClass {
        line-height: 100%;
    }
    body {
        background-color: #ebebec;
        margin: 0;
        padding: 0;
        -webkit-text-size-adjust: 100%;
        -ms-text-size-adjust: 100%;
    }
    * {
        line-height: 100%;
    }
    table tr td {
        mso-line-height-rule: exactly;
    }
    img {
        border: 0 none;
        height: auto;
        line-height: 100%;
        outline: none;
        text-decoration: none;
        display: block;
    }  
    a img {
        border: 0 none;
    }
    .imageFix {
        display: block;
    }
</style>
<!--[if gte mso 9]>
<style>
li {
    text-indent: -1em; /* Normalise space between bullets and text */
}
</style>
<![endif]-->
</head>
<body bgcolor="#E0E0E0" style="background-color:#E0E0E0;">
<table align="center" bgcolor="#E0E0E0" border="0" cellpadding="0" cellspacing="0" style="background-color:#E0E0E0; margin:0; padding:0" width="100%">
<tr>
<td align="center" width="640" valign="top">
<table align="center" bgcolor="#fafafa" border="0" cellpadding="0" cellspacing="0" width="640">
<!--Banner- Max height limit is 240px, and also placement of the econ with ericsson.com url should be at the top left-->
<!--  <tr>
<td colspan="3" width="640"><img src="http://atvts2505.athtem.eei.ericsson.se/demo-statusmail/S4.png" width="640" border="0"></td>
</tr>-->
<!--End Banner-->
<tr bgcolor="#fafafa">
<td colspan="3"  width="640" style="font-family: Arial, sans-serif; color:black; font-size:12px; line-height: 17px; text-align:left; width:100%; margin-left:10px; vertical-align: text-top;">
<br />
Report generated by $username
<br />
</td>
</tr>
<!--- Status color -->
<!--Start
This section to be used, if there is any Call to Action in your template.
Three column layout.
Copy all 3 rows <tr> in your template.
Background color can be changed according to the design in the first line of tr tag <tr bgcolor="#values">
Do not change any code or styles in respective of tags in tr, td, table, span etc.
-->
<tr bgcolor="$server_status_color">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr bgcolor="$server_status_color">
<td width="20">&nbsp;</td>
<td style="font-family:Arial, Helvetica, sans-serif; color:#fafafa;font-size:14px; line-height:17px; text-transform:uppercase;" valign="top">
<$server_status_H style="margin-top: 20px;text-align:center;">$clusterId $SERVER_STATUS</$server_status_H>
</td>
<td width="20">&nbsp;</td>
</tr>
<tr bgcolor="$server_status_color">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<!--end-->
<!--- Status color -->
<tr bgcolor="#fafafa">
<td height="20" style="line-height:20px" width="20">&nbsp;</td>
<td height="20" style="line-height:20px" width="600">&nbsp;</td>
<td height="20" style="line-height:20px" width="20">&nbsp;</td>
</tr>
<!--Start
Two column layout.
Do not change the Background color in the first line of tr tag <tr bgcolor="#fafafa">
And also do not change any code or styles in respective of tags in tr, td, table, span etc.
-->
<tr bgcolor="#fafafa">
<td height="20" style="line-height:20px" width="20">&nbsp;</td>
<td height="20" style="line-height:20px" width="600">&nbsp;</td>
<td height="20" style="line-height:20px" width="20">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20">&nbsp;</td>
<td width="600" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:14px; text-transform:uppercase;" valign="top">General Information</td>
<td width="20">&nbsp;</td>
</tr> 
<tr bgcolor="#fafafa">
<td height="20" style="line-height:20px" width="20">&nbsp;</td>
<td height="20" style="line-height:20px" width="600">&nbsp;</td>
<td height="20" style="line-height:20px" width="20">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td valign="top" width="20">&nbsp;</td>
<td valign="top" width="600">     
<center>
<table class="myTableA">
<thead>
<tr>
<th></th>
<th></th>
<th></th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>ENM ISO:</strong></td>
<!-- <td></td> -->
<td>$enm_iso_version</td>
</tr>
<tr>
<td><strong>NRM Modules:</strong></td>
<td></td>
</tr>
_EOF


SAVEIFS=$IFS
IFS="|"
for nrm_item in $nrm;do
  echo "<tr>" >>$MAIL_BODY
  nrm_type=$(echo $nrm_item | awk '{print $2}')
  nrm_version=$(echo $nrm_item | awk '{print $1}')
  echo "<td>$nrm_type</td>" >>$MAIL_BODY
  echo "<td>$nrm_version</td>" >>$MAIL_BODY
  echo "</tr>" >>$MAIL_BODY
done
#echo "</td>" >>$MAIL_BODY
#echo "<td>" >>$MAIL_BODY
#for nrm_item in $nrm;do
#  nrm_version=$(echo $nrm_item | awk '{print $1}')
#  echo "<p>$nrm_version</p>" >>$MAIL_BODY
#done
#echo "</td></tr>" >>$MAIL_BODY

echo "<tr><td><strong>NSS Simulations:</strong></td>" >>$MAIL_BODY
echo "<td></td></tr>" >>$MAIL_BODY
#echo "<tr>" >>$MAIL_BODY
nss_version=$(echo $nss_version | sed 's/|/&nbsp;&nbsp;/g')
echo "<tr><td>$nss_version</td>" >>$MAIL_BODY
echo "<td></td></tr>" >>$MAIL_BODY
#for nss_version_item in $nss_version;do	
#  echo "<td>$nss_version_item</td></tr>" >>$MAIL_BODY
#  echo "<tr><td></td>" >>$MAIL_BODY
#done

echo "<tr><td><strong>Genstats:</strong></td>" >>$MAIL_BODY
echo "<td></td></tr>" >>$MAIL_BODY
genstats_version=$(echo $genstats_version | sed 's/|/&nbsp;&nbsp;/g')
echo "<tr><td>$genstats_version</td>" >>$MAIL_BODY
echo "<td></td></tr>" >>$MAIL_BODY

#for genstats_version_item in $genstats_version;do
#  echo "<p>$genstats_version_item</p>" >>$MAIL_BODY
#done
#echo "</td></tr>" >>$MAIL_BODY

IFS=$SAVEIFS

cat <<_EOFnew >>$MAIL_BODY
<tr>
<td><strong>NssUtils:</strong></td>
<td>$nss_utils_version</td>
</tr>
<tr>
<td><strong>TorUtils:</strong></td>
<td>$enm_torutils_version</td>
</tr>
<tr>
<td><strong>Internal TorUtils:</strong></td>
<td>$enm_torutils_int_version</td>
</tr>
<tr>
<td><strong>Synchronized Nodes:</strong></td>
<td>$no_synch_nodes</td>
</tr>
</tbody>
</table>
<center>
_EOFnew

cat <<_EOF1 >>$MAIL_BODY
<table border="0" cellpadding="0" cellspacing="0" width="500">
<tbody>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td colspan="3" width="640" style="border:1px solid #E0E0E0;"></td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:17px;" valign="top" width="185">
<tr bgcolor="#fafafa">
<td width="20">&nbsp;</td>
<td width="600" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:14px; text-transform:uppercase;" valign="top">Status Summary
</td>
<td width="20">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td width="20" valign="top">&nbsp;</td>
<td width="600" valign="top">
<table width="600" border="0" cellpadding="0" cellspacing="0">
<tr>
<!--First column - Image -->
<td width="40" valign="top">
</td>
<!--Space between Two column-->
<td width="20">&nbsp;</td>
<!--Start Second column - Text-->
<td width="500" valign="top">
<table width="460" border="0" cellpadding="0" cellspacing="0">
<!--Headline text-->
<tr>
<td valign="top" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:18px; line-height:22px;"> </td>
</tr>
<!--Spacing-->
<tr>
<td height="5" style="font-size:1px; line-height:10px;">&nbsp;</td>
</tr>
<!--Description/Content-->
<tr>
<td valign="top" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:18px;"> 	
_EOF1

OLD_IFS=$IFS
IFS=$'\n'

for issue in ${HIGHLIGHTED_ISSUES};do
  echo "<p>$issue</p>" >>$MAIL_BODY
done

cat <<_EOFextra >>$MAIL_BODY
</td>
</tr>
<!--Spacing-->
<tr>
<td height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<!--Button with background color #fafafa, border color #4e4e4e, text color #4e4e4e
Do change only the button name according to the context of your design and do not change andy code or styles
Only this button can be used only on the light background-->
<tr>
<td>
</td>
</tr>
</table>
</td>
<!--end of second column-->
</tr>
</table>
</td>
</tr>
</tbody>
</table>
<!-- added ----------------------------------------- -->
<table border="0" cellpadding="0" cellspacing="0" width="500">
<tbody>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td colspan="3" width="640" style="border:1px solid #E0E0E0;"></td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:17px;" valign="top" width="185">
<tr bgcolor="#fafafa">
<td width="20">&nbsp;</td>
<td width="600" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:14px; text-transform:uppercase;" valign="top">DAILY PLANNED ACTIVITIES
</td>
<td width="20">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td width="20" valign="top">&nbsp;</td>
<td width="600" valign="top">
<table width="600" border="0" cellpadding="0" cellspacing="0">
<tr>
<!--First column - Image -->
<td width="40" valign="top">
</td>
<!--Space between Two column-->
<td width="20">&nbsp;</td>
<!--Start Second column - Text-->
<td width="500" valign="top">
<table width="460" border="0" cellpadding="0" cellspacing="0">
<!--Headline text-->
<tr>
<td valign="top" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:18px; line-height:22px;"> </td>
</tr>
<!--Spacing-->
<tr>
<td height="5" style="font-size:1px; line-height:10px;">&nbsp;</td>
</tr>
<!--Description/Content-->
<tr>
<td valign="top" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:18px;"> 	
<p>
Please see <a href="https://eteamspace.internal.ericsson.com/display/CIEED/DE+Test+Services+%3A+Team+Grifone" target="_blank">TEAM GRIFONE DEPLOYMENTS CALENDAR</a> for todays planned activities. 
<br>
<br>
Follow FEM8s11 email notifications sent to ENM RA test leads and ticket reporters and watchers.
</p>
</td>
</tr>
<!--Spacing-->
<tr>
<td height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<!--Button with background color #fafafa, border color #4e4e4e, text color #4e4e4e
Do change only the button name according to the context of your design and do not change andy code or styles
Only this button can be used only on the light background-->
<tr>
<td>
</td>
</tr>
</table>
</td>
<!--end of second column-->
</tr>
</table>
</td>
</tr>
</tbody>
</table>
<table border="0" cellpadding="0" cellspacing="0" width="500">
<tbody>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td colspan="3" width="640" style="border:1px solid #E0E0E0;"></td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:17px;" valign="top" width="185">
<tr bgcolor="#fafafa">
<td width="20">&nbsp;</td>
<td width="600" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:14px; text-transform:uppercase;" valign="top">OMBS BACKUP STATUS
</td>
<td width="20">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td width="20" valign="top">&nbsp;</td>
<td width="600" valign="top">
<table width="600" border="0" cellpadding="0" cellspacing="0">
<tr>
<!--First column - Image -->
<td width="40" valign="top">
</td>
<!--Space between Two column-->
<td width="20">&nbsp;</td>
<!--Start Second column - Text-->
<td width="500" valign="top">
<table width="460" border="0" cellpadding="0" cellspacing="0">
<!--Headline text-->
<tr>
<td valign="top" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:18px; line-height:22px;">
</td>
</tr>
<!--Spacing-->
<tr>
<td height="5" style="font-size:1px; line-height:10px;">
&nbsp;</td>
</tr>
<!--Description/Content-->
<tr>
<td valign="top" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:18px;">
<p>
_EOFextra

if [ $clusterId == "429" ] || [ $clusterId == "623" ] || [ $clusterId == "660" ] || [ $clusterId == "1088" ] || [ $clusterId == "679" ];
then
    for line in ${OMBS_STATUS};do
    echo -e "<p>$line</p>" >>$MAIL_BODY
#     echo <tr><td>$line</td></tr> >>$MAIL_BODY
    done
else 
    echo "<p>OMBS BACKUP NOT APPLICABLE TO THIS DEPLOYMENT AS OF THIS TIME.</p>" >>$MAIL_BODY
fi

cat << _EOFextra2 >>$MAIL_BODY
</p>
</td>
</tr>
<!--Spacing-->
<tr>
<td height="20" style="line-height:20px;">&nbsp;
</td>
</tr>
<!--Button with background color #fafafa, border color #4e4e4e, text color #4e4e4e
Do change only the button name according to the context of your design and do not change andy code or styles
Only this button can be used only on the light background-->
<tr>
<td>
</td>
</tr>
</table>
</td>
<!--end of third column-->
</tr>
</table>
</td>
</tr>
</tbody>
</table>
<!-- added ----------------------------------------- -->
</td>
<td valign="top" width="20">&nbsp;</td>
</tr>
<!--Start Two column layout
With Image on Left side image and text on right side
Image dimension - 290px X 190px
Replace this image URL in your code "https://dummyimage.com/290x190/181818/fff"-->

<!--Start
Section divider, do not change any values or code-->
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td colspan="3" width="640" style="border:1px solid #E0E0E0;"></td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<!--End section divider-->
<!--Start
ADs or Banner placement
Image Dimensions - 640px X 150px
Replace this image url in your code "tps://dummyimage.com/600x150/181818/ffffff&text=Ads/Banner+Placeholder+-+640x150"-->
<tr>
<td colspan="3">
<!-- center><img align="center" src="http://atvts2505.athtem.eei.ericsson.se/demo-statusmail/nagios.png" border="0"></center -->
</td>
</tr>
<!--end-->
<!--Start Two column layout with Small thumb Image on left side and text on right side
Between these 2 column, space width will be 20px
Image dimension - 185px X 150px
Replace this image URL in your code "https://dummyimage.com/185x150/181818/fff"-->
<!--Change the section headline text according to your design and do change any code or style-->
<!--Start One column layout with bullet points-->
<!--Change the section headline text according to your design and do change any code or style-->
<tr bgcolor="#fafafa">
<td width="20">&nbsp;</td>
<td width="600" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:14px; text-transform:uppercase;" valign="top">Nagios Warning / Critical Checks</td>
<td width="20">&nbsp;</td>
</tr> 
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20">&nbsp;</td>
<td width="600" valign="top">
<table width="600" border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td width="60">&nbsp;</td>
<td width="570" valign="top" style="font-family:Arial, Helvetica, sans-serif; color:#181818; font-size:14px; line-height:27px;">
<table class="myTable">
<thead>
<tr>
<th></th>
</tr>
</thead>
<tbody>
_EOFextra2

IFS=$OLD_IFS

#echo "<tr>" >>$MAIL_BODY
if [[ $NAGIOS_STATUS == "true" ]];then
  #echo "<td>" >>$MAIL_BODY
  for m in "${array_status_nagios[@]}";do
    echo "<tr><td>$m</td></tr>" >>$MAIL_BODY
  done
  #echo "</td>" >>$MAIL_BODY
fi
#echo "</td>" >>$MAIL_BODY

cat <<_EOF2 >>$MAIL_BODY

</tbody>
</table>
</td>
<td width="15">&nbsp;</td>
</tr>
</tbody>
</table>
</td>
<td width="20">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td colspan="3" width="640" style="border:1px solid #E0E0E0;"></td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<!--Start
ADs or Banner placement
Image Dimensions - 640px X 150px
Replace this image url in your code "tps://dummyimage.com/600x150/181818/ffffff&text=Ads/Banner+Placeholder+-+640x150"-->
<tr>
<td colspan="3">
<!-- center><img src="http://atvts2505.athtem.eei.ericsson.se/demo-statusmail/jira.png" border="0"></center -->
</td>
</tr>
<!--end-->
<tr bgcolor="#fafafa">
<td width="20">&nbsp;</td>
<td width="600" style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:14px; text-transform:uppercase;" valign="top">Current open issues on deployment</td>
<td width="20">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20">&nbsp;</td>
<td width="600" valign="top">
<table width="600" border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td width="60">&nbsp;</td>
<td width="570" valign="top" style="font-family:Arial, Helvetica, sans-serif; color:#181818; font-size:14px; line-height:27px;">
<table class="myTable">
<thead>
<tr>
<th></th>
</tr>
</thead>
<tbody>
_EOF2

OLD_IFS=$IFS
IFS=$'\n'


for support_ticket in ${OPEN_SUPPORT_TICKETS};do  

IFS='=' # space is set as delimiter
read -ra ADDR <<< "$support_ticket" # str is read into an array as tokens separated by IFS
echo "<tr><td><a href="${ADDR[0]}" target="_blank">${ADDR[2]}</a> </td></tr>">>$MAIL_BODY
 
  IFS=$'\n'
done

IFS=$OLD_IFS

n=0

for i in "${array_open_tickets[@]}";do
  echo "<tr><td>${array_open_tickets_summaries[$n]}<br />$i</td></tr>" >>$MAIL_BODY
  n=$((n + 1))
done

cat <<_EOF0 >>$MAIL_BODY

</tbody>
</table>
</td>
<td width="15">&nbsp;</td>
</tr>
</tbody>
</table>
</td>
<td width="20">&nbsp;</td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<!--Start
Section divider, do not change any values or code-->
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td colspan="3" width="640" style="border:1px solid #E0E0E0;"></td>
</tr>
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<!--End section divider-->
<!--Start Two column layout
With Image on Left side image and text on right side
Image dimension - 290px X 190px
Replace this image URL in your code "https://dummyimage.com/290x190/181818/fff"-->
<!--End of Two column layout-->
<tr bgcolor="#fafafa">
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
<td width="600" height="20" style="line-height:20px;">&nbsp;</td>
<td width="20" height="20" style="line-height:20px;">&nbsp;</td>
</tr>
<tr>
<td height="20" colspan="3" width="640" bgcolor="#181818"></td>
</tr>
<tr bgcolor="#181818">
<td width="20">&nbsp;</td>
<td width="600" valign="top">
<table border="0" cellpadding="0" cellspacing="0" width="600">
<tr>
<td width="135" valign="top" align="left">
</td>
<td width="20">&nbsp;</td>
<td width="445" valign="top">
<table width="445" border="0" align="center" cellpadding="0" cellspacing="0">
<tbody>
<!--content-->
<tr>
<!--First column - Image -->
<!--<td valign="top"><center><img src="http://atvts2505.athtem.eei.ericsson.se/demo-statusmail/Helpdesk-white.png" alt="" border="0" width="60" height="60"></center>
</td>-->
<td align="left" style="font-family: Arial, sans-serif; color:#fafafa; font-size:12px; line-height: 17px;">
<br />
For more information please contact: 
<a href="https://eteamspace.internal.ericsson.com/display/CIEED/DE+Test+Services+%3A+Team+Grifone" target="_blank">Team Grifone</a> 
</td>
</tr>
<!--end content-->
<!--Spacing-->
<tr>
<td height="10" style="line-height:10px;">&nbsp;</td>
</tr>
</tbody>
</table>
</td>
</tr>
</table>
</td>
<td width="20">&nbsp;</td>
</tr>
<tr>
<td height="20" colspan="3" width="640" bgcolor="#181818"></td>
</tr>
</table>
</td>
</tr>
</table>
</body>

</html>

_EOF0



#cat $MAIL_BODY
