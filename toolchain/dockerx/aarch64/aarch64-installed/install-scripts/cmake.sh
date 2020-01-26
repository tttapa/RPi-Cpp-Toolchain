#!/usr/bin/env bash

set -ex

# Download
URL="https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/cmake-3.16.2.tar.gz"

# Configure
. cross-pkg-config
. crossenv/bin/activate
pushd cmake-3.16.2
./bootstrap --parallel=$(($(nproc) * 2)) -- \
        -DCMAKE_TOOLCHAIN_FILE=../RPi3.toolchain.cmake.cmake \
        -DCMAKE_BUILD_TYPE=Release

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI3_STAGING}"

# Cleanup
popd
rm -rf cmake-3.16.2