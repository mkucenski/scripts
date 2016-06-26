#!/bin/bash

vms=`lsof -nP | grep "Blue Passport/Virtual Machines"`

if [ -z "$vms" ]; then
	echo "return was null and therefore vmware not running"
else
	echo "return was not null--running?"
	echo "$vms"
fi

