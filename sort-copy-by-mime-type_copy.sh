#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

INFO_ERR "$1..."
mkdir -p "$3"/"$2"
cp -v "$1" "$3"/"$2"

