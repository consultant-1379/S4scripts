#!/bin/sh
# Author: Nobody Team
VERSION=1

dump_header() {
  date +"=== %D %T - $hn - $* ==="
}

if [ $# -eq 0 ]; then
  start_paths=/
else
  start_paths=$*
fi

tmpscript="/tmp/do_log4jscan.$$.sh"
cat << EOTT > $tmpscript
#!/bin/sh
infile=\$1
workarea=/tmp/scan_ear_and_war_workarea
ext=\$(echo \$infile | awk -vFS=. '{ print tolower(\$NF) }')
if [ \$ext != jar ]; then
  unzip -v \$infile | fgrep -i -e jar -e war  > /dev/null
  if [  \$? -eq 0 ]; then
    if  [ ! -d  \$workarea ]; then
      mkdir -p \$workarea
    fi
    cd \$workarea
    if [ \$PWD != / ]; then
      rm -rf *
    fi
    unzip \$infile > /dev/null
    # Searches for class in jar/ear/war
    find . -type f -regextype posix-egrep -iregex ".*[.](jar|war|ear)" -print -exec unzip -l {} \; | awk -vinfile=\$infile '{ if (\$1=="Archive:") name=\$2 ; sub("./","",name);
        found=0
        file_to_check=tolower(\$NF)
        if (index(file_to_check,"jndilookup.class")) found=1
        if (index(file_to_check,"jndimanager.class")) found=1
        if (index(file_to_check,"jmsappender.class")) found=1
        if (found) print "FOUND!" infile ">>" name ":" \$NF}'
    # Searches for class in ear/war
    find . -type f -name "*.class" -print  | awk -vinfile=\$infile '{
        found=0
        file_to_check=tolower(\$NF)
        if (index(file_to_check,"jndilookup.class")) found=1
        if (index(file_to_check,"jndimanager.class")) found=1
        if (index(file_to_check,"jmsappender.class")) found=1
        if (found) print "FOUND!" infile ">>" \$0 ":" \$NF}'
    # check for recursive ear/war in ear/war ....
    find . -type f -regextype posix-egrep -iregex ".*[.](war|ear)" -print | awk -vinfile=\$infile '{ print "WARNING!ear/war in ear/war >>" infile ":" \$0 }'
  fi
else
  if [ \$infile != jar ]; then
    # Searches in single jar file
    unzip -l \$infile | awk '{ if (\$1=="Archive:") name=\$2 ;
        found=0
        file_to_check=tolower(\$NF)
        if (index(file_to_check,"jndilookup.class")) found=1
        if (index(file_to_check,"jndimanager.class")) found=1
        if (index(file_to_check,"jmsappender.class")) found=1
        if (found) print "FOUND!" name ":" \$NF}'
  fi
fi
EOTT
chmod 755 $tmpscript

hn=$(hostname)
scriptname=$(basename $0)
scriptsum=$(md5sum $0 | awk '{ print $1 }')
dump_header "Scan started from [$start_paths] with script $scriptname v. $VERSION ($scriptsum)"
for scan_path in $start_paths  ; do
  find $scan_path -type f -regextype posix-egrep -iregex ".*[.](jar|war|ear)"  -exec $tmpscript {} \;
done
rm $tmpscript
rm -rf $workarea
dump_header "Scan Script completed"
