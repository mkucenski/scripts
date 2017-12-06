#!/usr/bin/env bash

perl -we '$recs = ""; while (<>) {$recs .= $_};$uid = 0;foreach (split(/(.{292})/s,$recs)) {next if length($_) == 0;my ($binTime,$line,$host) = $_ =~/(.{4})(.{32})(.{256})/;if (defined $line && $line =~ /\w/) {$line =~ s/\x00+//g;$host =~ s/\x00+//g;printf("%5d %s %8s %s\n",$uid,scalar(gmtime(unpack("I4",$binTime))),$line,$host)}$uid++}print"\n"' < "$1"
 
