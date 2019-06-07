#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

if [ $# -eq 0 ]; then
	USAGE "DIR(S)" && exit 1
fi

fdupes --recurse --delete --nohidden --noempty --order=NAME $@

