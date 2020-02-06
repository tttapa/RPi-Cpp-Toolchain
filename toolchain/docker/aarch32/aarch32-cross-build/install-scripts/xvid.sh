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
CFLAGS="--sysroot=${RPI3_SYSROOT}" \
CPPLAGS="--sysroot=${RPI3_SYSROOT}" \
LDLAGS="--sysroot=${RPI3_SYSROOT}" \
./configure \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI3_SYSROOT}"
make install DESTDIR="${RPI3_STAGING}"

# Cleanup
popd
rm -rf xvidcore-1.3.3