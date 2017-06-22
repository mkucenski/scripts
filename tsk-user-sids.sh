#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1
. ${BASH_SOURCE%/*}/tsk-include.sh || exit 1
ENABLE_DEBUG=1

IMAGE="$1"
OFFSET="$2"
if [ -z "$OFFSET" ]; then OFFSET=0; fi
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" && exit $COMMON_ERROR
fi

IFS=$(echo -en "\n\b")

RV=$COMMON_SUCCESS

INFO "Username,SID"
USERS_MCT="$(${BASH_SOURCE%/*}/tsk.sh fls "$IMAGE" $OFFSET "" "-m /" | grep "/Users|")"
USERS_INODE=$(_tsk_mct_inode "$USERS_MCT")
for USER_MCT in $(${BASH_SOURCE%/*}/tsk.sh fls "$IMAGE" $OFFSET $USERS_INODE "-m /" | grep -v "desktop.ini"); do
	USER_NAME="$(_tsk_mct_file "$USER_MCT" | $SEDCMD -r 's/\///g')"
	USER_INODE="$(_tsk_mct_inode "$USER_MCT")"
	if [ -n "$USER_NAME" ]; then
		NTUSER_MCT="$(${BASH_SOURCE%/*}/tsk.sh fls "$IMAGE" $OFFSET $USER_INODE "-m /" | grep -i "/ntuser.dat|")"
		if [ -n "$NTUSER_MCT" ]; then
			NTUSER_INODE="$(_tsk_mct_inode "$NTUSER_MCT")"
			NTUSER_ISTAT="$(${BASH_SOURCE%/*}/tsk.sh istat "$IMAGE" $OFFSET $NTUSER_INODE)"
			NTUSER_SID="$(_tsk_istat_sid "$NTUSER_ISTAT")"
			if [ -n "$NTUSER_SID" ]; then
				INFO "\"$USER_NAME\",\"$NTUSER_SID\""
			fi
		fi
	fi
done

RV=$((RV+$?))

exit $RV

