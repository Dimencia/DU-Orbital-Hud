#!/usr/bin/env bash

set -e  # exit on any error

# determine rootdir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOTDIR="$(dirname $DIR)"

VERSIONS=()
while read -r VERSION; do
    echo "[$VERSION]" 1>&2

    VERSIONS+=("$VERSION")
done < <(cat ${ROOTDIR}/ChangeLog.md | grep -n "^Version *[0-9]*\.[0-9].*$")

LATEST="${VERSIONS[0]}"
PREVIOUS="${VERSIONS[1]}"

echo "LATEST: [$LATEST], PREVIOUS: [$PREVIOUS]" 1>&2

LATESTLNO=$(echo "$LATEST" | grep -o '^[0-9]*')
PREVIOUSLNO=$(echo "$PREVIOUS" | grep -o '^[0-9]*')

cat ${ROOTDIR}/ChangeLog.md | head -n $(( $PREVIOUSLNO - 1)) | tail -n $(( $PREVIOUSLNO - $LATESTLNO ))
