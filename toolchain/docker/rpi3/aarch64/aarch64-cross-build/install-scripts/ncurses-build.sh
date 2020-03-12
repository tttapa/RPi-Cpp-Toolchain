#!/usr/bin/env bash

set -ex

# Download
URL="ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/ncurses-6.1.tar.gz"
pushd ncurses-6.1

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
rm -rf ncurses-6.1