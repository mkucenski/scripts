#!/bin/bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

BASE_DEST="/Volumes/Telework/"
if [ -d "$BASE_DEST" ]; then
	~/Scripts/unison.sh ~/Documents/ "$BASE_DEST/Work/"
	~/Scripts/unison.sh ~/Development/ "$BASE_DEST/Development/"
	NOTIFY "Sync Completed to <$BASE_DEST>" "$0"
fi
