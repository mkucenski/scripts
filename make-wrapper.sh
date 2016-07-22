#!/bin/bash

LOG=~/Logs/make-install.log

echo "" >> "$LOG"
echo "BEGIN: `date \"+%Y%m%d\"`" >> "$LOG"

echo "Working Directory: `pwd`" >> "$LOG"
echo "" >> "$LOG"

make "$@" 2>&1 | tee -a "$LOG"

echo "END: `date \"+%Y%m%d\"`" >> "$LOG"

