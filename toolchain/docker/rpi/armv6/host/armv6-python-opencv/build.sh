#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

platform='linux/arm/v7'

docker buildx inspect --bootstrap | grep "$platform" >/dev/null || {
    ../../../../../../scripts/install-docker-binfmt.sh
    docker buildx inspect --bootstrap
}

docker buildx build --platform "$platform" . --load -t rpi-armv6-python-opencv
