# Toolchain


## Building the Toolchain

See also:

- [Building the Cross-Compilation Toolchain](https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development/Building-The-Toolchain.html)
- [Cross-Compiling the Dependencies](https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development/Dependencies.html)

To build the cross-compilation toolchain and cross-compile the libraries, use one of the following commands:

```sh
./build-and-export-toolchain.sh aarch32
```
```sh
./build-and-export-toolchain.sh aarch64
```
```sh
./build-and-export-toolchain.sh aarch64-dev
```

It can take anywhere between 1 hour and a couple of hours, depending on your hardware.

## Downloading the pre-built Toolchain from Docker Hub

To download the cross-compilation toolchain and cross-compiled libraries, use one of the following commands:

```sh
./pull-and-export-toolchain.sh aarch32
```
```sh
./pull-and-export-toolchain.sh aarch64
```

## Deleting the toolchain

The toolchain is read-only, so you can't simply delete it using `rm` or using
a file manager.  
The `clean.sh` script will delete the toolchain, the sysroot and the staging 
area for all architectures and configurations.  
It doesn't delete anything from the Docker containers, so you can just export it
again later, without building everything from scratch.