#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

VMDK="$1"
RAW="$2"
if [ $# -eq 0 ]; then
	USAGE "VMDK" "RAW" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

DEBUG=0
LOG="$(STRIP_EXTENSION "$RAW").log"

if [ ! -e "$RAW" ]; then
	qemu-img convert -p -f vmdk -O raw "$VMDK" "$RAW" 2>&1 | tee -a "$LOG"
else
	echo "$0: Destination RAW already exists!" | tee -a "$LOG"
fi

exit $RV

# qemu-img version 2.9.0
# Copyright (c) 2003-2017 Fabrice Bellard and the QEMU Project developers
# usage: qemu-img [standard options] command [command options]
# QEMU disk image utility
# 
#     '-h', '--help'       display this help and exit
#     '-V', '--version'    output version information and exit
#     '-T', '--trace'      [[enable=]<pattern>][,events=<file>][,file=<file>]
#                          specify tracing options
# 
# Command syntax:
#   bench [-c count] [-d depth] [-f fmt] [--flush-interval=flush_interval] [-n] [--no-drain] [-o offset] [--pattern=pattern] [-q] [-s buffer_size] [-S step_size] [-t cache] [-w] filename
#   check [-q] [--object objectdef] [--image-opts] [-f fmt] [--output=ofmt] [-r [leaks | all]] [-T src_cache] filename
#   create [-q] [--object objectdef] [-f fmt] [-o options] filename [size]
#   commit [-q] [--object objectdef] [--image-opts] [-f fmt] [-t cache] [-b base] [-d] [-p] filename
#   compare [--object objectdef] [--image-opts] [-f fmt] [-F fmt] [-T src_cache] [-p] [-q] [-s] filename1 filename2
#   convert [--object objectdef] [--image-opts] [-c] [-p] [-q] [-n] [-f fmt] [-t cache] [-T src_cache] [-O output_fmt] [-o options] [-s snapshot_id_or_name] [-l snapshot_param] [-S sparse_size] [-m num_coroutines] [-W] filename [filename2 [...]] output_filename
#   dd [--image-opts] [-f fmt] [-O output_fmt] [bs=block_size] [count=blocks] [skip=blocks] if=input of=output
#   info [--object objectdef] [--image-opts] [-f fmt] [--output=ofmt] [--backing-chain] filename
#   map [--object objectdef] [--image-opts] [-f fmt] [--output=ofmt] filename
#   snapshot [--object objectdef] [--image-opts] [-q] [-l | -a snapshot | -c snapshot | -d snapshot] filename
#   rebase [--object objectdef] [--image-opts] [-q] [-f fmt] [-t cache] [-T src_cache] [-p] [-u] -b backing_file [-F backing_fmt] filename
#   resize [--object objectdef] [--image-opts] [-q] filename [+ | -]size
#   amend [--object objectdef] [--image-opts] [-p] [-q] [-f fmt] [-t cache] -o options filename
# 
# Command parameters:
#   'filename' is a disk image filename
#   'objectdef' is a QEMU user creatable object definition. See the qemu(1)
#     manual page for a description of the object properties. The most common
#     object type is a 'secret', which is used to supply passwords and/or
#     encryption keys.
#   'fmt' is the disk image format. It is guessed automatically in most cases
#   'cache' is the cache mode used to write the output disk image, the valid
#     options are: 'none', 'writeback' (default, except for convert), 'writethrough',
#     'directsync' and 'unsafe' (default for convert)
#   'src_cache' is the cache mode used to read input disk images, the valid
#     options are the same as for the 'cache' option
#   'size' is the disk image size in bytes. Optional suffixes
#     'k' or 'K' (kilobyte, 1024), 'M' (megabyte, 1024k), 'G' (gigabyte, 1024M),
#     'T' (terabyte, 1024G), 'P' (petabyte, 1024T) and 'E' (exabyte, 1024P)  are
#     supported. 'b' is ignored.
#   'output_filename' is the destination disk image filename
#   'output_fmt' is the destination format
#   'options' is a comma separated list of format specific options in a
#     name=value format. Use -o ? for an overview of the options supported by the
#     used format
#   'snapshot_param' is param used for internal snapshot, format
#     is 'snapshot.id=[ID],snapshot.name=[NAME]', or
#     '[ID_OR_NAME]'
#   'snapshot_id_or_name' is deprecated, use 'snapshot_param'
#     instead
#   '-c' indicates that target image must be compressed (qcow format only)
#   '-u' enables unsafe rebasing. It is assumed that old and new backing file
#        match exactly. The image doesn't need a working backing file before
#        rebasing in this case (useful for renaming the backing file)
#   '-h' with or without a command shows this help and lists the supported formats
#   '-p' show progress of command (only certain commands)
#   '-q' use Quiet mode - do not print any output (except errors)
#   '-S' indicates the consecutive number of bytes (defaults to 4k) that must
#        contain only zeros for qemu-img to create a sparse image during
#        conversion. If the number of bytes is 0, the source will not be scanned for
#        unallocated or zero sectors, and the destination image will always be
#        fully allocated
#   '--output' takes the format in which the output must be done (human or json)
#   '-n' skips the target volume creation (useful if the volume is created
#        prior to running qemu-img)
# 
# Parameters to check subcommand:
#   '-r' tries to repair any inconsistencies that are found during the check.
#        '-r leaks' repairs only cluster leaks, whereas '-r all' fixes all
#        kinds of errors, with a higher risk of choosing the wrong fix or
#        hiding corruption that has already occurred.
# 
# Parameters to convert subcommand:
#   '-m' specifies how many coroutines work in parallel during the convert
#        process (defaults to 8)
#   '-W' allow to write to the target out of order rather than sequential
# 
# Parameters to snapshot subcommand:
#   'snapshot' is the name of the snapshot to create, apply or delete
#   '-a' applies a snapshot (revert disk to saved state)
#   '-c' creates a snapshot
#   '-d' deletes a snapshot
#   '-l' lists all snapshots in the given image
# 
# Parameters to compare subcommand:
#   '-f' first image format
#   '-F' second image format
#   '-s' run in Strict mode - fail on different image size or sector allocation
# 
# Parameters to dd subcommand:
#   'bs=BYTES' read and write up to BYTES bytes at a time (default: 512)
#   'count=N' copy only N input blocks
#   'if=FILE' read from FILE
#   'of=FILE' write to FILE
#   'skip=N' skip N bs-sized blocks at the start of input
# 
# Supported formats: blkdebug blkreplay blkverify bochs cloop dmg file ftp ftps host_device http https luks nbd null-aio null-co parallels qcow qcow2 qed quorum raw replication sheepdog vdi vhdx vmdk vpc vvfat
