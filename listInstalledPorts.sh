#!/usr/bin/env bash

pkg_version -o | gsed -r 's/^([^ ]+) .*/\1/'
