#!/bin/bash
# META =========================================================================
# Title: GetSonglists.sh
# Usage: GetSonglists.sh -i [program list file]
# Description: Get songlists for each program.
# Author: Colin Shea
# Created: 2015-08-18
# TODO:

source /cygdrive/c/users/sheacd/locals/GitHub_local_env.sh

project_name="PRIM"
#PROGRAM_LIST="${GITHUB_DIR}"/"${project_name}"/data/Program-List-National.txt

OUT_DIR="${TEMP_DIR}"/"${project_name}"/songlists/html
mkdir -p "${OUT_DIR}"

# get program name, program url from program list

# initial scrape by page number to get all lists
# later, reorganize by show date since page number is constantly updated
for program in "marketplace"; do 
  for page in {0..353}; do
    # debug
    printf '%s: %s\n' "${program}" "${page}"
    OUT_FILE="${OUT_DIR}"/"${program}"-"${page}".html
    if [[ ! -f "${OUT_FILE}" ]]; then
      # set rate limiter here
      sleep 10
      # try songlist website link
      curl -o "${OUT_FILE}" 'http://www.marketplace.org/latest-music?page='"${page}"
    fi
  done
done
