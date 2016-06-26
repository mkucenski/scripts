#!/bin/sh

if [ "$1" = "-d" ]
then
   umount ~/mnt/cdrom
else
   mount -t cd9660 /dev/acd0 ~/mnt/cdrom
fi

