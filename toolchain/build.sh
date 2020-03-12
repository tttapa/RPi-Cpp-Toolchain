#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [ "$#" -ne 1 ]; then
    echo "Build the Raspberry Pi GCC toolchain and cross-compiled libraries."
    echo
    echo "Usage: $0 rpi|rpi-dev|rpi3-armv8|rpi3-armv8-dev|rpi3-aarch64|rpi3-aarch64-dev"
    echo
    exit 0
fi

source scripts/parse-input.sh "$@"

./docker/$board/$arch/build.sh "$dev"
