#!/usr/bin/env bash

set -ex

# Download
git clone -b 'v1.8.2' --single-branch --depth 1 \
    https://chromium.googlesource.com/webm/libvpx

# Configure
pushd libvpx
. cross-pkg-config
CROSS="${HOST_TRIPLE}-" \
./configure \
    --enable-install-srcs \
    --disable-install-docs \
    --target="arm64-linux-gcc" \
    --prefix="/usr/local" \
    --extra-cflags="--sysroot=${RPI_SYSROOT}" \
    --extra-cxxflags="--sysroot=${RPI_SYSROOT}"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf libvpx