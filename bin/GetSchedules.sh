#!/bin/bash
# META =========================================================================
# Title: GetSchedules.sh
# Usage: GetSchedules.sh -i [station list file]
# Description: Get program schedules for each station.
# Author: Colin Shea
# Created: 2015-08-14
# TODO:
#   - Outliers: KUT, WOI, WOI-FM 
#   - handful of stations do not have website listed on wiki
#     KCUK, http://kcukradio.org
#     WJAB, http://www.wjab.org
#     WSLZ, http://www.northcountrypublicradio.org
#     WUWG, http://www.gpb.org/public/radio
#     WVKC, http://thewvkc.com
#     WVTW, http://www.wvtf.org
#     WWVT, http://www.wvtf.org
#     WXLB, http://www.northcountrypublicradio.org
#     WSLG, http://www.northcountrypublicradio.org
#   - from URLs, need to extract program/schedule
#   - sister stations (identical programs, different call signs)


source /cygdrive/c/users/sheacd/locals/GitHub_local_env.sh

project_name="PRIM"
STATION_LIST="${GITHUB_DIR}"/"${project_name}"/data/Station-List-NPR.txt
NPR_WIKI="${GITHUB_DIR}"/"${project_name}"/html/NPR-Stations-By-State-Edit.html
STATION_URLS="${GITHUB_DIR}"/"${project_name}"/data/Station-URLs.txt

OUT_DIR="${TEMP_DIR}"/"${project_name}"/homepages
mkdir -p "${OUT_DIR}"

# grab station callsigns
# mapfile -t callsigns < <( grep -E -o "[WK][A-Z]{3,3}" "${STATION_LIST}" )
mapfile -t callsigns < <( sed '/^$/d' "${STATION_LIST}" | grep -E -o "[WK][A-Z]{2,3}(-FM){0,1}"  )

# build array of homepages for each station from wikipedia
declare -A urls
for callsign in "${callsigns[@]}"; do 
  WIKI_FILE="${OUT_DIR}"/"${callsign}"-wiki.html
  if [[ ! -f "${WIKI_FILE}" ]]; then
    # try wiki website link
    wiki_href="$( grep -m 1 ">${callsign}<" "${NPR_WIKI}" )"
    wiki_href="${wiki_href##*href=\"}"
    wiki_href="${wiki_href%%\"\ *}"
    curl -o "${WIKI_FILE}" https://en.wikipedia.org"${wiki_href}"
  fi
  link="$(grep -m 1 -A 1 "Website" "${WIKI_FILE}" | grep -o "href=[^>]\{1,\}>")"
  link="${link%\">}"
  link="${link#href=\"}"
  urls["${callsign}"]="${link%/}"
done

for callsign in "${callsigns[@]}"; do # "${!urls[@]}"; do 
  printf '%s, %s\n' "$callsign" "${urls[$callsign]}"
done | sort #> "${STATION_URLS}"

# scratch
# curl -o "${WIKI_FILE}" http://radio-locator.com/cgi-bin/finder?sr=Y&s=C&call="${callsign}"&x=0&y=0
