#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

"$SEDCMD" -r 's/(.*)/# \1/' < /dev/stdin

