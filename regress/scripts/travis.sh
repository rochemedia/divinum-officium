#!/usr/bin/env bash

set -e

# Get the base directory of the script
basedir="$(cd "$(dirname "$0")" && pwd)"
source "${basedir}/util.sh"

# Get the parent and test revisions
parent_rev="$(echo ${TRAVIS_COMMIT_RANGE} | perl -ne '/(.*)\.\.\./ && print $1')"
test_rev="${TRAVIS_COMMIT}"

# Get the short version from the VERSION file
short_version="$(cat "${basedir}/VERSION")"

# Check if the parent and test revisions are valid
if ! git rev-parse --verify "${parent_rev}" || ! git rev-parse --verify "${test_rev}"; then
  echo "Error: Invalid parent or test revision"
  exit 1
fi

# Format a date string in the format of MM-DD-YYYY
mdy_date() {
  date "$@" +'%m-%d-%Y' 2>/dev/null || { echo "Error: Invalid date format" >&2; return 1; }
}

# Generate a diff between the parent and test revisions
# for the given date range and version
"${basedir}/generate-diff.sh" \
  "${parent_rev}" \
  "${test_rev}" \
  "<(echo $(mdy_date :
