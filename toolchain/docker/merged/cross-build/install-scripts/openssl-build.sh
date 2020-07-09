#!/usr/bin/env bash

set -ex

# Download
version=1_1_1g
URL="https://github.com/openssl/openssl/archive/OpenSSL_$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/OpenSSL_$version.tar.gz"
pushd openssl-OpenSSL_$version

# Configure
./config \
    --prefix="$HOME/.local"

# Build
make -j$(($(nproc) * 2))

# Install
make install_sw

# Cleanup
popd
rm -rf openssl-OpenSSL_$version
