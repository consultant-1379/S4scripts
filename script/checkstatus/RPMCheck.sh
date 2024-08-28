#!/bin/bash

fill_today () {

	echo 'LMS: ' >> /var/tmp/IanScript/rpmtoday.txt
	rpm -qa >> /var/tmp/IanScript/rpmtoday.txt
    	find /var/www/html | grep -i rpm >> /var/tmp/IanScript/rpmtoday.txt


	echo 'SVC1: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@svc-1 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'SVC2: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@svc-2 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt
	
	echo 'SVC3: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@svc-3 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'SVC4: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@svc-4 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

 	echo 'SVC5: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@svc-5 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt       

	echo 'SVC6: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@svc-6 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'SVC7: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@svc-7 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'SVC8: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@svc-8 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'SVC9: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@svc-9 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'SVC10: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@svc-10 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'SCP1: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@scp-1 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'SCP2: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@scp-2 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'SCP3: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@scp-3 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'SCP4: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@scp-4 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'DB1: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@db-1 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'DB2: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@db-2 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'DB3: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@db-3 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt

	echo 'DB4: ' >> /var/tmp/IanScript/rpmtoday.txt
	ssh litp-admin@db-4 "rpm -qa" >> /var/tmp/IanScript/rpmtoday.txt
}


FILE=/var/tmp/IanScript/rpmyesterday.txt
if test -f "$FILE"; then
    echo "$FILE exist"
    touch /var/tmp/IanScript/rpmtoday.txt
    #rpm -qa > /var/tmp/IanScript/rpmtoday.txt
    #find /var/www/html | grep -i rpm >> /var/tmp/IanScript/rpmtoday.txt
    fill_today
else
    touch /var/tmp/IanScript/rpmyesterday.txt
    rpm -qa > /var/tmp/IanScript/rpmyesterday.txt
    find /var/www/html | grep -i rpm >> /var/tmp/IanScript/rpmyesterday.txt
fi

if [ "$(md5sum < /var/tmp/IanScript/rpmyesterday.txt)" = "$(md5sum < /var/tmp/IanScript/rpmtoday.txt)" ]; then
    mail -s '623 Report' enrico.alletto@ericsson.com,ian.flood@ericsson.com,kalpana.archakam@tcs.com,luca.minetti@ericsson.com,maheswari.vallabhaneni@tcs.com,manoj.v5@tcs.com,poojitha.a@tcs.com,sourav.b.das@ericsson.com,stefano.a.manni@ericsson.com,sureshreddy.p@tcs.com,vahed.abdul@tcs.com,vincenzo.volpe@ericsson.com <<< "No RPMs have been changed today"
    rm /var/tmp/IanScript/rpmyesterday.txt
    mv /var/tmp/IanScript/rpmtoday.txt /var/tmp/IanScript/rpmyesterday.txt
else
    diff /var/tmp/IanScript/rpmyesterday.txt /var/tmp/IanScript/rpmtoday.txt > /var/tmp/IanScript/rpmchange.txt
    mail -s '623 Warning: RPMs have changed' enrico.alletto@ericsson.com,ian.flood@ericsson.com,kalpana.archakam@tcs.com,luca.minetti@ericsson.com,maheswari.vallabhaneni@tcs.com,manoj.v5@tcs.com,poojitha.a@tcs.com,sourav.b.das@ericsson.com,stefano.a.manni@ericsson.com,sureshreddy.p@tcs.com,vahed.abdul@tcs.com,vincenzo.volpe@ericsson.com < /var/tmp/IanScript/rpmchange.txt
    rm /var/tmp/IanScript/rpmyesterday.txt
    mv /var/tmp/IanScript/rpmtoday.txt /var/tmp/IanScript/rpmyesterday.txt
    rm /var/tmp/IanScript/rpmchange.txt
fi


