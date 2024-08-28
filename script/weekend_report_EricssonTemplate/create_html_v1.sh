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
<!DOCTYPE html>
<html>

<head>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type">
    <title>Outlook - Newsletter</title>
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
_EOF
if [ ! -z "$ExtraOnCall" ]
	then
	cat <<_EOF >>$MAIL_BODY

<body bgcolor="#E0E0E0" style="background-color:#E0E0E0;">
    <table align="center" bgcolor="#E0E0E0" border="0" cellpadding="0" cellspacing="0" style="background-color:#E0E0E0; margin:0; padding:0" width="100%">
        <tr>
            <td align="center" width="640">
                <table align="center" bgcolor="#fafafa" border="0" cellpadding="0" cellspacing="0" width="640">
                    <tr>
                        <td colspan="3" width="640"><img src="http://atvts2505.athtem.eei.ericsson.se/demo-statusmail/S4.png" width="640" border="0"></td>
                    </tr>
                    <tr bgcolor="#0082F0">
                        <td width="20" height="20" style="line-height:20px;">&nbsp;</td>
                        <td width="600" height="20" style="line-height:20px;">&nbsp;</td>
                        <td width="20" height="20" style="line-height:20px;">&nbsp;</td>
                    </tr>
                    <tr bgcolor="#0082F0">
                        <td width="20">&nbsp;</td>
                        <td width="600" valign="top">
                            <table border="0" cellpadding="0" cellspacing="0" width="600" style="padding-bottom: 30px;">
                                <tbody>
                                    <tr>
                                        <td style="font-family:Arial, Helvetica, sans-serif; color:#fafafa;font-size:14px; line-height:17px;" valign="top" width="185">
                                            <table border="0" cellpadding="0" cellspacing="0" width="185">
                                                <tr>
                                                    <td style="font-family:Arial, Helvetica, sans-serif; color:#fafafa;font-size:14px; line-height:17px; text-transform:uppercase;" valign="top">Weekend On Call Report
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="20" style="line-height:20px;">&nbsp;</td>
                                                </tr>
                                            </table>

										</td>
                                        <td width="20">&nbsp;</td>
                                        <td style="font-family:Arial, Helvetica, sans-serif; color:#fafafa;font-size:14px; line-height:17px;" valign="top" width="185">
                                            <table border="0" cellpadding="0" cellspacing="0" width="185">
                                                <tr>
                                                    <td style="font-family:Arial, Helvetica, sans-serif; color:#fafafa;font-size:14px; line-height:17px;" valign="top">Week $WeekNumber On Call
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="20" style="line-height:20px;">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td>
                                                                    <table cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td align="center" bgcolor="#0082F0" height="43" style="border: 1px solid #fafafa; color: #fafafa; display: block;" width="100">
																			<a href="#" style="font-size:13px; font-weight: normal; font-family:sans-serif; text-decoration: none; line-height:normal; width:100%; padding-top: 5px; display:inline-block">
																			<span style="color: #fafafa;">$S4TeamMembersOnCall</span>
																			</a></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="20">&nbsp;</td>
                                        <td style="font-family:Arial, Helvetica, sans-serif; color:#fafafa;font-size:14px; line-height:17px;" valign="top" width="185">
                                            <table border="0" cellpadding="0" cellspacing="0" width="185">
                                                <tr>
                                                    <td style="font-family:Arial, Helvetica, sans-serif; color:#fafafa;font-size:14px; line-height:17px;" valign="top">Additional Support From
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="20" style="line-height:20px;">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td style="font-family:Arial, Helvetica, sans-serif; color:#fafafa;font-size:14px; line-height:17px;">$ExtraOnCall</td>
                                                            </tr>
                                                        </table>
													</td>
                                                </tr>
                                            </table>
										</td>
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
		Summary=$Summaryc15a014
		Deployment="Deployment c15a014"
	fi
	
	if [ ! -z "$Ticket" ]
	then
		cat <<_EOF >>$MAIL_BODY
                </td>
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
                            <table border="0" cellpadding="0" cellspacing="0" width="600">
                                <tbody>
                                    <tr>
                                        <td style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:17px;" valign="top" width="185">
                                            <table border="0" cellpadding="0" cellspacing="0" width="185">
                                                <tr>
		<td style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:15px; line-height:20px;" valign="top"><br><p><center>$Deployment</center></p></td>
                                                </tr>
                                                <tr>
                                                    <td height="20" style="line-height:20px;">&nbsp;</td>
                                                </tr>
                                            </table>
                                        </td>

                                        <td width="20">&nbsp;</td>
                                        <td style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:17px;" valign="top" width="390">
                                    		<table border="0" cellpadding="0" cellspacing="0" width="390">
                                                <tr> <td>
                                                        <h3><a href="https://jira-oss.seli.wh.rnd.internal.ericsson.com/browse/$Ticket" target="_blank">$Ticket</a></h3>
                                                    </td></tr>

                                                    <tr><td colspan="3" width="640" style="padding-bottom: 20px;"></td></tr>

                                                    <tr>
                                                        <td colspan="3" width="640" style="border:1px solid #E0E0E0;"></td>
                                                    </tr>
_EOF
	for element in "${Activities[@]}"
	do
		cat <<_EOF >>$MAIL_BODY

			   <tr><td style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:30px;" valign="top">$element</td></tr>
_EOF
	done
			cat <<_EOF >>$MAIL_BODY

 <tr><td style="padding-bottom: 20px;"></td></tr>

   <tr>
      <td colspan="3" width="640" style="border:1px solid #E0E0E0;"></td>
    </tr>
    	<tr> <td style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:30px; padding-top: 20px;"><h3>Summary:</h3>
		<p style="font-family:Arial, Helvetica, sans-serif; color:#181818;font-size:14px; line-height:20px;">$Summary</p>
		</td></tr>
	</table>
        	</td>
			</tr>
        </tbody>
     </table>
				<table border="0" cellpadding="0" cellspacing="0" width="600">

                   <tr><td style="padding-bottom: 20px;"></td></tr>

                            <tr>
                                <td colspan="3" width="640" style="border:1px solid #E0E0E0;"></td>
                            </tr>
                        </table>

   
_EOF
	fi
done

cat <<_EOF >>$MAIL_BODY
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
                                    <td valign="top"><center><img src="http://atvts2505.athtem.eei.ericsson.se/demo-statusmail/Helpdesk-white.png" alt="" border="0" width="60" height="60"></center>
                                    </td>
                                                    <td align="left" style="font-family: Arial, sans-serif; color:#fafafa; font-size:12px; line-height: 17px;">
                                                         <br>
                                                        Report generated by Team S4  
                                                        <br>
                                                        <a style="color: #fafafa;" href="https://confluence-oss.seli.wh.rnd.internal.ericsson.com/pages/viewpage.action?pageId=96996108" target="_blank">TEaaS S4</a> 
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
_EOF
