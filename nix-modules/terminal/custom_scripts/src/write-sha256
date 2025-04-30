#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: write-sha256 <filename>"
    exit 1
fi

if [ -f "$1" ]; then
    sha256sum "$1" > "$1".sha256
else
    echo "Error: $1 is not a file"
    exit 1
fi
