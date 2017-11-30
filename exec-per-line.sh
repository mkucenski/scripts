#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

CMD_TEMPLATE="$1"
if [ $# -eq 0 ]; then
	USAGE "CMD_TEMPLATE ('{}' will be substituted by each text file line)" "(stdin) TEXT_FILE"
	USAGE_DESCRIPTION "This script is meant to function similar to 'xargs -I {}'. It will replace every instance of '{}' in the command template with a line of text via STDIN, execute the resulting command, and repeat the process for each line."
	USAGE_EXAMPLE "cat file_list.txt | exec-per-line.sh \"copy-as-hash.sh {} dest_directory/\""
	exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

while read -r LINE; do 
	eval "${CMD_TEMPLATE//\{\}/\"$LINE\"}"
done < /dev/stdin

exit $RV

