#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

docker build . --target python-opencv-build -t rpi3-armv8-python-opencv-cross

if [ "$#" = "0" ] || [ "$1" = "dev" ]; then
    docker build . --target developer-build -t rpi3-armv8-develop-cross
fi