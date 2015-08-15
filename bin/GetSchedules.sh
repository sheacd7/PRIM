#!/bin/bash
# META =========================================================================
# Title: GetSchedules.sh
# Usage: GetSchedules.sh -i [station list file]
# Description: Get program schedules for each NPR station.
# Author: Colin Shea
# Created: 2015-08-14
# TODO:
#   - handful of stations do not have website listed on wiki
#   - from URLs, need to extract program/schedule


source /cygdrive/c/users/sheacd/locals/GitHub_local_env.sh

project_name="PRIM"
STATION_LIST="${GITHUB_DIR}"/"${project_name}"/data/Station-List-NPR.txt
STATION_WIKI="${GITHUB_DIR}"/"${project_name}"/html/NPR-Stations-By-State-Edit.html
STATION_URLS="${GITHUB_DIR}"/"${project_name}"/data/Station-URLs.txt

OUT_DIR="${TEMP_DIR}"/"${project_name}"/homepages
mkdir -p "${OUT_DIR}"

# grab station callsigns
# mapfile -t callsigns < <( grep -E -o "[WK][A-Z]{3,3}" "${STATION_LIST}" )
mapfile -t callsigns < <( grep -E -o "[WK][A-Z]{3,3}(-FM){0,1}" "${STATION_LIST}" )

# build array of homepages for each station from wikipedia
declare -A urls
for callsign in "${callsigns[@]}"; do 
  # try wiki website link
  wiki_href="$( grep -m 1 ">${callsign}<" "${STATION_WIKI}" )"
  wiki_href="${wiki_href##*href=\"}"
  wiki_href="${wiki_href%%\"\ *}"
  #| grep -o "/wiki/${callsign}[^\"]\{0,\}" )"
  OUT_FILE="${OUT_DIR}"/"${callsign}"-wiki.html
  if [[ ! -f "${OUT_FILE}" ]]; then
    curl -o "${OUT_FILE}" https://en.wikipedia.org"${wiki_href}"
  fi
  link="$(grep -m 1 -A 1 "Website" "${OUT_FILE}" | grep -o "href=[^>]\{1,\}>")"
  link="${link%\">}"
  urls["${callsign}"]="${link#href=\"}"
done

for callsign in "${!urls[@]}"; do 
  printf '%s, %s\n' "$callsign" "${urls[$callsign]}"
done | sort > "${STATION_URLS}"



# scratch
# curl -o "${OUT_FILE}" http://radio-locator.com/cgi-bin/finder?sr=Y&s=C&call="${callsign}"&x=0&y=0
