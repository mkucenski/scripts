#!/usr/bin/env bash

git status | grep "modified:" | gsed -r 's/[[:space:]]+modified:[[:space:]]+(.+)/\1/' | xargs ls -lrth | gsed -r 's/.*[[:digit:]]+[[:space:]][[:digit:]]+:[[:digit:]]+[[:space:]](.+)/\tmodified:   \1/'

