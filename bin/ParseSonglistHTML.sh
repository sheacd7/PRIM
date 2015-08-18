#!/bin/bash
# META =========================================================================
# Title: ParseSonglistHTML.sh
# Usage: ParseSonglistHTML.sh -i [html file]
# Description: Parse the songlist html files into artist and song arrays.
# Author: Colin Shea
# Created: 2015-08-17
# TODO:
# - examples
#   <div class="product-title">Motion Sickness</div>
#   <div class="creator">Hot Chip</div>


# Marketplace "songs from our shows" page
IN_FILE="/cygdrive/c/users/sheacd/temp/PRIM/Marketplace-SongsFromOurShows.html"
ARTIST_LIST="/cygdrive/c/users/sheacd/temp/PRIM/unique_artists.txt"
TRACK_LIST="/cygdrive/c/users/sheacd/temp/PRIM/unique_tracks.txt"

# scrape song titles
mapfile -t titles < <(grep "<div class=\"product-title\">" "${IN_FILE}" \
 | sed "s/<\/div>$//" | sed "s/.*>//" | sed "s/\&amp;/\&/g")

# scrape song artists
mapfile -t artists < <(grep "<div class=\"creator\">" "${IN_FILE}" \
 | sed "s/<\/div>$//" | sed "s/.*>//" | sed "s/\&amp;/\&/g")


# load db artists to associative array for fast lookup
  # use temporary indexed array (restriction of mapfile, read)
mapfile -t temp_db_artists < <(awk -F "<SEP>" '{print $4}' "${ARTIST_LIST}")
  # copy into associative array for faster lookup
declare -A db_artists
for artist in "${temp_db_artists[@]}"; do 
  db_artists["$artist"]="$artist"
done
  # remove temporary array
unset temp_db_artists

# load db track titles
mapfile -t db_titles < <(awk -F "<SEP>" '{print $4}' "${TRACK_LIST}")

# search MSDB track list for titles

# search MSDB artist list for artists (fast)
for artist in "${artists[@]}"; do 
  [[ "$artist" ]] && [[ "${db_artists["$artist"]}" ]] && printf '%s\n' "$artist"
done

# search MSDB artist list for artists (naive w/o pre-load into array)
for artist in "${artists[@]}"; do 
  [[ "${artist}" ]] && grep -i -F "<SEP>${artist}$" "${ARTIST_LIST}" 
done
