| **Note**: The toolchains themselves have been moved to a separate repository, [tttapa/docker-arm-cross-toolchain](https://github.com/tttapa/docker-arm-cross-toolchain) |
|:---:|

You can download and extract the toolchain in one go using `wget` and `tar`,
for example:
```sh
mkdir -p ~/opt
wget -qO- https://github.com/tttapa/docker-arm-cross-toolchain/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu.tar.bz2 | tar xJ -C ~/opt
```

---

[![Download from Docker Hub](https://img.shields.io/docker/pulls/tttapa/rpi-cross?label=Docker%20Hub&logo=docker)](https://hub.docker.com/r/tttapa/rpi-cross/tags)

# Raspberry Pi C++ Toolchain

This repository contains all you need to develop and cross-compile C++ applications for the Raspberry Pi (both 32 and 64 bit).
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
 - **libX11**: X11 protocol client library (Tk dependency)
 - **Tcl/Tk**: graphical user interface toolkit (Python/Tkinter dependency)
 - **Python 3.10.4**: Python interpreter and libraries
 - **ZBar**: Bar and QR code decoding library
 - **Raspberry Pi Userland**: VideoCore GPU drivers
 - **VPX**: VP8/VP9 codec SDK
 - **x264**: H.264/MPEG-4 AVC encoder
 - **Xvid**: MPEG-4 video codec
 - **FFmpeg**: library to record, convert and stream audio and video
 - **OpenBLAS**: linear algebra library (NumPy dependency)
 - **NumPy**: multi-dimensional array container for Python (OpenCV dependency)
 - **SciPy**: Python module for mathematics, science, and engineering
 - **OpenCV 4.5.5**: computer vision library and Python module
 - **GDB Server**: on-target remote debugger
 - **GNU Make**: build automation tool
 - **Ninja**: build system
 - **CMake**: build system
 - **Distcc**: distributed compiler wrapper (uses your computer to speed up compilation on the Pi)
 - **CCache**: compiler cache
 - **cURL**: tool and library for transferring data over the network (Git dependency)
 - **Git**: version control system
 <!-- - **GCC 11.1.0**: C, C++ and Fortran compilers -->
 
## Documentation
 
The documentation is still a work in progress, but parts of it are already available here:  
[**Documentation**](https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development/index.html)

***

## Pulling the libraries from Docker Hub

If you don't want to build everything from scratch (it takes quite a while to compile everything),
you can download the pre-built version from [**Docker Hub**](https://hub.docker.com/r/tttapa/)
using the `--pull` option of the `build.sh` script in the [`docker-arm-cross-build-scripts` folder](docker-arm-cross-build-scripts).

## Building everything yourself

To build everything yourself, you can just run the `build.sh` without the `--pull` option.

The following is just an overview of the different steps that are executed by that script.

### The cross-compilation toolchain

Crosstool-NG is used to build a modern GCC toolchain that runs on your computer and generates binaries for the Raspberry Pi.
This is much faster than compiling everything on the Pi itself.

The toolchain used to be built by the scripts in this repository, but have since been moved to their own repository,
[**tttapa/docker-arm-cross-toolchain**](https://github.com/tttapa/docker-arm-cross-toolchain).

You can download them directly from the [Releases page](https://github.com/tttapa/docker-arm-cross-toolchain/releases)

### Cross-compiling the necessary libraries

The toolchain is then used to compile all libraries for the Raspberry Pi.  
These libraries are installed in two locations:
1. in the **“sysroot”**: this is a folder where all system files and libraries are installed that are required for the build process of other libraries
2. in the **“staging area”**: this is the folder that will be copied to the SD card of the Raspberry Pi later. It contains the libraries that we built, but not the system files (because those are already part of the Ubuntu/Raspbian installation of the Pi).

Everything is installed in `/usr/local/`, so it shouldn't interfere with the software installed by your package manager.
[`userland`](https://github.com/raspberrypi/userland) is an exception, it's installed in `/opt/vc/`.

If you just want to know how to cross-compile a specific package, have a look at the scripts in the
[`docker-arm-cross-build-scripts/cross-build/install-scripts`](docker-arm-cross-build-scripts/cross-build/install-scripts) folder.  

### Exporting the toolchain, sysroot and staging area

Once all components have been built, they have to be extracted from the Docker build containers, and installed to the correct locations.  
You can extract everything using the `--extract` option of the `toolchain.sh` script. To extract only the toolchain,
without the cross-compiled libraries, you can use `--extract-toolchain` instead.

To test the newly cross-compiled binaries, just extract the contents of the right `staging-rpix-xxx-linux-gnuxxx.tar` archive to the root folder of the Raspberry Pi:

**Do NOT extract the staging area to the root directory of your computer, you will destroy your system!**
```sh
# Copy the staging area archive to the Pi
# This command may take a while, depending on the speed of your SD card
scp ./toolchain/staging-rpi3-aarch64.tar RPi3:/tmp
# Install everything to the root of the filesystem
# (will only install to /usr/local and /opt)
# Enter the sudo password of the Pi if necessary
# This command may take a while, depending on the speed of your SD card
ssh -t RPi3 "sudo tar xf /tmp/staging-rpi3-aarch64.tar -C / --strip-components=1"
# Configure dynamic linker run-time bindings so newly installed libraries
# are found by the linker
# Enter the sudo password of the Pi if necessary
ssh -t RPi3 "sudo ldconfig"
```

## Building the example project

You have to tell CMake to use the new toolchain with the correct "sysroot" directory. This is done through the CMake Toolchain files in the `cmake` directory.

I highly recommend using the [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) extension in Visual Studio Code. 
The cross-compilation toolchain kits are defined in `.vscode/cmake-kits.json`. To select one, hit `CTRL+Shift+P` and type `CMake: Select a Kit` and then select the right `Raspberry Pi` kit for your architecture.
It'll configure the CMake project for you, and then you can build everything by clicking the "Build" button in the blue toolbar at the bottom of the window.

You can of course also configure and build the project manually, without VSCode:

```sh
cmake -Bbuild -S. -DCMAKE_TOOLCHAIN_FILE=../cmake/aarch64-rpi3-linux-gnu.cmake -DCMAKE_BUILD_TYPE=Debug
cmake --build build -j
```

The binaries will be in the `build` folder, and you can copy them to the Raspberry Pi over SSH using `scp` for example.

### Debugging

During development, it's best to compile everything for your computer first (using a normal compiler you have installed on your system instead of the toolchain we built earlier).
This makes it very easy to debug your code because you can run the code locally.

The CMake Tools extension makes debugging very easy, just click the bug icon in the blue toolbar at the bottom of the window and select the target to debug.

A useful feature of this repository is that it allows you to debug on-target: the GUI for the debugger runs on your computer, but the actual code runs on the Raspberry Pi. This uses SSH and the GDB server.

Check out the `.vscode/launch.json` and `.vscode/tasks.json` files to see how it works: first, the active target binary is copied to the Raspberry Pi over SSH, the GDB server is started on the RPi, and the local GDB client connects to it.

This requires the right SSH and hostname setup, both on your computer and on the RPi. Instructions can be found here: <https://tttapa.github.io/Pages/Raspberry-Pi/Installation+Setup/index.html>  
Make sure mDNS is setup correctly, and that you have a `.ssh/config` file with a config for the Raspberry Pi, called `RPi`.

## Cross-compiling Python modules and C/C++ extensions

The [`extra/python/cross-compile-module`](extra/python/cross-compile-module) folder contains small guides explaining how to cross-compile Python and Cython modules for the Raspberry Pi.
