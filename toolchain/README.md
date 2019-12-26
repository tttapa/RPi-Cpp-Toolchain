# Toolchain

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

It can take anywhere between 1 hour up to a couple of hours, depending on your hardware.

If you made changes to the Dockerfiles for the build, and you want to build and export it again, call `./clean.sh` first. 
It'll delete the cross-compilation toolchain, the sysroot and the staging area from this folder (it doesn't delete anything from the Docker containers).
