#!/usr/bin/env bash

if [ "$#" = "1" ] && [ "$1" != "dev" ]; then
    echo "Skipping development build"
    exit 0
fi

set -e
docker build . -t aarch32-cross-native-toolchain
