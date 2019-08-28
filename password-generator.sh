#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	USAGE_DESCRIPTION "..."
	USAGE_EXAMPLE "$(basename "$0") ..."
	exit 1
fi

UNAME=$(uname)
if [ "$UNAME" = "Darwin" ]; then
	A="$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"
	B="$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"
	C="$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"
	D="$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"
else
	A="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"
	B="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"
	C="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"
	D="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"
fi

echo "$A-$B-$C-$D"

