#!/bin/bash

LOG="`echo ~`/Logs/make-wrapper.log"

echo "" >> "$LOG"
echo "BEGIN: `date \"+%Y%m%d\"`" >> "$LOG"
echo "Working Directory: `pwd`" >> "$LOG"
echo "Args: $@" >> "$LOG"
echo "" >> "$LOG"

make "$@" 2>&1 | tee -a "$LOG"

echo "END: `date \"+%Y%m%d\"`" >> "$LOG"

