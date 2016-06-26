#!/bin/sh

directory=`dirname "$1"`
filename=`basename "$1"`

mkdir -p "$2/$directory"
ln "$1" "$2/$1"
