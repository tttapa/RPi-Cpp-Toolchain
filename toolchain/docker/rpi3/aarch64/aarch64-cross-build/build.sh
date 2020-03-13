#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

docker build . --target python-opencv-build -t aarch64-python-opencv-cross

if [ "$#" = "0" ] || [ "$1" = "dev" ]; then
    docker build . --target developer-build -t aarch64-develop-cross
fi
