[![Download from Docker Hub](https://img.shields.io/docker/pulls/tttapa/aarch64-python-opencv-cross?label=Docker%20Hub%20AArch64&logo=docker)](https://hub.docker.com/repository/docker/tttapa/aarch64-python-opencv-cross)
[![Download from Docker Hub](https://img.shields.io/docker/pulls/tttapa/aarch64-develop-cross?label=Docker%20Hub%20AArch64%20(dev)&logo=docker)](https://hub.docker.com/r/tttapa/aarch64-devel-cross)

# Raspberry Pi C++ Toolchain

This repository contains all you need to develop and cross-compile C++ applications for the Raspberry Pi (both 32 and 64 bit).
Everything was tested using [Ubuntu Server 18.04](https://ubuntu.com/download/raspberry-pi) (64 bit) and Raspbian Buster (32 bit).  
It explains how to build a cross-compilation toolchain, and an example "Hello World" C++ project configured using CMake.

It has cross-compiled versions of many useful libraries and tools:

 - **Zlib**: compression library (OpenSSL and Python dependency)
 - **OpenSSL**: cryptography library (Python dependency)
 - **FFI**: foreign function interface (Python dependency, used to call C functions using ctypes)
 - **Bzip2**: compression library (Python dependency)
 - **GNU ncurses**: library for text-based user interfaces (Python dependency, used for the console)
 - **GNU readline**: library for line-editing and history (Python dependency, used for the console)
 - **GNU dbm**: library for key-value data (Python dependency)
 - **SQLite**: library for embedded databases (Python dependency)
 - **UUID**: library for unique identifiers (Python dependency)
 - **Python 3.8.1**: Python interpreter and libraries
 - **ZBar**: Bar and QR code decoding library
 - **Raspberry Pi Userland**: VideoCore GPU drivers
 - **VPX**: VP8/VP9 codec SDK
 - **x264**: H.264/MPEG-4 AVC encoder
 - **Xvid**: MPEG-4 video codec
 - **FFmpeg**: library to record, convert and stream audio and video
 - **OpenBLAS**: linear algebra library (NumPy dependency)
 - **NumPy**: multi-dimensional array container for Python (OpenCV dependency)
 - **SciPy**: Python module for mathematics, science, and engineering
 - **OpenCV 4.2.0**: computer vision library and Python module
 - **GDB Server**: on-target remote debugger
 - **GCC 9.2.0**: C, C++ and Fortran compilers
 - **GNU Make**: build automation tool
 - **CMake**: build system
 - **Distcc**: distributed compiler wrapper (uses your computer to speed up compilation on the RPi)
 - **CCache**: compiler cache
 - **cURL**: tool and library for transferring data over the network (Git dependency)
 - **Git**: version control system
 
## Documentation
 
The documentation is still a work in progress, but parts of it are already available here:  
[**Documentation**](https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development/index.html)

## Pulling the Toolchain and Libraries from Docker Hub

If you don't want to build everything from scratch (it takes quite a while to compile everything),
you can download the pre-built version from [**Docker Hub**](https://hub.docker.com/r/tttapa/rpi3-aarch64-installed)
using the `pull-and-export-toolchain.sh` script in the [`toolchain` folder](toolchain).

## Building everything yourself

To build everything yourself, you can just run the `build-and-export-toolchain.sh` script in the [`toolchain` folder](toolchain).

The following is just an overview of the different steps that are executed by that script.

### Building the Toolchain

Crosstool-NG is used to build a modern GCC toolchain that runs on your computer and generates binaries for the Raspberry Pi.
This is much faster than compiling everything on the Pi itself.

The toolchains are built inside of a Docker container for clean and reproducable builds. 
It also makes it relatively easy to start a build from scratch if you have to.

You can find more information about the Docker containers in the [`toolchain/docker` folder](toolchain/docker).

### Cross-Compiling the Necessary Libraries

The toolchain is then used to compile all libraries for the Raspberry Pi.  
These libraries are installed in two locations:
1. in the "sysroot": this is a folder where all system files and libraries are installed that are required for the build process of other libraries
2. in the "staging area": this is the folder that will be copied to the SD card of the Raspberry Pi later. It contains the libraries that we built, but not the system files (because those are already part of the Ubuntu installation of the Pi).

Everything is installed in `/usr/local/`, so it shouldn't interfere with the software installed by your package manager.
`userland` is an exception, it's installed in `/opt/vc/`.

If you just want to know how to cross-compile a specific package, have a look at the scripts in the
[`toolchain/docker/aarch64/aarch64-cross-build/install-scripts`](toolchain/docker/aarch64/aarch64-cross-build/install-scripts) folder.  

### Exporting the Toolchain, Sysroot and Staging Area

Once all components have been built, they have to be extracted from the Docker build containers, and installed to the correct locations.  

To test the newly cross-compiled binaries, just copy the contents of the `RPi3-staging-aarchxx.tar` archive to the root folder of the Raspberry Pi.

## Building the Example Project

You have to tell CMake to use the new toolchain with the correct "sysroot" directory. This is done through the CMake Toolchain files in the `cmake` directory.

I highly recommend using the [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) extension in Visual Studio Code. 
The cross-compilation toolchain kits are defined in `.vscode/cmake-kits.json`. To select one, hit `CTRL+Shift+P` and type `CMake: Select a Kit` and then select the right `Raspberry Pi 3` kit for your architecture.
It'll configure the CMake project for you, and then you can build everything by clicking the "Build" button in the blue toolbar at the bottom of the window.

You can of course also configure and build the project manually, without VSCode:

```sh
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/RPi3-Toolchain-AArch64.cmake -DCMAKE_BUILD_TYPE=Debug ..
make -j`nproc`
```

The binaries will be in the `build/bin` folder, and you can copy them to the Raspberry Pi over SSH using `scp` for example.

### Debugging

During development, it's best to compile everything for your computer first (using a normal compiler you have installed on your system instead of the toolchain we built earlier).
This makes it very easy to debug your code because you can run the code locally.

The CMake Tools extension makes debugging very easy, just click the bug icon in the blue toolbar at the bottom of the window and select the target to debug.

A useful feature of this repository is that it allows you to debug on-target: the GUI for the debugger runs on your computer, but the actual code runs on the Raspberry Pi. This uses SSH and the GDB server.

Check out the `.vscode/launch.json` and `.vscode/tasks.json` files to see how it works: first, the active target binary is copied to the Raspberry Pi over SSH, next, the GDB server is started on the RPi, and finally, the GDB client is started locally.

This requires the right SSH and hostname setup, both on your computer and on the RPi. Instructions can be found here: <https://tttapa.github.io/Pages/Raspberry-Pi/Installation+Setup/index.html>  
Make sure mDNS is setup correctly, so that GDB can find the RPi at the address `rpi3.local`, and that you have a `.ssh/config` file with a config for the Raspberry Pi, called `RPi3`.

You also need a cross-platform version of the GDB client on your computer. This can be installed using the `scripts/install-cross-gdb.sh` script.
