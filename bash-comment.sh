#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# man ls | col -b | bash-comment.sh

"$SEDCMD" -r 's/(.*)/# \1/' < /dev/stdin

