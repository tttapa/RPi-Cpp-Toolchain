# Docker

## `crosstool-ng-master`

This folder builds a Docker container based on CentOS 7 with Crosstool-NG and its dependencies installed.  
CentOS 7 is used so that the resulting toolchain can be used on older systems as well (with an older GLibC and Linux Kernel version).

## `base-ubuntu`

Creates a Ubuntu-based container with common build tools installed. This container will later be used to cross-compile all necessary libraries for the Raspberry Pi.

## `rpi*`

The Dockerfiles in these folders use the `crosstool-ng` container to build the GCC cross-compilation toolchains, native toolchains for 32-bit and 64-bit ARM architectures respectively.  
They also cross-compile all libraries and tools for the Raspberry Pi, and create ARM Docker containers that can be run in an emulator on your computer, or on the Raspberry Pi directly.
