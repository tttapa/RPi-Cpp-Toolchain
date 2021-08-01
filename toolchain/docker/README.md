# Docker

## `crosstool-ng-master`

This folder builds a Docker container based on Ubuntu 20.04 with crosstool-NG and its dependencies installed.  

## `base-ubuntu`

Creates a Ubuntu-based container with common build tools installed. This container will later be used to cross-compile all necessary libraries for the Raspberry Pi.

## `merged`

The Dockerfiles in this folder use the `crosstool-ng-master` container to build the GCC cross-compilation toolchains, native toolchains for 32-bit and 64-bit ARM architectures respectively.  
They also cross-compile all libraries and tools for the Raspberry Pi that you might need for your C/C++ projects.

It's recommended to use the `toolchain.sh` script one directory up. Trying to build the Docker images directly won't work, because they require certain build arguments.

The most important directory is probably `merged/cross-build/install-scripts`, it can be useful if you want to know how to cross-compile a certain package for the Raspberry Pi.