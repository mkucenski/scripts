#!/bin/bash
. ${BASH_SOURCE%/*}/common-include.sh || exit 1

IMAGE="$1"
LOGFILE="$2"
if [ $# -ne 1 ]; then
	USAGE "IMAGE" "LOGFILE (optional - defaults to \$IMAGE-ewfverify.log)" && exit $COMMON_ERROR
fi

RV=$COMMON_SUCCESS

java -jar ~/.m2/repository/org/apache/tika/tika-app/1.16/tika-app-1.16.jar --jsonRecursive

END "$0" "$LOGFILE"
exit $RV

# usage: java -jar tika-app.jar [option...] [file|port...]
# 
# Options:
#     -?  or --help          Print this usage message
#     -v  or --verbose       Print debug level messages
#     -V  or --version       Print the Apache Tika version number
# 
#     -g  or --gui           Start the Apache Tika GUI
#     -s  or --server        Start the Apache Tika server
#     -f  or --fork          Use Fork Mode for out-of-process extraction
# 
#     --config=<tika-config.xml>
#         TikaConfig file. Must be specified before -g, -s, -f or the dump-x-config !
#     --dump-minimal-config  Print minimal TikaConfig
#     --dump-current-config  Print current TikaConfig
#     --dump-static-config   Print static config
#     --dump-static-full-config  Print static explicit config
# 
#     -x  or --xml           Output XHTML content (default)
#     -h  or --html          Output HTML content
#     -t  or --text          Output plain text content
#     -T  or --text-main     Output plain text content (main content only)
#     -m  or --metadata      Output only metadata
#     -j  or --json          Output metadata in JSON
#     -y  or --xmp           Output metadata in XMP
#     -J  or --jsonRecursive Output metadata and content from all
#                            embedded files (choose content type
#                            with -x, -h, -t or -m; default is -x)
#     -l  or --language      Output only language
#     -d  or --detect        Detect document type
#            --digest=X      Include digest X (md2, md5, sha1,
#                                sha256, sha384, sha512
#     -eX or --encoding=X    Use output encoding X
#     -pX or --password=X    Use document password X
#     -z  or --extract       Extract all attachements into current directory
#     --extract-dir=<dir>    Specify target directory for -z
#     -r  or --pretty-print  For JSON, XML and XHTML outputs, adds newlines and
#                            whitespace, for better readability
# 
#     --list-parsers
#          List the available document parsers
#     --list-parser-details
#          List the available document parsers and their supported mime types
#     --list-parser-details-apt
#          List the available document parsers and their supported mime types in apt format.
#     --list-detectors
#          List the available document detectors
#     --list-met-models
#          List the available metadata models, and their supported keys
#     --list-supported-types
#          List all known media types and related information
# 
# 
#     --compare-file-magic=<dir>
#          Compares Tika's known media types to the File(1) tool's magic directory
# Description:
#     Apache Tika will parse the file(s) specified on the
#     command line and output the extracted text content
#     or metadata to standard output.
# 
#     Instead of a file name you can also specify the URL
#     of a document to be parsed.
# 
#     If no file name or URL is specified (or the special
#     name "-" is used), then the standard input stream
#     is parsed. If no arguments were given and no input
#     data is available, the GUI is started instead.
# 
# - GUI mode
# 
#     Use the "--gui" (or "-g") option to start the
#     Apache Tika GUI. You can drag and drop files from
#     a normal file explorer to the GUI window to extract
#     text content and metadata from the files.
# 
# - Server mode
# 
#     Use the "--server" (or "-s") option to start the
#     Apache Tika server. The server will listen to the
#     ports you specify as one or more arguments.
# 
# - Batch mode
# 
#     Simplest method.
#     Specify two directories as args with no other args:
#          java -jar tika-app.jar <inputDirectory> <outputDirectory>
# 
# Batch Options:
#     -i  or --inputDir          Input directory
#     -o  or --outputDir         Output directory
#     -numConsumers              Number of processing threads
#     -bc                        Batch config file
#     -maxRestarts               Maximum number of times the 
#                                watchdog process will restart the child process.
#     -timeoutThresholdMillis    Number of milliseconds allowed to a parse
#                                before the process is killed and restarted
#     -fileList                  List of files to process, with
#                                paths relative to the input directory
#     -includeFilePat            Regular expression to determine which
#                                files to process, e.g. "(?i)\.pdf"
#     -excludeFilePat            Regular expression to determine which
#                                files to avoid processing, e.g. "(?i)\.pdf"
#     -maxFileSizeBytes          Skip files longer than this value
# 
#     Control the type of output with -x, -h, -t and/or -J.
# 
#     To modify child process jvm args, prepend "J" as in:
#     -JXmx4g or -JDlog4j.configuration=file:log4j.xml.
