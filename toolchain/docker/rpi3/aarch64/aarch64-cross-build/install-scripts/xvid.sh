#!/usr/bin/env bash

set -ex

# Download
URL="http://ftp.br.debian.org/debian-multimedia/pool/main/x/xvidcore/xvidcore_1.3.3.orig.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "$DOWNLOADS/xvidcore_1.3.3.orig.tar.gz"

# Configure
pushd xvidcore-1.3.3/build/generic
. cross-pkg-config
CFLAGS="--sysroot=${RPI_SYSROOT}" \
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
rm -rf xvidcore-1.3.3