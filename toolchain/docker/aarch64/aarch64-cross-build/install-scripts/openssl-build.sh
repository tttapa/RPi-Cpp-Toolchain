#!/usr/bin/env bash

set -ex

# Download
URL="https://github.com/openssl/openssl/archive/OpenSSL_1_1_1c.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/OpenSSL_1_1_1c.tar.gz"
pushd openssl-OpenSSL_1_1_1c

# Configure
./config \
    --prefix="$HOME/.local"

# Build
make -j$(($(nproc) * 2))

# Install
make install_sw

# Cleanup
popd
rm -rf openssl-OpenSSL_1_1_1c