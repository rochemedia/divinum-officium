#!/usr/bin/env bash

# This script is designed to run in a bash environment and set the -e flag for
# exiting the script upon any error.
set -e

# Get the base directory of the script
# This is achieved by changing the directory to the one containing the script
# and then using pwd to print the full path.
basedir="$(cd "$(dirname "$0")" && pwd)"

# Source the 'util.sh' file located in the base directory
source "${basedir}/util.sh"

# Get the parent and test revisions from the Travis CI commit range variable
parent_rev="$(echo ${TRAVIS_COMMIT_RANGE} | perl -ne '/(.*)\.\.\./ && print $1')"
test_rev="${TRAVIS_COMMIT}"

# Get the short version from the VERSION file
short_version="$(cat "${basedir}/VERSION")"

# Check if the parent and test revisions are valid by attempting to parse
# them as git revisions. If either fails, the script will exit with an error.
if ! git rev-parse --verify "${parent_rev}" || ! git rev-parse --verify "${test_rev}"; then
  echo "Error: Invalid parent or test revision"
  exit 1
fi

# Define a function to format a date string in the format of MM-DD-YYYY
mdy_date() {
  # Use the 'date' command to format the input date in the desired format
  date "$@" +'%m-%d-%Y' 2>/dev/null || {
    echo "Error: Invalid date format" >&2;
    return 1;
  }
}

# Generate a diff between the parent and test revisions
# for the given date range and version
"${basedir}/generate-diff.sh" \
  "${parent_rev}" \
  "${test_rev}" \
  "<(echo $(mdy_date :"

# Note: The last line is incomplete, and it seems the script is missing some
# code that should follow this command
