#!/usr/bin/env bash

set -ex

# Download
version=3.23.1
URL="https://github.com/Kitware/CMake/releases/download/v$version/cmake-$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/cmake-$version.tar.gz"

# Configure
. cross-pkg-config
. crossenv/bin/activate
pushd cmake-$version
./bootstrap --parallel=$(($(nproc) * 2)) -- \
        -DCMAKE_TOOLCHAIN_FILE="../${HOST_TRIPLE}.cmake" \
        -DCMAKE_BUILD_TYPE=Release

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf cmake-$version