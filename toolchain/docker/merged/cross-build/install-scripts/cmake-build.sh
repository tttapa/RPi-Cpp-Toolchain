#!/usr/bin/env bash

set -ex

# Download
version=3.21.1
URL="https://github.com/Kitware/CMake/releases/download/v$version/cmake-$version-Linux-x86_64.sh"
pushd "${DOWNLOADS}"
wget -N "$URL"

chmod +x cmake-$version-Linux-x86_64.sh
./cmake-$version-Linux-x86_64.sh \
    --prefix="$HOME/.local" \
    --exclude-subdir \
    --skip-license

rm cmake-$version-Linux-x86_64.sh
popd