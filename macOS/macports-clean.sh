#!/bin/bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

if [ $(CHECK_ROOT) != true ]; then
	ERROR "This script *MUST* be run as 'root'!" && exit 1
fi

${BASH_SOURCE%/*}/macports-wrapper.sh -f clean --all all
${BASH_SOURCE%/*}/macports-wrapper.sh -f uninstall inactive

# These should be done automatically by the commands above:
# sudo rm -rf /opt/local/var/macports/build/*
# sudo rm -rf /opt/local/var/macports/distfiles/*
# sudo rm -rf /opt/local/var/macports/packages/*

ls /opt/local/var/macports/build/
ls /opt/local/var/macports/distfiles/
ls /opt/local/var/macports/packages/

