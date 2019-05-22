#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

SCP_FILE="$1"
LOCAL_FILE="$2"
if [ $# -eq 0 ]; then
	USAGE "SCP_FILE" "LOCAL_FILE"
	USAGE_DESCRIPTION "This script retrieve a remote file and compare it against a local file"
	exit 1
fi

REMOTE_FILE_COPY="$(MKTEMP "$0")"
scp "$SCP_FILE" "$REMOTE_FILE_COPY"
diff -ywi "$REMOTE_FILE_COPY" "$LOCAL_FILE"

rm "$REMOTE_FILE_COPY"

