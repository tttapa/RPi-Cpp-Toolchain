#!/usr/bin/env bash

set -ex

# Download
version=1.3.7
URL="https://downloads.xvid.com/downloads/xvidcore-$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "$DOWNLOADS/xvidcore-$version.tar.gz"

# Configure
pushd xvidcore/build/generic
. cross-pkg-config
CFLAGS="--sysroot=${RPI_SYSROOT} -O3" \
CPPLAGS="--sysroot=${RPI_SYSROOT}" \
LDLAGS="--sysroot=${RPI_SYSROOT}" \
./configure \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf xvidcore