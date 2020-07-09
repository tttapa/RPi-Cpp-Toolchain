#!/usr/bin/env bash

set -ex

# Download
URL="https://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/libuuid-1.0.3.tar.gz"
pushd libuuid-1.0.3

# Configure
. cross-pkg-config
./configure \
    --prefix="/usr/local" \
    --host="${HOST_TRIPLE}" \
    CFLAGS="--sysroot=${RPI_SYSROOT} -O3"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"
ln -s uuid/uuid.h ${RPI_SYSROOT}/usr/local/include/uuid.h

# Cleanup
popd
rm -rf libuuid-1.0.3