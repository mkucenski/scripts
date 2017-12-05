#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

if [ $# -eq 0 ]; then
	USAGE "<FILES>" && exit 1
fi

git commit -m "..." $@
git push; git pull

