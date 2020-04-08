#!/usr/bin/env bash

set -ex

# Download
git clone --single-branch --depth 1 \
    https://code.videolan.org/videolan/x264.git

# Configure
pushd x264
. cross-pkg-config
./configure \
    --host="${HOST_TRIPLE}" \
    --cross-prefix="${HOST_TRIPLE}-" \
    --sysroot="${RPI_SYSROOT}" \
    --enable-shared \
    --prefix="/usr/local" && \

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf x264