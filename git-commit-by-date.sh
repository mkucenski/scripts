#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

if [ $# -eq 0 ]; then
	USAGE "<FILES>" && exit $COMMON_ERROR
fi

git commit -m "$(DATETIME)" $@
git push

