#!/usr/bin/env bash

if [ "$#" = "1" ] && [ "$1" != "dev" ]; then
    echo "Skipping development build"
    exit 0
fi

set -e
docker build . -t rpi-armv6-cross-native-toolchain
