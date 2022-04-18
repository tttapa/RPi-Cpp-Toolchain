#!/usr/bin/env bash

set -ex

# Download
version=7.82.0
URL="https://github.com/curl/curl/releases/download/curl-${version//./_}/curl-$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/curl-$version.tar.gz"

# Configure
. cross-pkg-config
pushd curl-$version
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
rm -rf curl-$version