#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

TSK_MCT_REGEX="^[^|]*\|[^|]+\|[^|]+\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*$"
TSK_MCT_SED="^([^|]*)\|([^|]+)\|([^|]+)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)$"
TSK_ISTAT_SID_SED="^Security ID:[[:space:]]+([[:digit:]]+)[[:space:]]+\((S-[[:digit:]-]+)\)$"
TSK_MMLS_SED="^([[:digit:]]+):[[:space:]]+([^[:space:]]+)[[:space:]]+0*([[:digit:]]+)[[:space:]]+0*([[:digit:]]+)[[:space:]]+0*([[:digit:]]+)[[:space:]]+0*([[:digit:]]+[BKMGT])[[:space:]]+(.*)$"

function _tsk_mct_file() {
	#echo "$1" | grep -v "\$FILE_NAME" | egrep "$TSK_MCT_REGEX" | $SEDCMD -r "s/$TSK_MCT_SED/\2/"
	echo "$1" | grep -v '$FILE_NAME' | cut -d "|" -f 2
}

function _tsk_mct_inode() {
	#echo "$1" | grep -v "\$FILE_NAME" | egrep "$TSK_MCT_REGEX" | $SEDCMD -r "s/$TSK_MCT_SED/\3/" | egrep "[[:digit:]]+-[[:digit:]]+-[[:digit:]]+" | $SEDCMD -r "s/([[:digit:]]+)-[[:digit:]]+-[[:digit:]]/\1/"
	echo "$1" | grep -v '$FILE_NAME' | cut -d "|" -f 3
}

function _tsk_mct_owner() {
	echo "$1" | grep -v '$FILE_NAME' | cut -d "|" -f 5
}

function _tsk_istat_sid() {
	echo "$1" | grep "Security ID:" | $SEDCMD -r "s/$TSK_ISTAT_SID_SED/\2/"
}

function _tsk_mmls_offset() {
	_TSK_DISK="$1"
	_TSK_PARTITION="$2"
	mmls -B -r "$_TSK_DISK" | egrep "^$_TSK_PARTITION:" | $SEDCMD -r "s/$TSK_MMLS_SED/\3/"
}

function _tsk_mmls_end() {
	_TSK_DISK="$1"
	_TSK_PARTITION="$2"
	mmls -B -r "$_TSK_DISK" | egrep "^$_TSK_PARTITION:" | $SEDCMD -r "s/$TSK_MMLS_SED/\4/"
}

function _tsk_mmls_length() {
	_TSK_DISK="$1"
	_TSK_PARTITION="$2"
	mmls -B -r "$_TSK_DISK" | egrep "^$_TSK_PARTITION:" | $SEDCMD -r "s/$TSK_MMLS_SED/\5/"
}

function _tsk_mmls_size() {
	_TSK_DISK="$1"
	_TSK_PARTITION="$2"
	mmls -B -r "$_TSK_DISK" | egrep "^$_TSK_PARTITION:" | $SEDCMD -r "s/$TSK_MMLS_SED/\6/"
}

function _tsk_mmls_descr() {
	_TSK_DISK="$1"
	_TSK_PARTITION="$2"
	mmls -B -r "$_TSK_DISK" | egrep "^$_TSK_PARTITION:" | $SEDCMD -r "s/$TSK_MMLS_SED/\7/"
}

function _tsk_mmls_partitions() {
	_TSK_DISK="$1"

	_TSK_MMLS_TMP=$(MKTEMP "$0" || exit 1)
	mmls -B -r "$_TSK_DISK" | egrep "^[[:digit:]]+:" > "$_TSK_MMLS_TMP"

	while read LINE; do
		_TSK_PARTITION="$(echo "$LINE" | $SEDCMD -r "s/$TSK_MMLS_SED/\1/")"
		echo "$_TSK_PARTITION"
	done < "$_TSK_MMLS_TMP"

	rm "$_TSK_MMLS_TMP"
}

# DOS Partition Table
# Offset Sector: 0
# Units are in 512-byte sectors
# 
# 1	  2			3				 4				  5				6		  7
#       Slot      Start        End          Length       Size    Description
# 000:  Meta      0000000000   0000000000   0000000001   0512B   Primary Table (#0)
# 001:  -------   0000000000   0000000001   0000000002   1024B   Unallocated
# 002:  000:000   0000000002   0031277231   0031277230   0014G   NTFS / exFAT (0x07)
