#!/bin/bash

set -e  # Exit on any error

# Determine rootdir based on our script location
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOTDIR="$(dirname $DIR)"

LUA_SRC=${1:-$ROOTDIR/src/ButtonHUD.lua}

VERSION_NUMBER=`grep "VERSION_NUMBER = .*" $LUA_SRC | sed -E "s/\s*VERSION_NUMBER = (.*)/\1/"`
if [[ "${VERSION_NUMBER}" == "" ]]; then
    echo "ERROR: Failed to detect version number" 2>&1; exit 1
fi

echo "$VERSION_NUMBER"
