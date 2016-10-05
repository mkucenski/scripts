#!/bin/bash

DEST="$1"
CASE="$2"
TEMPLATES="$3"

EVIDENCE="$TEMPLATES/Evidence Receipt Template.pdf"
CLOSING="$TEMPLATES/My Case Closing Summary Memo Template.docx"
OPENING="$TEMPLATES/My Case Opening-Executive Brief Template.docx"
EXAM="$TEMPLATES/My Digital Forensic Examination MOIA Template v2.docx"
TRIAGE="$TEMPLATES/My Digital Forensic Triage Memo Template.docx"
MOIA="$TEMPLATES/My Memorandum of Investigative Activity Template v2.docx"
REQUEST="$TEMPLATES/My Data Request Memorandum Template.docx"
ACQ="$TEMPLATES/My Digital Evidence Collection Report Template.pdf"

DIR="$DEST/$CASE/Case Documentation"
mkdir -p "$DIR"
mkdir -p "$DIR/Drafts"
mkdir -p "$DIR/Signed"
cp -i "$OPENING" "$DIR/Drafts"
cp -i "$CLOSING" "$DIR/Drafts"
cp -i "$EXAM" "$DIR/Drafts"
cp -i "$MOIA" "$DIR/Drafts"
cp -i "$REQUEST" "$DIR/Drafts"
mkdir -p "$DIR/Evidence"
mkdir -p "$DIR/Evidence/Photos"
cp -i "$EVIDENCE" "$DIR/Evidence"
cp -i "$ACQ" "$DIR/Evidence"

DIR="$DEST/$CASE/Triage"
mkdir -p "$DIR"
cp -i "$TRIAGE" "$DIR"

DIR="$DEST/$CASE/App Case Data"
mkdir -p "$DIR"
mkdir -p "$DIR/Nuix"
mkdir -p "$DIR/AccessData"
mkdir -p "$DIR/Sleuthkit"
mkdir -p "$DIR/Autopsy"
mkdir -p "$DIR/Encase"

DIR="$DEST/$CASE/Misc"
mkdir -p "$DIR"

