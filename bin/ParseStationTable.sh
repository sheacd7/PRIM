#!/bin/bash
# META =========================================================================
# Title: ParseStationTable.sh
# Usage: ParseStationTable.sh -i [html file]
# Description: Parse the station list into array of data.
# Author: Colin Shea
# Created: 2015-08-20
# TODO:
# - <A HREF="/cgibin/source.pl?cmd=ps&amp;sourceid=271">KCCK</A> (20 programs)

IN_FILE="/cygdrive/c/users/sheacd/temp/PRIM/all-stations-edit.html"
# grab only h3 elements
mapfile -t arr < \
  <(sed '/^$/d' "${IN_FILE}")

printf '%s\n' "${arr[@]}"

