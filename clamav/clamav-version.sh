#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

clamscan --version
sigtool --info="/opt/local/share/clamav/bytecode.cvd"
sigtool --info="/opt/local/share/clamav/daily.cvd"
sigtool --info="/opt/local/share/clamav/main.cvd"

