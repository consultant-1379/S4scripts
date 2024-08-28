#!/bin/sh
ALERT=80
df -k | tr -s ' ' | cut -d" " -f 5 | grep -i %| tail -n +2 | awk '{ print $1}' | cut -d'%' -f1  | while read output;
do

  #echo $output
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $output -ge $ALERT ]; then
         df -P | awk '0+$5 >= 80 {print}' >> Spacemail.txt
  fi
done

echo 'Warning: Please see the below file systems which are running out of space:' | cat - Spacemail.txt > temp && mv temp Spacemail.txt
mail -s '623 above threshold' enrico.alletto@ericsson.com,ian.flood@ericsson.com,kalpana.archakam@tcs.com,luca.minetti@ericsson.com,maheswari.vallabhaneni@tcs.com,manoj.v5@tcs.com,poojitha.a@tcs.com,sourav.b.das@ericsson.com,stefano.a.manni@ericsson.com,sureshreddy.p@tcs.com,vahed.abdul@tcs.com,vincenzo.volpe@ericsson.com < Spacemail.txt

rm Spacemail.txt

