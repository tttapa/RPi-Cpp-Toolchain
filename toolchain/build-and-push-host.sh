#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [ "$#" -ne 1 ]; then
    echo "Build the Raspberry Pi GCC toolchain and cross-compiled libraries,"
    echo "install it in an ARM Docker image and push it to Docker Hub."
    echo
    echo "Usage: $0 aarch32|aarch64|aarch64-dev"
    echo
    exit 0
fi

source scripts/parse-input.sh "$@"

./docker/aarch64/host/aarch64-develop/build.sh "$dev"
./docker/aarch64/host/aarch64-python-opencv/build.sh "$dev"

docker tag "$image" "tttapa/$image:latest"
docker push "tttapa/$image:latest"