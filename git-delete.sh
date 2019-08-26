#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

FILE="$1"
if [ $# -eq 0 ]; then
	USAGE "GIT-FILE"
	exit 1
fi
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	USAGE_DESCRIPTION "This script is useful for finding and removing Git-controlled files in a directory structure."
	USAGE_EXAMPLE "find ./ -type f -name \"...\" -exec $(basename "$0") {} \;"
	exit 1
fi

# Move into the directory of the file; git can then find the repository metadata to complete the removal.
DIR="$(dirname "$FILE")"
pushd "$DIR"
	git rm "$FILE"
popd

