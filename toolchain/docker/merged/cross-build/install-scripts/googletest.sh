#!/usr/bin/env bash

set -ex

version="master" # Release tag on GitHub

# Download
git clone --single-branch --depth=1 --branch $version \
    https://github.com/google/googletest.git
mkdir googletest/build && pushd $_

# Configure
cmake \
    -DCMAKE_INSTALL_PREFIX="/usr/local" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="../../${HOST_TRIPLE}.cmake" \
    ..

# Build & Install
make -j$(nproc)
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

popd && rm -rf googletest