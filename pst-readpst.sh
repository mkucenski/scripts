#!/usr/bin/env bash

PST="$1"
DST="$2"
mkdir -p "$DST"

readpst -r -o "$DST" -d "$DST/$PST.log" "$PST"

# ReadPST / LibPST v0.6.68
# Little Endian implementation being used.
# Usage: readpst [OPTIONS] {PST FILENAME}
# OPTIONS:

# 	-M	- Write emails in the MH (rfc822) format
# 	-e	- As with -M, but include extensions on output files
# 	-m	- As with -e, but write .msg files also
# 	-S	- Separate. Write emails in the separate format
# 	-k	- KMail. Output in kmail format
# 	-r	- Recursive. Output in a recursive format
# Only one of -M -S -e -k -m -r should be specified

# 	-V	- Version. Display program version
# 	-C charset	- character set for items with an unspecified character set
# 	-D	- Include deleted items in output
# 	-L <level> 	- Set debug level; 1=debug,2=info,3=warn.
# 	-a <attachment-extension-list>	- Discard any attachment without an extension on the list
# 	-b	- Don't save RTF-Body attachments
# 	-c[v|l]	- Set the Contact output mode. -cv = VCard, -cl = EMail list
# 	-d <filename> 	- Debug to file.
# 	-h	- Help. This screen
# 	-j <integer>	- Number of parallel jobs to run
# 	-o <dirname>	- Output directory to write files to. CWD is changed *after* opening pst file
# 	-q	- Quiet. Only print error messages
# 	-t[eajc]	- Set the output type list. e = email, a = attachment, j = journal, c = contact
# 	-u	- Thunderbird mode. Write two extra .size and .type files
# 	-w	- Overwrite any output mbox files
# 	-8	- Output bodies in UTF-8, rather than original encoding, if UTF-8 version is available
