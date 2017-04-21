#!/bin/bash

LOG="`echo ~`/Logs/macports-wrapper.log"

echo "BEGIN: `date \"+%Y%m%d\"`" >> "$LOG"
echo "Working Directory: `pwd`" >> "$LOG"
echo "Args: $@" >> "$LOG"
echo "" >> "$LOG"

port "$@" 2>&1 | tee -a "$LOG"

echo "END: `date \"+%Y%m%d\"`" >> "$LOG"
echo "" >> "$LOG"

