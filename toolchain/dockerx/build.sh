#!/usr/bin/env bash

set -ex

cd "$( dirname "${BASH_SOURCE[0]}" )"

if true; then
# Install crosstool-ng
pushd crosstool-ng-master
./build.sh
popd

# Build a cross-compilation toolchain
pushd aarch64-cross-toolchain
./build.sh
popd

# Build a native toolchain for RPi
pushd aarch64-cross-native-toolchain
./build.sh
popd

# Install some build tools in on Ubuntu 
pushd base-ubuntu
./build.sh
popd
fi

# Cross-compile many dependencies for RPi
# including Python, OpenCV, FFmpeg ...
pushd aarch64-installed
./build.sh
popd

# Cross-compile build tools for RPi
pushd aarch64-installed-tools
./build.sh
popd

# Install build tools to ARM image
pushd aarch64-installed-tools-x
./build.sh
popd