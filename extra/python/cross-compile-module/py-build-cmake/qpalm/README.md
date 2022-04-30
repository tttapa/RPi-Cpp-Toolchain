# Cross-compiled Python C/C++ extension

The scripts in this folder demonstrate how to cross-compile Python modules for
the Raspberry Pi. The [QPALM](https://github.com/kul-optec/QPALM) package is 
used as an example, and [py-build-cmake](https://github.com/tttapa/py-build-cmake)
is used as a build backend.

Everything is explained in the `build.sh` and `build-docker.sh` scripts. You 
can also change the `docker/Dockerfile` if you need to install any dependencies
beforehand.

To build the package, run the `build.sh` script with the appropriate target as
an argument:

```sh
./build.sh aarch64-rpi3-linux-gnu
./build.sh armv8-rpi3-linux-gnueabihf
./build.sh armv6-rpi-linux-gnueabihf
```

The Python wheel packages will be in the `wheelhouse` folder when the build
process is complete.
