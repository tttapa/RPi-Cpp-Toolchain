#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [ "$#" = "1" ] && [ "$1" != "dev" ]; then
    echo "Skipping development build"
    exit 0
fi

platform='linux/arm/v7'

docker buildx inspect --bootstrap | grep "$platform" >/dev/null || {
    ../../../../../../scripts/install-docker-binfmt.sh
    docker buildx inspect --bootstrap
}

docker buildx build --platform "$platform" . --load -t rpi3-armv8-develop
