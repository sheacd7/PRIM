#!/bin/bash
# META =========================================================================
# Title: ParseWikiTable.sh
# Usage: ParseWikiTable.sh -i [wiki html file]
# Description: Parse a wiki html table into array of data.
# Author: Colin Shea
# Created: 2015-08-12
# TODO:

IN_FILE="/cygdrive/c/users/sheacd/temp/PublicRadio/NPR-Stations-By-State-Edit.txt"
# remove all html tags and blank lines
mapfile -t arr < <(sed "s/<[^>]\{1,\}>//g" "${IN_FILE}" | sed '/^$/d')


