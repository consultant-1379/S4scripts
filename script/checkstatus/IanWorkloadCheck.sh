#!/bin/sh

touch IanTest.txt
echo '_______________________________' >> IanTest.txt
echo 'Profiles Which are In Error State' >> IanTest.txt
echo '________________________________' >> IanTest.txt
ssh root@ieatwlvm9034.athtem.eei.ericsson.se /opt/ericsson/enmutils/bin/workload status | awk '{print $1 "       " $3}' | grep ERROR | strings >> IanTest.txt

echo '_______________________________' >> IanTest.txt
echo 'Profiles Which are NOT running and SHOULD BE' >> IanTest.txt
echo '________________________________' >> IanTest.txt
touch WLProfiles.txt
ssh root@ieatwlvm5116.athtem.eei.ericsson.se /opt/ericsson/enmutils/bin/workload status | awk '{print $1}' | strings >> WLProfiles.txt
`bash -c "comm -13 <(sort -u WLProfiles.txt) <(sort -u ProfileReference.txt) >> IanTest.txt" ` ;
rm WLProfiles.txt

mail -s '623 Profiles in Error State' enrico.alletto@ericsson.com,ian.flood@ericsson.com,kalpana.archakam@tcs.com,luca.minetti@ericsson.com,maheswari.vallabhaneni@tcs.com,manoj.v5@tcs.com,poojitha.a@tcs.com,sourav.b.das@ericsson.com,stefano.a.manni@ericsson.com,sureshreddy.p@tcs.com,vahed.abdul@tcs.com,vincenzo.volpe@ericsson.com < IanTest.txt
rm IanTest.txt

