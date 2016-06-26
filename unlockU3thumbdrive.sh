#!/bin/sh

#This script does not work as the password is somehow encoded within the bits sent below.  Need to do more testing
#to figure out if the password is accessible from the device.  This script simply illustrates how to send various 
#commands to the device using camcontrol.

#More testing needs to be done to determine if all U3 devices use the same SCSI command descriptor block (cdb)
#to enable the mass storage area of the device

#SanDisk Cruzer Micro 1.0GB
#camcontrol cmd $1 -v -c "FF A4 00 00 00 00 00 00 00 00 00 00" -o 0x10 "9c b4 10 67 01 f1 fc 38 bd 8f 56 62 9b 78 61 2f"
#camcontrol cmd $1 -v -c "FF A4 00 00 00 00 00 00 00 00 00 00" -o 0x10 "63 6b d8 83 d6 ec 4b 6f 43 7b 27 e8 b5 45 72 6c"
#camcontrol cmd $1 -v -c "FF A4 00 00 00 00 00 00 00 00 00 00" -o 0x10 "91 6e 1e 00 cb 87 0d d3 c9 12 b0 dc 03 c7 bb f7"

