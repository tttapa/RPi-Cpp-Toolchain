#!/usr/bin/env bash

set -ex

# Download
URL="https://github.com/ninja-build/ninja/archive/v1.10.0.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL" -O ninja-1.10.0.tar.gz
popd

# Extract
tar xzf "${DOWNLOADS}/ninja-1.10.0.tar.gz"

# Configure
. cross-pkg-config
. crossenv/bin/activate
pushd ninja-1.10.0
mkdir build-cmake
pushd build-cmake
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=../RPi.toolchain.cmake.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/usr/local"

# Build
make -j$(($(nproc) * 2))

# Install
# make install DESTDIR="${RPI_STAGING}"
# cmake --install . --prefix "${RPI_STAGING}/usr/local"
cp -a ninja "${RPI_STAGING}/usr/local/bin"
popd

# Cleanup
popd
rm -rf ninja-1.10.0