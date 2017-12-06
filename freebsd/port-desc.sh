#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

cat /usr/ports/"$1"/pkg-descr
