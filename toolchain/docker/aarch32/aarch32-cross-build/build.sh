#!/usr/bin/env bash

set -e

docker build . --target python-opencv-build -t aarch32-python-opencv-cross

if [ "$#" = "0" ] || [ "$1" = "dev" ]; then
    docker build . --target developer-build -t aarch32-develop-cross
fi