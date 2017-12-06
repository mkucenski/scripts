#!/usr/bin/env bash

cat /dev/stdin | gsed -r 's/(\/usr\/bin\/env \/usr\/bin\/fetch -ApRr -S [^ ]+)/wget -t 1 -nc/g'
#cat /dev/stdin | gsed -r 's/^([^ ]+ ){5}([^ ]+).*/\2/' | sort -u
#cat /dev/stdin | gsed -r 's/(\/usr\/bin\/env \/usr\/bin\/fetch -ARr -S [^ ]+ ([^ ]+)) /wget -N \2/g'

