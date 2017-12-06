#!/usr/bin/env bash

interface=$1
datetime=`date -j +%G%m%d%H%M%S`
argus -i fxp1 -P 561 -d -w /usr/local/var/sessioncap/argus_$interface_$datetime

