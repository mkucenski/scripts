#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh

# Once the tor proxy service is started (via 'sudo tor'), this script can be used to verify whether everything is working correctly; subsquent use of "torify" should be successful

pushd "$TMPDIR" > /dev/null

if [[ -e index.html ]]; then
	rm index.html
fi

torify wget --quiet http://check.torproject.org
RESULT=$(head index.html | grep "Congratulations. This browser is configured to use Tor." | $SEDCMD -r 's/^[[:space:]]*(.+)[[:space:]]*$/\1/')

if [[ -n "$RESULT" ]]; then
	echo "$RESULT"
else
	echo "Failure accessing Tor proxy!"
fi

if [[ -e index.html ]]; then
	rm index.html
fi

popd > /dev/null

