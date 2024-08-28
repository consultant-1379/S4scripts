#!/bin/bash

MAIL_BODY=${1}
Summary="${2}"
TeamMembersOnCall=${3}
WeekNumber=${4}
username=${5}
ExtraOnCall=${6}

cat <<_EOF >>$MAIL_BODY
<!DOCTYPE html>
<html lang="en">
 <body bgcolor="#E0E0E0" style="background-color:#E0E0E0;">
<table style="height: 527px; width: 600px; border-collapse: collapse;" border="0" align="center">
<tbody>
<tr>
<td style="text-align: center; background-color: #0082f0; padding: 20px;">
<h2><strong><span style="color: #ffffff;">GRIFONE PHYSICAL TESTS DEPLOYMENTS</span></strong></h2>
<p><strong><span style="color: #ffffff;">WEEKEND ON CALL REPORT - WEEK: $WeekNumber</span></strong></p>
</td>
</tr>
<tr>
<td style="padding: 10px 50px; background-color: #ffffff;">
<p><strong>Summary of Activities</strong></p>
</td>
</tr>
<tr>
<td style="width: 498px; background-color: #ffffff; padding: 0px 50px; text-align: justify;">
_EOF

echo "$Summary" | while IFS= read -r line;do 
  cat <<_EOF >>$MAIL_BODY
<p style="margin: 0px;">$line</p>
_EOF
done

cat <<_EOF >>$MAIL_BODY
</td>
</tr>
<!--<tr style="height: 46px;">-->
<tr>
<td style="background-color: #ffffff; padding-top: 30px; padding-left: 50px;">
<p><strong>Team Member(s) On Call: </strong>$TeamMembersOnCall</p>
</td>
</tr>
<tr>
<td style="padding: 10px 50px; background-color: #ffffff;">
<p><strong>Additional Team Member(s) On Call: </strong>$ExtraOnCall</p>
</td>
</tr>
<tr>
<td style="padding: 10px 50px; background-color: #181818; color: #ffffff; text-align: center;">
<p>For more information please contact: <a href="mailto: PDLTEAMGRI@pdl.internal.ericsson.com">Team Grifone</a></p>
</td>
</tr>
</tbody>
</table>
    </body>
</html>
_EOF
