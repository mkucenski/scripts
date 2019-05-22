#!/usr/bin/env bash
#. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

LOCATION="$1"
if [ -z "$LOCATION" ]; then
	LOCATION="./"
fi
open "$LOCATION"

