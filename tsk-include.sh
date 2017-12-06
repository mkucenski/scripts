#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

TSK_MCT_REGEX="^[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+$"
TSK_MCT_SED="^([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)$"
TSK_ISTAT_SID_SED="^Security ID:[[:space:]]+([[:digit:]]+)[[:space:]]+\((S-[[:digit:]-]+)\)$"

function _tsk_mct_file() {
	echo "$1" | grep -v "\$FILE_NAME" | egrep "$TSK_MCT_REGEX" | $SEDCMD -r "s/$TSK_MCT_SED/\2/"
}

function _tsk_mct_inode() {
	echo "$1" | grep -v "\$FILE_NAME" | egrep "$TSK_MCT_REGEX" | $SEDCMD -r "s/$TSK_MCT_SED/\3/" | egrep "[[:digit:]]+-[[:digit:]]+-[[:digit:]]+" | $SEDCMD -r "s/([[:digit:]]+)-[[:digit:]]+-[[:digit:]]/\1/"
}

function _tsk_istat_sid() {
	echo "$1" | grep "Security ID:" | $SEDCMD -r "s/$TSK_ISTAT_SID_SED/\2/"
}

