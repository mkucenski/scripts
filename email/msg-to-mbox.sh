#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DEST="$1"
if [ $# -eq 0 ]; then
	USAGE "DEST EML_FILE(S)"
	exit 1
fi
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	USAGE_DESCRIPTION "This script converts multiple Outlook (EML) files into mbox format for easier parsing/analysis. Relies on: 'msgconvert' from 'p5.26-email-outlook-message' (https://metacpan.org/pod/Email::Outlook::Message)"
	USAGE_EXAMPLE "$(basename "$0") eml1 eml2 eml3 ..." 
	exit 1
fi

LOGFILE="$DEST/$(STRIP_EXTENSION "$(basename "$0")").log"
START "$0" "$LOGFILE" "$@"

shift
for X in $@; do
	FILE="$DEST/$(STRIP_EXTENSION "$X").mbox"
	INFO "$X -> $FILE" "$LOGFILE"
	EXEC_CMD "msgconvert --mbox \"$FILE\" \"$X\"" "$LOGFILE"
	EXEC_CMD "dos2unix \"$FILE\"" "$LOGFILE"
done

END "$0" "$LOGFILE"

