#!/bin/bash
# META =========================================================================
# Title: ParseSonglistHTML.sh
# Usage: ParseSonglistHTML.sh -i [html file]
# Description: Parse the songlist html files into artist and song arrays.
# Author: Colin Shea
# Created: 2015-08-17
# TODO:
# - fix regex for 
# <h2 class="grouped-title">
#   <a href="/shows/marketplace/marketplace-72513-criminal-charges-sac">
#     Marketplace for 7/25/13 - Criminal charges for SAC
#   </a>
# </h2>

# - examples
#   <h2 class="grouped-title">
#     <a href="/shows/marketplace/marketplace-tuesday-july-28-2015">
#       Marketplace for Tuesday, July 28, 2015 
#     </a></h2>
#   <div class="product-title">Motion Sickness</div>
#   <div class="creator">Hot Chip</div>

source /cygdrive/c/users/sheacd/locals/GitHub_local_env.sh
OUT_DIR="${TEMP_DIR}"/PRIM/songlists

# parse html into textfile list of dates/titles/artists
for program in "marketplace"; do 
  # consolidate individual html pages into one text file
  OUT_FILE="${OUT_DIR}"/"${program}"-all.txt
  if [[ ! -f "${OUT_FILE}" ]]; then
    for page in {0..353}; do
      printf '%s: %s\n' "${program}" "${page}"
      IN_FILE="${OUT_DIR}"/html/"${program}"-"${page}".html
      if [[ -f "${IN_FILE}" ]]; then
        egrep "(grouped-title|creator|product-title)" "${IN_FILE}" >> "${OUT_FILE}"
      fi
    done
  fi
  # clean up text
  OUT_FILE2="${OUT_FILE/%.txt/-edit.txt}"
  if [[ ! -f "${OUT_FILE2}" ]]; then
    # fix 
    sed 's,.*Marketplace.*for ,Date:,' "${OUT_FILE}" \
    | sed 's,[ ]*</a></h2>,,' \
    | sed 's,.*Marketplace Money,,' \
    | sed 's,.*product-title">,Title:,' \
    | sed 's,.*creator">,Artist:,' \
    | sed 's,</div>,,' \
    | sed 's,  , ,' \
    | sed '/^$/d' >> "${OUT_FILE2}"
  fi
  # standardize dates
  # strip out "Weekend of "
  # strip out day names (x)day
  # strip out show titles
  # convert month names to MM
  # convert "(,|.) " to "/"
  # convert /13$ to /2013$
  # replace ranges D-D
  # convert [0-9] to 0[0-9]
  #  use 'find' statement to select single-digit portions
  OUT_FILE3="${OUT_FILE2/%.txt/-dates.txt}"
  if [[ ! -f "${OUT_FILE3}" ]]; then
    grep "Date:" "${OUT_FILE2}" \
    | sed 's/Weekend\ of\ //' \
    | sed -r 's/(Mon|Tues|Wednes|Thurs|Fri)day[,]?\ //' \
    | sed 's/\ -.*//' \
    | sed 's/Jan[A-Za-z.,]*[ ]\{0,1\}/01\//' \
    | sed 's/Feb[A-Za-z.,]*[ ]\{0,1\}/02\//' \
    | sed 's/Mar[A-Za-z.,]*[ ]\{0,1\}/03\//' \
    | sed 's/Apr[A-Za-z.,]*[ ]\{0,1\}/04\//' \
    | sed 's/May[A-Za-z.,]*[ ]\{0,1\}/05\//' \
    | sed 's/Jun[A-Za-z.,]*[ ]\{0,1\}/06\//' \
    | sed 's/Jul[A-Za-z.,]*[ ]\{0,1\}/07\//' \
    | sed 's/Aug[A-Za-z.,]*[ ]\{0,1\}/08\//' \
    | sed 's/Sep[A-Za-z.,]*[ ]\{0,1\}/09\//' \
    | sed 's/Oct[A-Za-z.,]*[ ]\{0,1\}/10\//' \
    | sed 's/Nov[A-Za-z.,]*[ ]\{0,1\}/11\//' \
    | sed 's/Dec[A-Za-z.,]*[ ]\{0,1\}/12\//' \
    | sed 's/[,.]\{0,1\}\ /\//' \
    | sed 's/,[ ]\{0,1\}/\//' \
    | sed 's/\/13$/\/2013/' \
    | sed 's/-[0-9]\{1,2\}//' \
    | sed '/\/[0-9]\// s,\/,\/0,' \
    | sed '/:[0-9]\// s,:,:0,' >> "${OUT_FILE3}"
    # 01/30 (2008)
    # 10/31 (2009)
    # 07/25/13 - SAC

      # reorder from MM-DD-YYYY to YYYY-MM-DD
  fi

done


# scrape song titles
#mapfile -t titles < <(grep "<div class=\"product-title\">" "${IN_FILE}" \
# | sed "s/<\/div>$//" | sed "s/.*>//" | sed "s/\&amp;/\&/g")
# scrape song artists
#mapfile -t artists < <(grep "<div class=\"creator\">" "${IN_FILE}" \
# | sed "s/<\/div>$//" | sed "s/.*>//" | sed "s/\&amp;/\&/g")

# ==============================================================================
# Scratch

  # Oct.3[0-1]/2007
  # Jan/2, 2008
  # Jan/23, 2008
  # March/12, 2009
  # March/18, 2010
  # May/19, 2010
  # 12/21. 2010
  # 01/17. 2011
  # 06/3 2011
  # 06/12 2014
  # 06/19 2014
  # 05/22,2014
  # 07/23,2014

  # one-off erros to fix at source
  # 01/30     (2010)
  # 07/25//2011
  # SAC
  # 2o12
  # 04/14/208
  # Date:October 31 - Nov. 1, 2009



# Marketplace "songs from our shows" page
#ARTIST_LIST="/cygdrive/c/users/sheacd/temp/PRIM/unique_artists.txt"
#TRACK_LIST="/cygdrive/c/users/sheacd/temp/PRIM/unique_tracks.txt"

# load db artists to associative array for fast lookup
  # use temporary indexed array (restriction of mapfile, read)
#mapfile -t temp_db_artists < <(awk -F "<SEP>" '{print $4}' "${ARTIST_LIST}")
  # copy into associative array for faster lookup
#declare -A db_artists
#for artist in "${temp_db_artists[@]}"; do 
#  db_artists["$artist"]="$artist"
#done
  # remove temporary array
#unset temp_db_artists

# load db track titles
#mapfile -t db_titles < <(awk -F "<SEP>" '{print $4}' "${TRACK_LIST}")

# search MSDB track list for titles

# search MSDB artist list for artists (fast)
#for artist in "${artists[@]}"; do 
#  [[ "$artist" ]] && [[ "${db_artists["$artist"]}" ]] && printf '%s\n' "$artist"
#done

# search MSDB artist list for artists (naive w/o pre-load into array)
#for artist in "${artists[@]}"; do 
#  [[ "${artist}" ]] && grep -i -F "<SEP>${artist}$" "${ARTIST_LIST}" 
#done
