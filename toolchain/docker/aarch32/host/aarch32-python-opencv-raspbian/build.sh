#!/usr/bin/env bash

set -e

platform='linux/arm/v7'

docker buildx inspect --bootstrap | grep "$platform" > /dev/null || { \
    ../../../../../scripts/install-docker-binfmt.sh && \
    docker buildx inspect --bootstrap; \
}

docker buildx build --platform "$platform" . --load \
    -t aarch32-python-opencv-raspbian