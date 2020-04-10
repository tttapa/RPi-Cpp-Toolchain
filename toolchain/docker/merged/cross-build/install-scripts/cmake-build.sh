#!/usr/bin/env bash

set -ex

# Download
URL="https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0-Linux-x86_64.sh"
pushd "${DOWNLOADS}"
wget -N "$URL"

chmod +x cmake-3.17.0-Linux-x86_64.sh
./cmake-3.17.0-Linux-x86_64.sh \
    --prefix="$HOME/.local" \
    --exclude-subdir \
    --skip-license

rm cmake-3.17.0-Linux-x86_64.sh
popd