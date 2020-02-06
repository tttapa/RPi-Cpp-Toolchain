#!/usr/bin/env bash

set -ex

# Download
git clone --single-branch --depth 1 \
    https://github.com/raspberrypi/userland.git

mkdir -p userland/build/arm-linux/release
pushd userland/build/arm-linux/release

# Configure
. cross-pkg-config
cmake \
    -DCMAKE_TOOLCHAIN_FILE="/home/develop/RPi3.toolchain.userland.cmake" \
    -DCMAKE_BUILD_TYPE="Release" \
    -DCMAKE_SYSROOT="${RPI3_SYSROOT}" \
    -DCMAKE_INSTALL_PREFIX="/opt/vc" \
    -DCMAKE_INSTALL_RPATH='${CMAKE_INSTALL_PREFIX}/lib' \
    ../../..

# Build
make -j$(($(nproc) * 2)) all mmal

# Install
make install DESTDIR="${RPI3_SYSROOT}"
make install DESTDIR="${RPI3_STAGING}"

# Cleanup
popd
rm -rf userland