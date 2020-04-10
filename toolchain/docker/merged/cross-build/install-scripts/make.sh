#!/usr/bin/env bash

set -ex

# Download
URL="https://ftpmirror.gnu.org/gnu/make/make-4.3.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/make-4.3.tar.gz"

# Configure
. cross-pkg-config
pushd make-4.3
./configure \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local" \
    CFLAGS="--sysroot=${RPI_SYSROOT} -O3" \
    CXXFLAGS="--sysroot=${RPI_SYSROOT} -O3"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf make-4.3