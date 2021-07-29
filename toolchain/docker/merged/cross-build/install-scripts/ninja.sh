#!/usr/bin/env bash

set -ex

# Download
version=1.10.2
URL="https://github.com/ninja-build/ninja/archive/v$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL" -O ninja-$version.tar.gz
popd

# Extract
tar xzf "${DOWNLOADS}/ninja-$version.tar.gz"

# Configure
. cross-pkg-config
. crossenv/bin/activate
pushd ninja-$version
mkdir build-cmake
pushd build-cmake
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE="../${HOST_TRIPLE}.cmake" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/usr/local"

# Build
make -j$(($(nproc) * 2))

# Install
# make install DESTDIR="${RPI_STAGING}"
# cmake --install . --prefix "${RPI_STAGING}/usr/local"
cp -a ninja "${RPI_STAGING}/usr/local/bin"
popd

# Cleanup
popd
rm -rf ninja-$version