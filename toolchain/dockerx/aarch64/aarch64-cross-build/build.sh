#!/usr/bin/env bash

set -e

docker build . --target python-opencv-build -t aarch64-python-opencv-cross
docker build . --target developer-build     -t aarch64-develop-cross
