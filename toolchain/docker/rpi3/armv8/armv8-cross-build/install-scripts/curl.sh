#!/usr/bin/env bash

set -ex

# Download
URL="https://curl.haxx.se/download/curl-7.68.0.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/curl-7.68.0.tar.gz"

# Configure
. cross-pkg-config
pushd curl-7.68.0
./configure \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local" \
    --with-ssl \
    CFLAGS="--sysroot ${RPI_SYSROOT} -O3 \
            -I${RPI_SYSROOT}/usr/local/include"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_STAGING}"
make install DESTDIR="${RPI_SYSROOT}"

# Cleanup
popd
rm -rf curl-7.68.0