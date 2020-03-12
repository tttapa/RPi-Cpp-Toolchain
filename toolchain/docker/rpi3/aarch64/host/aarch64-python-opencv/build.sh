#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

platform='linux/arm64'

docker buildx inspect --bootstrap | grep "$platform" >/dev/null || {
    ../../../../../../scripts/install-docker-binfmt.sh
    docker buildx inspect --bootstrap
}

docker buildx build --platform "$platform" . --load -t aarch64-python-opencv
