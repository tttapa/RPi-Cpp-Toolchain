#!/usr/bin/env bash

set -ex

# Download
version=3.7.9
URL="https://github.com/ccache/ccache/releases/download/v$version/ccache-$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/ccache-$version.tar.gz"

# Configure
. cross-pkg-config
pushd ccache-$version
./configure \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local" \
    CFLAGS="--sysroot ${RPI_SYSROOT} -O3 \
            $(pkg-config zlib --cflags)" \
    CXXFLAGS="--sysroot ${RPI_SYSROOT} -O3 \
            $(pkg-config zlib --cflags)" \
    LDFLAGS="$(pkg-config zlib --libs)"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf ccache-$version