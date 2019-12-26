# Docker

## `crosstool-ng`

This folder builds a Docker container based on CentOS 7 with Crosstool-NG and its dependencies installed.  
CentOS 7 is used so that the resulting toolchain can be used on older systems as well (with an older GLibC and Linux Kernel version).

## `aarch32-toolchain` and `aarch64-toolchain`

These folders use the `crosstool-ng` container to build the GCC cross-compilation toolchains for 32-bit and 64-bit ARM architectures respectively.

## `base-ubuntu`

Creates a Ubuntu-based container with common build tools installed. This container will later be used to cross-compile all necessary libraries for the Raspberry Pi.

## `aarch32-installed` and `aarch64-installed`

These containers copy the toolchains built by the `aarch32-toolchain` and `aarch64-toolchain` containers into a container based on the `base-ubuntu` container and use them to cross-compile all libraries, Python, NumPy, OpenCV, etc.  
When finished, it stores the sysroot, staging area, and toolchain folders in a tar archive. These should be portable, and you can copy them to another machine to build other applications for the Raspberry Pi.

The staging area contains all libraries and binaries that have to be copied to the Raspberry Pi's filesystem.  
The sysroot contains the same files as the staging area, but also include the necessary system files required to cross-compile programs for the Raspberry Pi. You don't have to copy these files to the Pi, as they're already included with the operating system you've installed on the Pi.

## `docker-compose.yml`

This file specifies the dependencies between the different containers, and specifies some build options.

To build a container, you could for example use:
```sh
docker-compose up --no-start --build aarch64-installed
```

But it's recommended to use the [`toolchain/build-and-export-toolchain.sh`](../toolchain/build-and-export-toolchain.sh) script instead.
