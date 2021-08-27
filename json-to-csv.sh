#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

jq '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' < /dev/stdin
