#!/bin/bash

FILE="$1"
echo "$FILE:"
ssh-keygen -lf "$FILE"
ssh-keygen -E md5 -lf "$FILE"
