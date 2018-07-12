#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

IFS=$(echo -en "\n\b")

for arg in "$@"; do
	echo "$arg -> $arg.bz2..."
	bzip2 -k "$arg"
done

