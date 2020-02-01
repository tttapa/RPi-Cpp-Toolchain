#!/usr/bin/env bash

name="$1"
case "$name" in
aarch32)
    echo "aarch32 (without development tools)"
    target=armv8-rpi3-linux-gnueabihf
    arch=aarch32
    image=aarch32-python-opencv
    dev=nodev
    ;;
aarch64)
    echo "aarch64 (without development tools)"
    target=aarch64-rpi3-linux-gnu
    arch=aarch64
    image=aarch64-python-opencv
    dev=nodev
    ;;
aarch64-dev)
    echo "aarch64 (with development tools)"
    target=aarch64-rpi3-linux-gnu
    arch=aarch64
    image=aarch64-develop
    dev=dev
    ;;
*)
    echo "Unknown option."
    echo "Choose either 'aarch32', 'aarch64', 'aarch64-develop'."
    exit 1
    ;;
esac
