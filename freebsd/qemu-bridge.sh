#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

# This script must get run as root.  I wasn't able to figure out a way for non-root users
# to add the tap interface to the bridge.  Setting this script to setuid root did not seem
# to help.
if [ $(CHECK_ROOT) != true ]; then
	ERROR "This script *MUST* be run as 'root'!" && exit 1
fi

HOSTNIC=em0
BRIDGE=bridge0

if ifconfig $BRIDGE create up > /dev/null 2>&1; then
	echo "Created $BRIDGE..."
else
	if ifconfig $BRIDGE > /dev/null 2>&1; then
		echo "$BRIDGE already exists..."
	else
		echo "Error creating $BRIDGE..."
	fi
fi

if ifconfig $BRIDGE addm $HOSTNIC > /dev/null 2>&1; then
	echo "Added $HOSTNIC to $BRIDGE..."
else
	echo "Error adding $HOSTNIC to $BRIDGE.  May already be a member..."
fi

if ifconfig $BRIDGE addm $1 > /dev/null 2>&1; then
	echo "Added $1 to $BRIDGE..."
else
	echo "Error adding $1 to $BRIDGE.  May already be a member..."
fi

