#!/usr/bin/env bash

set -e

docker build . --target python-opencv-build -t rpi-armv6-python-opencv-cross

if [ "$#" = "0" ] || [ "$1" = "dev" ]; then
    docker build . --target developer-build -t rpi-armv6-develop-cross
fi