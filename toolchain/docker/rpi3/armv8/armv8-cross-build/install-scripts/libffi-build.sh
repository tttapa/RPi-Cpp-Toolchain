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
./autogen.sh
./configure \
    --prefix="$HOME/.local" \

# Build
make -j$(($(nproc) * 2))

# Install
make install

# Cleanup
popd
rm -rf libffi-3.2.1