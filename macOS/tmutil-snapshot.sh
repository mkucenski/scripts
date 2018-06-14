#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

tmutil snapshot
NOTIFY "Snapshot Completed ($(tmutil listlocalsnapshots / | tail -n 1))" "$0"

