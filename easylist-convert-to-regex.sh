#!/usr/bin/env bash

cat "$1" | egrep -v "^(\!|\[)" | gsed -r 's/~?(script|image|stylesheet|object|xmlhttprequest|object-subrequest|subdocument|ping|document|elemhide|generichide|genericblock|other|third-party|popup|collapse|font|media),?//g'
