#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DIR="$1"
if [ $# -eq 0 ]; then
	USAGE "DIR" && exit 1
fi

fdupes --recurse --delete --nohidden --noempty "$DIR"

