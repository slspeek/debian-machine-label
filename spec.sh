#!/bin/bash
export LANG=en_US.UTF-8
DEBIAN_VERSION=$(cat /etc/debian_version)
CPUMODEL=$(inxi --cpu -y1|grep model|cut -d: -f2-|cut -c2-)
DISKTYPE=$(inxi -Dxxx -y1|grep type|cut -d: -f2-|cut -c2-)
DISKSIZE=$(inxi -Dxxx -y1|grep total|cut -d: -f2-|cut -c2-)
MEMSIZE=$(free -h|grep Mem|cut -c16-|cut -d' ' -f1|sed -e 's/Gi/ GiB/')
MEMTYPE=$(sudo inxi --memory-modules -y1 |grep type|cut -d: -f2-|cut -c2-)
USERNAME=$(id -nu 1000)
PROBE_CMD=${PROBE_CMD:-sudo hw-probe -all -upload}

# echo $PROBE_CMD
# exit 0

cat > $BUILD/spec.tex <<EOF
\newcommand{\bootmenukey}{$BOOTMENUKEY}
\newcommand{\disksize}{$DISKSIZE}
\newcommand{\disktype}{$DISKTYPE}
\newcommand{\corecount}{$CORECOUNT}
\newcommand{\memsize}{$MEMSIZE}
\newcommand{\memtype}{$MEMTYPE}
\newcommand{\debianversion}{$DEBIAN_VERSION}
\newcommand{\cpumodel}{$CPUMODEL}
\newcommand{\graphics}{$GRAPHICS}
\newcommand{\username}{$USERNAME}
\newcommand{\password}{$PASSWORD}
EOF


qrencode -o $BUILD/qr-hw-probe.png $($PROBE_CMD|grep 'Probe URL:'|cut -d: -f2-|cut -c2-)