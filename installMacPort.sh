#!/bin/sh

PORT="$1"

LOG=~/Logs/installed_ports.log

date "+%Y%m%d" >> "$LOG"
echo "Installing port ($PORT)..." | tee -a "$LOG"
port fetch "$PORT" 2>&1 | tee -a "$LOG"
port -ucp install "$PORT" 2>&1 | tee -a "$LOG"
echo "Done installing port ($PORT)!" | tee -a "$LOG"
date "+%Y%m%d" >> "$LOG"

