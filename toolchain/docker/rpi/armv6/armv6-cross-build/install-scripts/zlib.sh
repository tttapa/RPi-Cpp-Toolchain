#!/usr/bin/env bash

set -ex

# Download
URL="https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/zlib-1.2.11.tar.gz"
pushd zlib-1.2.11

# Configure
. cross-pkg-config
CFLAGS="--sysroot=${RPI_SYSROOT}" \
LDFLAGS="--sysroot=${RPI_SYSROOT}" \
CC="${HOST_TRIPLE}-gcc" \
LD="${HOST_TRIPLE}-ld" \
./configure \
    --prefix="/usr/local"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf zlib-1.2.11