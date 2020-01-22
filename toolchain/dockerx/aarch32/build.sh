#!/usr/bin/env bash

set -ex

cd "$( dirname "${BASH_SOURCE[0]}" )"

# Install crosstool-ng
pushd ../crosstool-ng-master
./build.sh
popd

# Build a cross-compilation toolchain
pushd aarch32-cross-toolchain
./build.sh
popd

# Install some build tools in on Ubuntu 
pushd ../base-ubuntu
./build.sh
popd

# Cross-compile many dependencies for RPi
# including Python, OpenCV, FFmpeg ...
pushd aarch32-installed
./build.sh
popd

# Install build tools to ARM Raspbian image
pushd aarch32-installed-raspbian-x
./build.sh
popd