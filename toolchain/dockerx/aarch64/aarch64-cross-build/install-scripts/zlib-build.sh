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
./configure \
    --prefix="$HOME/.local"

# Build
make -j$(($(nproc) * 2))

# Install
make install

# Cleanup
popd
rm -rf zlib-1.2.11