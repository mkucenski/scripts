#!/bin/bash

COUNT=$1
IT=$2

cat /dev/stdin | head -n $(expr $IT \* $COUNT) | tail -n $COUNT
