# Cross-compiled Cython

The scripts in this folder demonstrate how to cross-compile Cython modules for
the Raspberry Pi.

The Cython hello world module is used as an example:
https://cython.readthedocs.io/en/latest/src/quickstart/build.html

Also check https://cython.readthedocs.io/en/latest/src/userguide/source_files_and_compilation.html
for more information.

Everything is explained in the `build.sh` and `build-docker.sh` scripts. You 
can also change the `docker/Dockerfile` if you need to install any dependencies
beforehand.

To build the example module, run the `build.sh` script with the appropriate 
target as an argument:

```sh
./build.sh aarch64-rpi3-linux-gnu
./build.sh armv8-rpi3-linux-gnueabihf
./build.sh armv6-rpi-linux-gnueabihf
```

The Python WHL packages will be in the `dist` folder when the build process is 
complete.
