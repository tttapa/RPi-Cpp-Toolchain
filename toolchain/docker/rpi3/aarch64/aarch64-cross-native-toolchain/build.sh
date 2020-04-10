#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

if [ "$#" = "1" ] && [ "$1" != "dev" ]; then
    echo "Skipping development build"
    exit 0
fi

docker build . -t tttapa/rpi3-aarch64-cross-native-toolchain
