#!/bin/sh

PORT="$1"

LOG=~/Logs/installed_ports.log

date "+%Y%m%d" >> "$LOG"
echo "Uninstalling port ($PORT)..." | tee -a "$LOG"
port uninstall "$PORT" 2>&1 | tee -a "$LOG"
echo "Done uninstalling port ($PORT)!" | tee -a "$LOG"
date "+%Y%m%d" >> "$LOG"

