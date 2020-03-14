# Toolchain


## Building the Toolchain

See also:

- [Building the Cross-Compilation Toolchain](https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development/Building-The-Toolchain.html)
- [Cross-Compiling the Dependencies](https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development/Dependencies.html)

To build the cross-compilation toolchain and cross-compile the libraries, use one of the following commands:

```sh
./build-and-export.sh rpi
./build-and-export.sh rpi-dev
./build-and-export.sh rpi3-armv8
./build-and-export.sh rpi3-armv8-dev
./build-and-export.sh rpi3-aarch64
./build-and-export.sh rpi3-aarch64-dev
```

To build just the toolchains (without cross-compiling the libraries), use one of the following commands:

```sh
./build-and-export-toolchain.sh rpi
./build-and-export-toolchain.sh rpi-dev
./build-and-export-toolchain.sh rpi3-armv8
./build-and-export-toolchain.sh rpi3-armv8-dev
./build-and-export-toolchain.sh rpi3-aarch64
./build-and-export-toolchain.sh rpi3-aarch64-dev
```

It can take anywhere between 1 hour and a couple of hours, depending on your hardware.

## Downloading the pre-built Toolchain from Docker Hub

To download the cross-compilation toolchain and cross-compiled libraries, use one of the following commands:

```sh
./pull-and-export.sh rpi
./pull-and-export.sh rpi-dev
./pull-and-export.sh rpi3-armv8
./pull-and-export.sh rpi3-armv8-dev
./pull-and-export.sh rpi3-aarch64
./pull-and-export.sh rpi3-aarch64-dev
```

## Deleting the toolchain

The toolchain is read-only, so you can't simply delete it using `rm` or using
a file manager.  
The `clean.sh` script will delete the toolchain, the sysroot and the staging 
area for all architectures and configurations.  
It doesn't delete anything from the Docker containers, so you can just export it
again later, without building everything from scratch.

```sh
./clean.sh
```