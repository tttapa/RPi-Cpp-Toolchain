#!/usr/bin/env bash

set -ex

# Download
URL="https://ftp.gnu.org/gnu/readline/readline-8.0.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/readline-8.0.tar.gz"
pushd readline-8.0

# Configure
. cross-pkg-config
./configure \
    --with-curses \
    --enable-shared \
    --prefix="/usr/local" \
    --host="${HOST_TRIPLE}" \
    CFLAGS="--sysroot=${RPI3_SYSROOT}" 

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI3_SYSROOT}"
make install DESTDIR="${RPI3_STAGING}"

# Cleanup
popd
rm -rf readline-8.0