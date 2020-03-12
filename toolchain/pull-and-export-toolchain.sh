#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 rpi|rpi-dev|rpi3-armv8|rpi3-armv8-dev|rpi3-aarch64|rpi3-aarch64-dev"
    exit 0
fi

source scripts/parse-input.sh "$@"

hubimg="tttapa/$image-cross:latest"
echo
echo "Pulling $hubimg ..."
echo
docker pull "$hubimg"
docker tag "$hubimg" "$image-cross"

source scripts/export.sh