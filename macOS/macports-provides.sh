#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE="$(FULL_PATH "$1")"
port provides "$FILE"

