#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Run dig/nslookup records consistently and store the results in a specific directory

# NOTE:	Querying the DNS system for "ANY" is not reliable; hence individual queries for
#			commonly interesting types. In some cases, "ANY" will not return certain records
#			while a specific query for "MX" will return an entry.

SITE="$1"
DESTDIR="$2"
if [ $# -eq 0 ]; then
	USAGE "SITE" "DESTDIR" && exit 1
fi
if [ -z "$DESTDIR" ]; then
	DESTDIR="./"
fi

DEST="$DESTDIR/$SITE-dig.txt"
if [ ! -e "$DEST" ]; then
	mkdir -p "$DESTDIR"
	touch "$DEST"
fi

if [ -e "$DEST" ]; then
	START "$0" "$DEST" "$*"
	LOG_VERSION "dig" "$(dig -version 2>&1)" "$DEST"
	INFO "$SITE -> $DEST"
	LOG "Dig Query for: $SITE" "$DEST"

	for TYPE in A AAAA CNAME DNAME LOC MX NS PTR RP SOA SRV TXT URI; do
		dig "$SITE" $TYPE | egrep -v "(;; Query time:|;; MSG SIZE|;; Got answer:|;; global options:|; <<>> DiG|;; ->>HEADER<<-|;; flags:|;; SERVER:|;; WHEN:)" | "$SEDCMD" -r '/^\s*$/d; s/(;; QUESTION SECTION:)/\n\1/' | tee -a "$DEST"
	done

	END "$0" "$DEST"
else
	ERROR "Unable to create destination file!" "$0" && exit 1
fi

