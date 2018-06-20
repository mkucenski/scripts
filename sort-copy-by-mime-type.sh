#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SOURCEDIR="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SOURCEDIR" "DESTDIR" && exit 1
fi

INFO_ERR "$SOURCEDIR..."
find "$SOURCEDIR" -type f -exec file --mime {} \; | "$SEDCMD" -r 's/^([^:]+): ([^;]+); [^;]+$/\1 \2/' | xargs -L 1 -J {} ${BASH_SOURCE%/*}/sort-copy-by-mime-type_copy.sh {} "$DESTDIR"

# | xargs -L 1 -J {} ${BASH_SOURCE%/*}/sort-copy-by-mime-type_copy.sh {} "$2"

# -exec file --mime --separator {} \; | gsed -r 's/^([^;]+); ([^;]+); [^;]+$/\1 \2/' | xargs -L 1 -J {} ${BASH_SOURCE%/*}/sort-copy-by-mime-type_copy.sh {} "$2"

