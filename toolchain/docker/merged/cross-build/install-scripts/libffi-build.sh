#!/usr/bin/env bash

set -ex

# Download
version=3.3
URL="https://codeload.github.com/libffi/libffi/tar.gz/v$version"
pushd "${DOWNLOADS}"
wget -N "$URL" -O libffi-$version.tar.gz
popd

# Extract
tar xzf "${DOWNLOADS}/libffi-$version.tar.gz"
pushd libffi-$version

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
rm -rf libffi-$version