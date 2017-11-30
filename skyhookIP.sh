#!/bin/bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

IP="$1"
if [ $# -eq 0 ]; then
	USAGE "IP" && exit 1
fi

# echo -n "$IP: "
wget -q -O - "https://context.skyhookwireless.com/accelerator/ip?version=2.0&ip=$IP&key=eJwVwUEKACAIBMBzjxEUcbNjZn4q-ns0I034Qwe3MzYqPRcZIshsBqmqUw1wQFal4D4W4gtQ &user=eval"
echo

