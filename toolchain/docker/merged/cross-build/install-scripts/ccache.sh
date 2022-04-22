#!/usr/bin/env bash

set -ex

# Download
version=4.6
URL="https://github.com/ccache/ccache/releases/download/v$version/ccache-$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/ccache-$version.tar.gz"

mkdir ccache-$version/build
pushd ccache-$version/build
# Configure
cmake \
    -DCMAKE_INSTALL_PREFIX="/usr/local" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="../../${HOST_TRIPLE}.cmake" \
    -DZSTD_FROM_INTERNET=ON \
    -DHIREDIS_FROM_INTERNET=ON \
    ..

# Build & Install
make -j$(nproc)
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf ccache-$version