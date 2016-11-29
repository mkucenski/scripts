#!/bin/sh

date
echo

echo "sw_vers - Show Mac OS X operating system version"
echo "----------------------------------------------------------------"
sw_vers
echo

echo "uname - Show operating system name and more"
echo "----------------------------------------------------------------"
uname -a
echo

echo "system_profiler - Show Apple hardware and software configuration"
echo "----------------------------------------------------------------"
#system_profiler -detaillevel full
echo

echo "Reference Source Script: $0"
echo "----------------------------------------------------------------"
cat "$0"
echo

