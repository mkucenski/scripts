#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

echo "$1"
echo "$(FULL_PATH "$1")"


