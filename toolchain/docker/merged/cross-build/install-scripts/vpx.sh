#!/usr/bin/env bash

set -ex

# Download
git clone -b 'v1.11.0' --single-branch --depth 1 \
    https://chromium.googlesource.com/webm/libvpx

# Determine the architecture
case "${HOST_TRIPLE}" in
    aarch64* ) VPX_TARGET="arm64-linux-gcc" ;;
    armv8*   ) VPX_TARGET="armv8-linux-gcc" ;;
    armv7*   ) VPX_TARGET="armv7-linux-gcc" ;;
    armv6*   ) VPX_TARGET="generic-gnu" ;;
    *        ) echo "Unknown architecture ${HOST_TRIPLE}" && exit 1 ;;
esac

# Configure
pushd libvpx
. cross-pkg-config
CROSS="${HOST_TRIPLE}-" \
./configure \
    --enable-install-srcs \
    --disable-install-docs \
    --enable-shared \
    --target="${VPX_TARGET}" \
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