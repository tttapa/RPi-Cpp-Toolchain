#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [ "$#" -ne 1 ]; then
    echo "Build the Raspberry Pi GCC toolchain and cross-compiled libraries."
    echo
    echo "Usage: $0 aarch32|aarch32-dev|aarch64|aarch64-dev"
    echo
    exit 0
fi

source scripts/parse-input.sh "$@"

./docker/$arch/build.sh "$dev"
