#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

DB="$1"
CSV="$2"
LOGFILE="$3"
if [ -z "$LOGFILE" ]; then
	LOGFILE="$(STRIP_EXTENSION "$CSV").log"
fi
if [ $# -ne 2 ]; then
	USAGE "DB" "CSV" "LOGFILE (optional)" && exit 1
fi

START "$0" "$LOGFILE" "$*"

IFS=$(echo -en " ")
for TABLE in $(sqlite3 "$DB" <<!
.tables
!); do
	
sqlite3 "$DB" <<!
.headers on
.mode csv
.output "$(STRIP_EXTENSION "$CSV")_$TABLE.csv"
select * from $TABLE;
!

done

END "$0" "$LOGFILE"

