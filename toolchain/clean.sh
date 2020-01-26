#!/usr/bin/env bash
cd "$(dirname "$0")"

if [ -d x-tools ]; then
    chmod -R u+w x-tools && rm -rf x-tools
fi
if [ -d RPi3-sysroot-aarch32 ]; then
    chmod -R u+w RPi3-sysroot-aarch32 && rm -rf RPi3-sysroot-aarch32
fi
if [ -d RPi3-sysroot-aarch64 ]; then 
    chmod -R u+w RPi3-sysroot-aarch64 && rm -rf RPi3-sysroot-aarch64
fi
if [ -d RPi3-sysroot-aarch64-dev ]; then 
    chmod -R u+w RPi3-sysroot-aarch64-dev && rm -rf RPi3-sysroot-aarch64-dev
fi
rm -f \
    RPi3-staging-aarch32.tar \
    RPi3-staging-aarch64.tar \
    RPi3-staging-aarch64-dev.tar
