#!/usr/bin/env bash

set -e

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

docker buildx inspect --bootstrap | grep "$platform" >/dev/null || {
    ../../../../../../scripts/install-docker-binfmt.sh
    docker buildx inspect --bootstrap
}

docker buildx build --platform "$platform" . --load \
    -t rpi3-armv8-python-opencv
