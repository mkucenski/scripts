#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Once the tor proxy service is started (via 'sudo tor'), this script can be used to verify whether everything is working correctly; subsquent use of "torify" should be successful

_TMPDIR=$(MKTEMPDIR "$0" || exit 1)
pushd "$_TMPDIR" > /dev/null

torify wget --quiet http://check.torproject.org
RESULT=$(head index.html | grep "Congratulations. This browser is configured to use Tor." | $SEDCMD -r 's/^[[:space:]]*(.+)[[:space:]]*$/\1/')

if [ -n "$RESULT" ]; then
	INFO "$RESULT"
else
	ERROR "Failure accessing Tor proxy!" "$0" && exit 1
fi

popd > /dev/null
rm -R "$_TMPDIR"

