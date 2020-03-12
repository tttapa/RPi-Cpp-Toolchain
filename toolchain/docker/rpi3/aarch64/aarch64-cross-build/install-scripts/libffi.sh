#!/usr/bin/env bash

set -ex

# Download
URL="https://codeload.github.com/libffi/libffi/tar.gz/v3.2.1"
pushd "${DOWNLOADS}"
wget -N "$URL" -O libffi-3.2.1.tar.gz
popd

# Extract
tar xzf "${DOWNLOADS}/libffi-3.2.1.tar.gz"
pushd libffi-3.2.1

# Configure
. cross-pkg-config
./autogen.sh
./configure \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local" \
    CFLAGS="-O2" CXXFLAGS="-O2" \
    --with-sysroot="${RPI3_SYSROOT}"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI3_SYSROOT}"
make install DESTDIR="${RPI3_STAGING}"

# Cleanup
popd
rm -rf libffi-3.2.1