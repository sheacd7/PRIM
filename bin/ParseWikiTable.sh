#!/bin/bash
# META =========================================================================
# Title: ParseWikiTable.sh
# Usage: ParseWikiTable.sh -i [wiki html file]
# Description: Parse a wiki html table into array of data.
# Author: Colin Shea
# Created: 2015-08-12
# TODO:

IN_FILE="/cygdrive/c/users/sheacd/temp/PRIM/NPR-Stations-By-State-Edit.html"
# remove all html tags and blank lines
mapfile -t arr < <(sed "s/<[^>]\{1,\}>//g" "${IN_FILE}" | sed '/^$/d')

# get idcs for state rows
# state rows have suffix '[edit]'
# states array format: [#]=[row_state]
declare -a states
for (( idx=0 ; idx<${#arr[@]} ; idx++ )); do 
  [[ "${arr[$idx]}" =~ edit\]$ ]] && states+=("$idx"_"${arr[$idx]%%\[edit\]}")
done

# build list of "state, city, station, frequency, modulation" from arr, state idcs
declare -a stations
for (( idx=0 ; idx<$(( ${#states[@]} - 1 )) ; idx++ )); do
  b_row=${states[$idx]%%_*}
  state=${states[$idx]##*_}
  e_row=${states[$(($idx + 1))]%%_*}
  length=$(( ($e_row - $b_row - 1)/3 ))
  for (( row=1 ; row<$length ; row+=3 )); do 
    # use [*] for group-quoting; [@] would quote elements individually
    # use escaped space to keep state string in same element
    stations+=("$state"\ "${arr[*]:$(( $b_row + $row )):3}")
  done

done

printf '%s\n' "${stations[@]}"


