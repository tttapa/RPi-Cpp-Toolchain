#!/usr/bin/env bash

set -ex

cd "$(dirname "${BASH_SOURCE[0]}")"

# Install crosstool-ng
pushd ../../crosstool-ng-master
./build.sh
popd

# Build a cross-compilation toolchain for Raspberry Pi 3/3B+
pushd armv6-cross-toolchain
./build.sh
popd

# # Build a native toolchain for Raspberry Pi 3/3B+
pushd armv6-cross-native-toolchain
./build.sh "$1"
popd

# Install some build tools on Ubuntu
pushd ../../base-ubuntu
./build.sh
popd

# Creates two images, one with cross-compiled Python, OpenCV, FFmpeg etc.
# libraries and executables for the Raspberry Pi, and another one that includes
# all this, and also development tools like Make, CMake, GCC, CCache, DistCC
# and Git
pushd armv6-cross-build
./build.sh "$1"
popd

if false; then
    # Install the cross-compiled libraries and executables to an ARM image
    pushd host/armv6-python-opencv
    ./build.sh
    popd

    # Install the development tools to an ARM image
    pushd host/armv6-develop
    ./build.sh "$1"
    popd
fi
