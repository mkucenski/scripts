#!/bin/sh

cat $1 | xargs -L 1 -I {} perl -le 'print pack("H32", "{}");'

