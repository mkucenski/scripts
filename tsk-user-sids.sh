#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1
. "${BASH_SOURCE%/*}/tsk-include.sh" || exit 1
ENABLE_DEBUG=0

IMAGE="$1"
OFFSET="$2"
if [ -z "$OFFSET" ]; then OFFSET=0; fi
CSV="$3"
if [ -z "$CSV" ]; then CSV="$(STRIP_EXTENSION "$IMAGE")-User-SIDs.csv"; fi
if [ $# -eq 0 ]; then
	USAGE "IMAGE" "OFFSET" && exit 1
fi

IFS=$(echo -en "\n\b")

INFO_ERR "Saving to <$CSV>..."
INFO "Username,SID" | tee "$CSV"

# Retrieving MCT records for specified partition root -- looking for the "Users" directory.
USERS_MCT="$(${BASH_SOURCE%/*}/tsk.sh fls "$IMAGE" $OFFSET "" "-m /" | grep "/Users|")"
USERS_INODE=$(_tsk_mct_inode "$USERS_MCT")

# For each of the entry in the "Users" directory, process...
for USER_MCT in $(${BASH_SOURCE%/*}/tsk.sh fls "$IMAGE" $OFFSET $USERS_INODE "-m /" | egrep -v "\|/(All Users|Default User|desktop.ini|Default|Public)" | grep -v "\(\\\$FILE_NAME\)"); do 
	DEBUG "$USER_MCT" "$0"

	# Extract the user directory name and corresponding inode
	USER_NAME="$(_tsk_mct_file "$USER_MCT" | $SEDCMD -r 's/\///g')"
	USER_INODE="$(_tsk_mct_inode "$USER_MCT")"
	if [ -n "$USER_NAME" ]; then

		# Find the NTUSER.DAT file for each user
		NTUSER_MCT="$(${BASH_SOURCE%/*}/tsk.sh fls "$IMAGE" $OFFSET $USER_INODE "-m /" | grep -i "/ntuser.dat|")"
		if [ -n "$NTUSER_MCT" ]; then

			# Extract the NTUSER.DAT INODE and process using 'istat' to obtain the SID value.
			NTUSER_INODE="$(_tsk_mct_inode "$NTUSER_MCT")"
			NTUSER_ISTAT="$(${BASH_SOURCE%/*}/tsk.sh istat "$IMAGE" $OFFSET $NTUSER_INODE)"
			NTUSER_SID="$(_tsk_istat_sid "$NTUSER_ISTAT")"
			if [ -n "$NTUSER_SID" ]; then
				INFO "\"$USER_NAME\",\"$NTUSER_SID\"" | tee -a "$CSV"
			else
				ERROR "Unable to find SID via istat for <$NTUSER_MCT>!" "$0" && exit 1
			fi
		else
			ERROR "Unable to find <NTUSER.DAT> entry for <$USER_NAME>!" "$0" && exit 1
		fi
	else
		ERROR "Unable to find username for <$USER_MCT>!" "$0" && exit 1
	fi
done

