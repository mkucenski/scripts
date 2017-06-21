#!/bin/sh

if [ "$1" = "-d" ]
then
   sudo mdconfig -d -u $2
else
   sudo mdconfig -a -t vnode -f "$1" -o readonly
fi

