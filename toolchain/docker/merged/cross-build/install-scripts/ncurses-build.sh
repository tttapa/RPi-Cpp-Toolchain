#!/usr/bin/env bash

set -ex

# Download
version=6.3
URL="https://ftp.gnu.org/gnu/ncurses/ncurses-$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/ncurses-$version.tar.gz"
pushd ncurses-$version

# Configure
./configure \
    --without-shared --without-debug

# Build
make -j$(($(nproc) * 2)) -C include
make -j$(($(nproc) * 2)) -C progs tic

# Install
install -v -m755 progs/tic "$HOME/tools"

# Cleanup
popd
rm -rf ncurses-$version