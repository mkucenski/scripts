#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

SCANDIR="$1"
LOGFILE="$2"
if [ $# -eq 0 ]; then
	USAGE "SCANDIR" "LOGFILE" && exit 1
fi

START "$0" "$LOGFILE" "$*"
LOG_SCRIPT_BASE64 "${BASH_SOURCE%/*}/clamav-version.sh" "$LOGFILE"
LOG_VERSION "clamav-version.sh" "$(${BASH_SOURCE%/*}/clamav-version.sh)" "$LOGFILE"

INFO "Scanning <$SCANDIR>..." "$LOGFILE"
CMD="clamscan --bell --recursive --allmatch=yes \"$SCANDIR\""
EXEC_CMD "$CMD" "$LOGFILE"

LOG "" "$LOGFILE"
END "$0" "$LOGFILE"

# 
#                        Clam AntiVirus: Scanner 0.101.0
#            By The ClamAV Team: https://www.clamav.net/about.html#credits
#            (C) 2007-2018 Cisco Systems, Inc.
# 
#     clamscan [options] [file/directory/-]
# 
#     --help                -h             Show this help
#     --version             -V             Print version number
#     --verbose             -v             Be verbose
#     --archive-verbose     -a             Show filenames inside scanned archives
#     --debug                              Enable libclamav's debug messages
#     --quiet                              Only output error messages
#     --stdout                             Write to stdout instead of stderr
#     --no-summary                         Disable summary at end of scanning
#     --infected            -i             Only print infected files
#     --suppress-ok-results -o             Skip printing OK files
#     --bell                               Sound bell on virus detection
# 
#     --tempdir=DIRECTORY                  Create temporary files in DIRECTORY
#     --leave-temps[=yes/no(*)]            Do not remove temporary files
#     --gen-json[=yes/no(*)]               Generate JSON description of scanned file(s). JSON will be printed and also-
#                                          dropped to the temp directory if --leave-temps is enabled.
#     --database=FILE/DIR   -d FILE/DIR    Load virus database from FILE or load all supported db files from DIR
#     --official-db-only[=yes/no(*)]       Only load official signatures
#     --log=FILE            -l FILE        Save scan report to FILE
#     --recursive[=yes/no(*)]  -r          Scan subdirectories recursively
#     --allmatch[=yes/no(*)]   -z          Continue scanning within file after finding a match
#     --cross-fs[=yes(*)/no]               Scan files and directories on other filesystems
#     --follow-dir-symlinks[=0/1(*)/2]     Follow directory symlinks (0 = never, 1 = direct, 2 = always)
#     --follow-file-symlinks[=0/1(*)/2]    Follow file symlinks (0 = never, 1 = direct, 2 = always)
#     --file-list=FILE      -f FILE        Scan files from FILE
#     --remove[=yes/no(*)]                 Remove infected files. Be careful!
#     --move=DIRECTORY                     Move infected files into DIRECTORY
#     --copy=DIRECTORY                     Copy infected files into DIRECTORY
#     --exclude=REGEX                      Don't scan file names matching REGEX
#     --exclude-dir=REGEX                  Don't scan directories matching REGEX
#     --include=REGEX                      Only scan file names matching REGEX
#     --include-dir=REGEX                  Only scan directories matching REGEX
# 
#     --bytecode[=yes(*)/no]               Load bytecode from the database
#     --bytecode-unsigned[=yes/no(*)]      Load unsigned bytecode
#     --bytecode-timeout=N                 Set bytecode timeout (in milliseconds)
#     --statistics[=none(*)/bytecode/pcre] Collect and print execution statistics
#     --detect-pua[=yes/no(*)]             Detect Possibly Unwanted Applications
#     --exclude-pua=CAT                    Skip PUA sigs of category CAT
#     --include-pua=CAT                    Load PUA sigs of category CAT
#     --detect-structured[=yes/no(*)]      Detect structured data (SSN, Credit Card)
#     --structured-ssn-format=X            SSN format (0=normal,1=stripped,2=both)
#     --structured-ssn-count=N             Min SSN count to generate a detect
#     --structured-cc-count=N              Min CC count to generate a detect
#     --scan-mail[=yes(*)/no]              Scan mail files
#     --phishing-sigs[=yes(*)/no]          Enable email signature-based phishing detection
#     --phishing-scan-urls[=yes(*)/no]     Enable URL signature-based phishing detection
#     --heuristic-alerts[=yes(*)/no]       Heuristic alerts
#     --heuristic-scan-precedence[=yes/no(*)] Stop scanning as soon as a heuristic match is found
#     --normalize[=yes(*)/no]              Normalize html, script, and text files. Use normalize=no for yara compatibility
#     --scan-pe[=yes(*)/no]                Scan PE files
#     --scan-elf[=yes(*)/no]               Scan ELF files
#     --scan-ole2[=yes(*)/no]              Scan OLE2 containers
#     --scan-pdf[=yes(*)/no]               Scan PDF files
#     --scan-swf[=yes(*)/no]               Scan SWF files
#     --scan-html[=yes(*)/no]              Scan HTML files
#     --scan-xmldocs[=yes(*)/no]           Scan xml-based document files
#     --scan-hwp3[=yes(*)/no]              Scan HWP3 files
#     --scan-archive[=yes(*)/no]           Scan archive files (supported by libclamav)
#     --alert-broken[=yes/no(*)]           Alert on broken executable files (PE & ELF)
#     --alert-encrypted[=yes/no(*)]        Alert on encrypted archives and documents
#     --alert-encrypted-archive[=yes/no(*)] Alert on encrypted archives
#     --alert-encrypted-doc[=yes/no(*)]    Alert on encrypted documents
#     --alert-macros[=yes/no(*)]           Alert on OLE2 files containing VBA macros
#     --alert-exceeds-max[=yes/no(*)]      Alert on files that exceed max file size, max scan size, or max recursion limit
#     --alert-phishing-ssl[=yes/no(*)]     Alert on emails containing SSL mismatches in URLs
#     --alert-phishing-cloak[=yes/no(*)]   Alert on emails containing cloaked URLs
#     --alert-partition-intersection[=yes/no(*)] Alert on raw DMG image files containing partition intersections
#     --nocerts                            Disable authenticode certificate chain verification in PE files
#     --dumpcerts                          Dump authenticode certificate chain in PE files
# 
#     --max-filesize=#n                    Files larger than this will be skipped and assumed clean
#     --max-scansize=#n                    The maximum amount of data to scan for each container file (**)
#     --max-files=#n                       The maximum number of files to scan for each container file (**)
#     --max-recursion=#n                   Maximum archive recursion level for container file (**)
#     --max-dir-recursion=#n               Maximum directory recursion level
#     --max-embeddedpe=#n                  Maximum size file to check for embedded PE
#     --max-htmlnormalize=#n               Maximum size of HTML file to normalize
#     --max-htmlnotags=#n                  Maximum size of normalized HTML file to scan
#     --max-scriptnormalize=#n             Maximum size of script file to normalize
#     --max-ziptypercg=#n                  Maximum size zip to type reanalyze
#     --max-partitions=#n                  Maximum number of partitions in disk image to be scanned
#     --max-iconspe=#n                     Maximum number of icons in PE file to be scanned
#     --max-rechwp3=#n                     Maximum recursive calls to HWP3 parsing function
#     --pcre-match-limit=#n                Maximum calls to the PCRE match function.
#     --pcre-recmatch-limit=#n             Maximum recursive calls to the PCRE match function.
#     --pcre-max-filesize=#n               Maximum size file to perform PCRE subsig matching.
#     --disable-cache                      Disable caching and cache checks for hash sums of scanned files.
# 
# Pass in - as the filename for stdin.
# 
# (*) Default scan settings
# (**) Certain files (e.g. documents, archives, etc.) may in turn contain other
#    files inside. The above options ensure safe processing of this kind of data.
# 
