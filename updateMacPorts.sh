#!/bin/sh

LOG=~/Logs/installed_ports.log

date "+%Y%m%d" >> "$LOG"
echo "Updating all port system and all outdated, previously installed ports...." | tee -a "$LOG"
port installed >> "$LOG" 
port -d selfupdate 2>&1 | tee -a "$LOG"
port fetch outdated
port -ucp upgrade outdated | tee -a "$LOG"
port installed >> "$LOG"
echo "Done with upgrade/updates!" | tee -a "$LOG"
date "+%Y%m%d" >> "$LOG"

