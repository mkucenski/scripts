#!/bin/sh

pkg_version -o | gsed -r 's/^([^ ]+) .*/\1/'
