#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 aarch32|aarch64|aarch64-dev"
    exit 0
fi

source scripts/parse-input.sh "$@"

hubimg="tttapa/$image:latest"
echo
echo "Pulling $hubimg ..."
echo
docker pull "$hubimg"
docker tag "$hubimg" "$image"

source scripts/export.sh