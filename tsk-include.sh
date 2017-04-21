#!/bin/bash
. $(dirname "$0")/common-include.sh

TSK_MCT_REGEX="^[^|]+\|[^|]+\|[^|]+\|r[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+$"
TSK_MCT_SED="^([^|]+)\|([^|]+)\|([^|]+)\|(r[^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)\|([^|]+)$"

function _tsk_mct_file() {
	echo "$1" | grep -v "\$FILE_NAME" | egrep "$MCT_REGEX" | $SEDCMD -r "s/$MCT_SED/\2/"
}

function _tsk_mct_inode() {
	echo "$1" | grep -v "\$FILE_NAME" | egrep "$MCT_REGEX" | $SEDCMD -r "s/$MCT_SED/\3/" | egrep "[[:digit:]]+-128-[[:digit:]]+" | $SEDCMD -r "s/([[:digit:]]+)-128-[[:digit:]]/\1/"
}

