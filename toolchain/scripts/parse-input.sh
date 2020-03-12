#!/usr/bin/env bash

name="$1"
case "$name" in
rpi)
    echo "Raspberry Pi Zero and Raspberry Pi 1"
    target=armv6-rpi-linux-gnueabihf
    arch=armv6
    board=rpi
    image=rpi-armv6-python-opencv
    dev=nodev
    ;;
rpi-dev)
    echo "Raspberry Pi Zero and Raspberry Pi 1 (without development tools)"
    target=armv6-rpi-linux-gnueabihf
    arch=armv6
    board=rpi
    image=rpi-armv6-develop
    dev=dev
    ;;
rpi3-armv8)
    echo "armv8 (without development tools)"
    target=armv8-rpi3-linux-gnueabihf
    arch=armv8
    board=rpi3
    image=rpi3-armv8-python-opencv
    dev=nodev
    ;;
rpi3-armv8-dev)
    echo "armv8 (with development tools)"
    target=armv8-rpi3-linux-gnu
    arch=armv8
    board=rpi3
    image=rpi3-armv8-develop
    dev=dev
    ;;
rpi3-aarch64)
    echo "aarch64 (without development tools)"
    target=aarch64-rpi3-linux-gnu
    arch=aarch64
    board=rpi3
    image=rpi3-aarch64-python-opencv
    dev=nodev
    ;;
rpi3-aarch64-dev)
    echo "aarch64 (with development tools)"
    target=aarch64-rpi3-linux-gnu
    arch=aarch64
    board=rpi3
    image=rpi3-aarch64-develop
    dev=dev
    ;;
*)
    echo "Unknown option."
    echo "Choose either 'rpi3-armv8', 'rpi3-armv8-develop', 'rpi3-aarch64', 'rpi3-aarch64-develop'."
    exit 1
    ;;
esac
