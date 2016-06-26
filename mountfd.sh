#!/bin/sh

if [ "$1" = "-d" ]
then
   umount ~/mnt/floppy
else
   mount -t msdos /dev/fd0 ~/mnt/floppy
fi

