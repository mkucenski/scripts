#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../common-include.sh" || exit 1

PREFIX="$(FULL_PATH "./")/opt"
./configure --prefix="$PREFIX" --with-openssl=/opt/local &&
		  make &&
		  make install

# `configure' configures libewf 20130416 to adapt to many kinds of systems.
# 
# Usage: ./configure [OPTION]... [VAR=VALUE]...
# 
# To assign environment variables (e.g., CC, CFLAGS...), specify them as
# VAR=VALUE.  See below for descriptions of some of the useful variables.
# 
# Defaults for the options are specified in brackets.
# 
# Configuration:
#   -h, --help              display this help and exit
#       --help=short        display options specific to this package
#       --help=recursive    display the short help of all the included packages
#   -V, --version           display version information and exit
#   -q, --quiet, --silent   do not print `checking ...' messages
#       --cache-file=FILE   cache test results in FILE [disabled]
#   -C, --config-cache      alias for `--cache-file=config.cache'
#   -n, --no-create         do not create output files
#       --srcdir=DIR        find the sources in DIR [configure dir or `..']
# 
# Installation directories:
#   --prefix=PREFIX         install architecture-independent files in PREFIX
#                           [/usr/local]
#   --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
#                           [PREFIX]
# 
# By default, `make install' will install all the files in
# `/usr/local/bin', `/usr/local/lib' etc.  You can specify
# an installation prefix other than `/usr/local' using `--prefix',
# for instance `--prefix=$HOME'.
# 
# For better control, use the options below.
# 
# Fine tuning of the installation directories:
#   --bindir=DIR            user executables [EPREFIX/bin]
#   --sbindir=DIR           system admin executables [EPREFIX/sbin]
#   --libexecdir=DIR        program executables [EPREFIX/libexec]
#   --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
#   --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
#   --localstatedir=DIR     modifiable single-machine data [PREFIX/var]
#   --libdir=DIR            object code libraries [EPREFIX/lib]
#   --includedir=DIR        C header files [PREFIX/include]
#   --oldincludedir=DIR     C header files for non-gcc [/usr/include]
#   --datarootdir=DIR       read-only arch.-independent data root [PREFIX/share]
#   --datadir=DIR           read-only architecture-independent data [DATAROOTDIR]
#   --infodir=DIR           info documentation [DATAROOTDIR/info]
#   --localedir=DIR         locale-dependent data [DATAROOTDIR/locale]
#   --mandir=DIR            man documentation [DATAROOTDIR/man]
#   --docdir=DIR            documentation root [DATAROOTDIR/doc/libewf]
#   --htmldir=DIR           html documentation [DOCDIR]
#   --dvidir=DIR            dvi documentation [DOCDIR]
#   --pdfdir=DIR            pdf documentation [DOCDIR]
#   --psdir=DIR             ps documentation [DOCDIR]
# 
# Program names:
#   --program-prefix=PREFIX            prepend PREFIX to installed program names
#   --program-suffix=SUFFIX            append SUFFIX to installed program names
#   --program-transform-name=PROGRAM   run sed PROGRAM on installed program names
# 
# System types:
#   --build=BUILD     configure for building on BUILD [guessed]
#   --host=HOST       cross-compile to build programs to run on HOST [BUILD]
# 
# Optional Features:
#   --disable-option-checking  ignore unrecognized --enable/--with options
#   --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
#   --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
#   --disable-largefile     omit support for large files
#   --enable-dependency-tracking
#                           do not reject slow dependency extractors
#   --disable-dependency-tracking
#                           speeds up one-time build
#   --enable-shared[=PKGS]  build shared libraries [default=yes]
#   --enable-static[=PKGS]  build static libraries [default=yes]
#   --enable-fast-install[=PKGS]
#                           optimize for fast installation [default=yes]
#   --disable-libtool-lock  avoid locking (might break parallel builds)
#   --disable-nls           do not use Native Language Support
#   --disable-rpath         do not hardcode runtime library paths
#   --enable-winapi         enable WINAPI support for cross-compilation
#                           [default=auto-detect]
#   --enable-wide-character-type
#                           enable wide character type support [default=no]
#   --enable-static-executables
#                           build static executables (binaries) [default=no]
#   --enable-low-level-functions
#                           use libewf's low level read and write functions in
#                           the ewftools [default=no]
#   --enable-verbose-output enable verbose output [default=no]
#   --enable-debug-output   enable debug output [default=no]
#   --enable-python         build Python bindings [default=no]
#   --enable-v1-api         enable version 1 API [default=no]
# 
# Optional Packages:
#   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
#   --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
#   --with-pic[=PKGS]       try to use only PIC/non-PIC objects [default=use
#                           both]
#   --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
#   --with-sysroot=DIR Search for dependent libraries within DIR
#                         (or the compiler's sysroot if not specified).
#   --with-gnu-ld           assume the C compiler uses GNU ld default=no
#   --with-libiconv-prefix[=DIR]  search for libiconv in DIR/include and DIR/lib
#   --without-libiconv-prefix     don't search for libiconv in includedir and libdir
#   --with-libintl-prefix[=DIR]  search for libintl in DIR/include and DIR/lib
#   --without-libintl-prefix     don't search for libintl in includedir and libdir
#   --with-libcstring[=DIR] search for libcstring in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libcerror[=DIR]  search for libcerror in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libcdata[=DIR]   search for libcdata in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libclocale[=DIR] search for libclocale in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libcnotify[=DIR] search for libcnotify in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libcsplit[=DIR]  search for libcsplit in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libuna[=DIR]     search for libuna in includedir and libdir or in the
#                           specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libcfile[=DIR]   search for libcfile in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libcpath[=DIR]   search for libcpath in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libbfio[=DIR]    search for libbfio in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libfcache[=DIR]  search for libfcache in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libfvalue[=DIR]  search for libfvalue in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libmfdata[=DIR]  search for libmfdata in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-zlib[=DIR]       search for zlib in includedir and libdir or in the
#                           specified DIR, or no if not to use zlib
#                           [default=auto-detect]
#   --with-adler32[=auto-detect]
#                           specify which alder32 implementation to use,
#                           options: 'auto-detect', 'zlib' or 'local'
#                           [default=auto-detect]
#   --with-bzip2[=DIR]      search for bzip2 in includedir and libdir or in the
#                           specified DIR, or no if not to use bzip2
#                           [default=auto-detect]
#   --with-libhmac[=DIR]    search for libhmac in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-openssl[=DIR]    search for openssl in includedir and libdir or in
#                           the specified DIR, or no if not to use openssl
#                           [default=auto-detect]
#   --with-libcaes[=DIR]    search for libcaes in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libcsystem[=DIR] search for libcsystem in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libuuid[=DIR]    search for libuuid in includedir and libdir or in
#                           the specified DIR, or no if not to use libuuid
#                           [default=auto-detect]
#   --with-libodraw[=DIR]   search for libodraw in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libmsdev[=DIR]   search for libmsdev in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libmsraw[=DIR]   search for libmsraw in includedir and libdir or in
#                           the specified DIR, or no if to use local version
#                           [default=auto-detect]
#   --with-libfuse[=DIR]    search for libfuse in includedir and libdir or in
#                           the specified DIR, or no if not to use libfuse
#                           [default=auto-detect]
#   --with-pyprefix[=no]    use `python-config --prefix' to determine the Python
#                           directories [default=no]
# 
# Some influential environment variables:
#   CC          C compiler command
#   CFLAGS      C compiler flags
#   LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
#               nonstandard directory <lib dir>
#   LIBS        libraries to pass to the linker, e.g. -l<library>
#   CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> if
#               you have headers in a nonstandard directory <include dir>
#   CPP         C preprocessor
#   PKG_CONFIG  path to pkg-config utility
#   PKG_CONFIG_PATH
#               directories to add to pkg-config's search path
#   PKG_CONFIG_LIBDIR
#               path overriding pkg-config's built-in search path
#   libcstring_CFLAGS
#               C compiler flags for libcstring, overriding pkg-config
#   libcstring_LIBS
#               linker flags for libcstring, overriding pkg-config
#   libcerror_CFLAGS
#               C compiler flags for libcerror, overriding pkg-config
#   libcerror_LIBS
#               linker flags for libcerror, overriding pkg-config
#   libcdata_CFLAGS
#               C compiler flags for libcdata, overriding pkg-config
#   libcdata_LIBS
#               linker flags for libcdata, overriding pkg-config
#   libclocale_CFLAGS
#               C compiler flags for libclocale, overriding pkg-config
#   libclocale_LIBS
#               linker flags for libclocale, overriding pkg-config
#   libcnotify_CFLAGS
#               C compiler flags for libcnotify, overriding pkg-config
#   libcnotify_LIBS
#               linker flags for libcnotify, overriding pkg-config
#   libcsplit_CFLAGS
#               C compiler flags for libcsplit, overriding pkg-config
#   libcsplit_LIBS
#               linker flags for libcsplit, overriding pkg-config
#   libuna_CFLAGS
#               C compiler flags for libuna, overriding pkg-config
#   libuna_LIBS linker flags for libuna, overriding pkg-config
#   libcfile_CFLAGS
#               C compiler flags for libcfile, overriding pkg-config
#   libcfile_LIBS
#               linker flags for libcfile, overriding pkg-config
#   libcpath_CFLAGS
#               C compiler flags for libcpath, overriding pkg-config
#   libcpath_LIBS
#               linker flags for libcpath, overriding pkg-config
#   libbfio_CFLAGS
#               C compiler flags for libbfio, overriding pkg-config
#   libbfio_LIBS
#               linker flags for libbfio, overriding pkg-config
#   libfcache_CFLAGS
#               C compiler flags for libfcache, overriding pkg-config
#   libfcache_LIBS
#               linker flags for libfcache, overriding pkg-config
#   libfvalue_CFLAGS
#               C compiler flags for libfvalue, overriding pkg-config
#   libfvalue_LIBS
#               linker flags for libfvalue, overriding pkg-config
#   libmfdata_CFLAGS
#               C compiler flags for libmfdata, overriding pkg-config
#   libmfdata_LIBS
#               linker flags for libmfdata, overriding pkg-config
#   zlib_CFLAGS C compiler flags for zlib, overriding pkg-config
#   zlib_LIBS   linker flags for zlib, overriding pkg-config
#   bzip2_CFLAGS
#               C compiler flags for bzip2, overriding pkg-config
#   bzip2_LIBS  linker flags for bzip2, overriding pkg-config
#   libhmac_CFLAGS
#               C compiler flags for libhmac, overriding pkg-config
#   libhmac_LIBS
#               linker flags for libhmac, overriding pkg-config
#   openssl_CFLAGS
#               C compiler flags for openssl, overriding pkg-config
#   openssl_LIBS
#               linker flags for openssl, overriding pkg-config
#   libcaes_CFLAGS
#               C compiler flags for libcaes, overriding pkg-config
#   libcaes_LIBS
#               linker flags for libcaes, overriding pkg-config
#   libcsystem_CFLAGS
#               C compiler flags for libcsystem, overriding pkg-config
#   libcsystem_LIBS
#               linker flags for libcsystem, overriding pkg-config
#   uuid_CFLAGS C compiler flags for uuid, overriding pkg-config
#   uuid_LIBS   linker flags for uuid, overriding pkg-config
#   libodraw_CFLAGS
#               C compiler flags for libodraw, overriding pkg-config
#   libodraw_LIBS
#               linker flags for libodraw, overriding pkg-config
#   YACC        The `Yet Another Compiler Compiler' implementation to use.
#               Defaults to the first program found out of: `bison -y', `byacc',
#               `yacc'.
#   YFLAGS      The list of arguments that will be passed by default to $YACC.
#               This script will default YFLAGS to the empty string to avoid a
#               default value of `-d' given by some make applications.
#   libsmdev_CFLAGS
#               C compiler flags for libsmdev, overriding pkg-config
#   libsmdev_LIBS
#               linker flags for libsmdev, overriding pkg-config
#   libsmraw_CFLAGS
#               C compiler flags for libsmraw, overriding pkg-config
#   libsmraw_LIBS
#               linker flags for libsmraw, overriding pkg-config
#   fuse_CFLAGS C compiler flags for fuse, overriding pkg-config
#   fuse_LIBS   linker flags for fuse, overriding pkg-config
# 
# Use these variables to override the choices made by `configure' or to help
# it to find libraries and programs with nonstandard names/locations.
# 
# Report bugs to <joachim.metz@gmail.com>.
