#!/usr/bin/env bash

set -ex

# Download
git clone --single-branch \
    https://github.com/raspberrypi/userland.git
# TODO: 64-bit MMAL support?
pushd userland
git checkout 291f9cb826d51ac30c1114cdc165836eacd8db52
popd

mkdir -p userland/build/arm-linux/release
pushd userland/build/arm-linux/release

# Configure
. cross-pkg-config
cmake \
    -DCMAKE_TOOLCHAIN_FILE="/home/develop/${HOST_TRIPLE}.userland.cmake" \
    -DCMAKE_BUILD_TYPE="Release" \
    -DCMAKE_SYSROOT="${RPI_SYSROOT}" \
    -DCMAKE_INSTALL_PREFIX="/opt/vc" \
    -DCMAKE_INSTALL_RPATH='${CMAKE_INSTALL_PREFIX}/lib' \
    -DCMAKE_C_FLAGS="-Wno-error=format-overflow" \
    ../../..

# Build
make -j$(($(nproc) * 2)) all mmal

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf userland