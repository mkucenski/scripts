#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# photorec output directory
SOURCE="$1"
DEST="$2"
LOGFILE="$3"
if [ $# -eq 0 ]; then
	USAGE "SOURCE" "DEST" "LOGFILE" && exit 1
fi

START "$0" "$LOGFILE" "$*"

ls -d "$SOURCE"/recup_dir.* | xargs -L 1 -I {} ${BASH_SOURCE%/*}/sort-copy-by-mime-type.sh {} "$DEST"
find "$DEST" -type f -name "report.xml" -exec rm {} \;

END "$0" "$LOGFILE"

