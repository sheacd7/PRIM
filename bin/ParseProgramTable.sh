#!/bin/bash
# META =========================================================================
# Title: ParseProgramTable.sh
# Usage: ParseProgramTable.sh -i [html file]
# Description: Parse the NPR program html table into array of data.
# Author: Colin Shea
# Created: 2015-08-13
# TODO:

IN_FILE="/cygdrive/c/users/sheacd/temp/PRIM/NPR-Program-List-All.html"
# grab only h3 elements
# remove: all tags, all "Rights reserved" symbols
# replace: "\&amp;" with "&"
mapfile -t arr < \
  <(grep "<h3>" "${IN_FILE}" | sed "s/<span>.*$//" | sed "s/<[^>]\{1,\}>//g" \
    | sed "s/\&reg;//g" | sed "s/\&amp;/\&/g")

printf '%s\n' "${arr[@]}"


