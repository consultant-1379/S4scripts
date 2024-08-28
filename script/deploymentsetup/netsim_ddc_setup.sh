#!/bin/bash

netsims="ieatnetsimv15535 ieatnetsimv15536 ieatnetsimv15561 ieatnetsimv15562 ieatnetsimv15563 ieatnetsimv15564 ieatnetsimv15565 ieatnetsimv15566 ieatnetsimv15567 ieatnetsimv15568 ieatnetsimv15569 ieatnetsimv15570 ieatnetsimv15571 ieatnetsimv15572 ieatnetsimv15573 ieatnetsimv15574 ieatnetsimv15575 ieatnetsimv15576 ieatnetsimv15577 ieatnetsimv15578 ieatnetsimv15579 ieatnetsimv15580 ieatnetsimv15581 ieatnetsimv15582 ieatnetsimv15583 ieatnetsimv15584 ieatnetsimv15585 ieatnetsimv15586 ieatnetsimv15587 ieatnetsimv15588 ieatnetsimv15589 ieatnetsimv15599 ieatnetsimv15600 ieatnetsimv15601 ieatnetsimv15602 ieatnetsimv15603 ieatnetsimv15604 ieatnetsimv15605 ieatnetsimv15606 ieatnetsimv15607 ieatnetsimv15608 ieatnetsimv15609 ieatnetsimv15610 ieatnetsimv15611 ieatnetsimv15612 ieatnetsimv15613 ieatnetsimv15614 ieatnetsimv15615 ieatnetsimv15616 ieatnetsimv15617 ieatnetsimv15618 ieatnetsimv15619 ieatnetsimv15620 ieatnetsimv15621 ieatnetsimv15622 ieatnetsimv15623 ieatnetsimv15624 ieatnetsimv15625 ieatnetsimv15626 ieatnetsimv15627 ieatnetsimv15628 ieatnetsimv15629 ieatnetsimv15630 ieatnetsimv15631 ieatnetsimv15632 ieatnetsimv15633 ieatnetsimv15634 ieatnetsimv15635 ieatnetsimv15636 ieatnetsimv15637 ieatnetsimv15638 ieatnetsimv15639 ieatnetsimv16943 ieatnetsimv16944 ieatnetsimv16945 ieatnetsimv16946 ieatnetsimv16972 ieatnetsimv16973 ieatnetsimv16974 ieatnetsimv16975 ieatnetsimv16976 ieatnetsimv16977 ieatnetsimv16978 ieatnetsimv16979 ieatnetsimv16980 ieatnetsimv16981 ieatnetsimv16982 ieatnetsimv16983 ieatnetsimv16984 ieatnetsimv16985 ieatnetsimv16986 ieatnetsimv16987 ieatnetsimv16988 ieatnetsimv16989 ieatnetsimv16990 ieatnetsimv16991 ieatnetsimv16992 ieatnetsimv16993 ieatnetsimv16994 ieatnetsimv16995 ieatnetsimv16996 ieatnetsimv16997 ieatnetsimv16998 ieatnetsimv16999 ieatnetsimv17000 ieatnetsimv17001 ieatnetsimv17002 ieatnetsimv17003 ieatnetsimv17004 ieatnetsimv17005 ieatnetsimv17006 ieatnetsimv17007 ieatnetsimv17008 ieatnetsimv17009 ieatnetsimv17010 ieatnetsimv17011 ieatnetsimv17012 ieatnetsimv17013 ieatnetsimv17014 ieatnetsimv17015 ieatnetsimv17016 ieatnetsimv17017 ieatnetsimv17018 ieatnetsimv17019 ieatnetsimv17020 ieatnetsimv17021 ieatnetsimv17022 ieatnetsimv17023 ieatnetsimv17024 ieatnetsimv17025 ieatnetsimv17026 ieatnetsimv17027 ieatnetsimv17028"

#netsims="ieatnetsimv15588 ieatnetsimv15589"

#netsims=$(wget -q -O - --no-check-certificate "https://ci-portal.seli.wh.rnd.internal.ericsson.com/generateTAFHostPropertiesJSON/?clusterId=623&tunnel=true&pretty=true&allNetsims=true" | grep netsim | grep hostname | awk -F"\"" '{print $4}' | sort | tr '\n' ' ')

for netsim in $netsims;do
  echo $netsim
  sshpass -p shroot ssh root@$netsim "rpm -qa | grep ERICddccore_CXP9035927;cd /tmp;curl -O https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/content/repositories/releases/com/ericsson/oss/itpf/monitoring/ERICddccore_CXP9035927/2.24.1/ERICddccore_CXP9035927-2.24.1.rpm;yum install -y ERICddccore_CXP9035927-2.24.1.rpm;service ddc restart"
done

