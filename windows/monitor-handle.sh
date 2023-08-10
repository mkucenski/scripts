#!/bin/bash

PID="$1"
FREQ="$2"

./monitor-process-output.sh "/cygdrive/z/Downloads/microsoft.com/SysInternals\ Suite/SysInternals\ x64/handle64.exe -a -p $PID" $FREQ
