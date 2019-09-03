# Ubuntu 18.04 at the time of writing (2019-04-19)
FROM ubuntu:latest as ct-ng

# Install some tools and compilers + clean up
RUN apt-get update && \
    apt-get install -y sudo git wget \
                       gcc g++ cmake make autoconf automake \
                       gperf diffutils bzip2 xz-utils \
                       flex gawk help2man libncurses-dev patch bison \
                       python-dev gnupg2 texinfo unzip libtool-bin \
                       autogen libtool m4 gettext pkg-config && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Add a user called `develop`
RUN useradd -m develop && echo "develop:develop" | chpasswd && adduser develop sudo

USER develop
WORKDIR /home/develop

ENV CROSSTOOL_NG_VERSION=1.24.0
RUN git clone https://github.com/crosstool-ng/crosstool-ng.git
WORKDIR /home/develop/crosstool-ng
RUN git checkout crosstool-ng-${CROSSTOOL_NG_VERSION}
RUN ./bootstrap
RUN ./configure --prefix=/home/develop/.local
RUN make -j$(($(nproc) * 2))
RUN make install
ENV PATH=/home/develop/.local/bin:$PATH

RUN mkdir /home/develop/RPi3
WORKDIR /home/develop/RPi3
RUN ct-ng aarch64-rpi3-linux-gnu
RUN sed -i 's/CT_GCC_VERSION=\"[0-9.]*\"/CT_GCC_VERSION="9.1.0"/g' .config
RUN sed -i 's/CT_LINUX_VERSION=\"[0-9.]*\"/CT_LINUX_VERSION="4.15"/g' .config
RUN sed -i 's/CT_GLIBC_VERSION=\"[0-9.]*\"/CT_GLIBC_VERSION="2.27"/g' .config
RUN ct-ng build && rm -rf .build

ENV TOOLCHAIN_PATH=/home/develop/x-tools/aarch64-rpi3-linux-gnu
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop

################################################################################

FROM ct-ng as build

# Create a sysroot for the RPi
WORKDIR /home/develop
RUN mkdir RPi3-sysroot
ENV RPI3_SYSROOT=/home/develop/RPi3-sysroot
# ENV RPI3_SYSROOT=/home/develop/RPi3-staging
# RUN cp -r $TOOLCHAIN_PATH/aarch64-rpi3-linux-gnu/sysroot/* ~/RPi3-sysroot/
# RUN chmod -R u+w /home/develop/RPi3-sysroot
# RUN mkdir -p ${RPI3_SYSROOT}/usr/include
RUN mkdir -p ${RPI3_SYSROOT}/usr/lib
RUN ln -s lib ${RPI3_SYSROOT}/usr/lib64
# RUN mkdir -p ${RPI3_SYSROOT}/lib
# Use the pkg-config folder inside of the root filesystem
ENV PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/lib/pkgconfig
ENV STAGING_LD_FLAGS="-L${RPI3_SYSROOT}/lib -L${RPI3_SYSROOT}/usr/lib \
-Wl,-rpath-link,${RPI3_SYSROOT}/lib,-rpath-link,${RPI3_SYSROOT}/usr/lib"
ENV STAGING_INCLUDE_FLAGS="-I${RPI3_SYSROOT}/usr/include"
# ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/lib # TODO

RUN touch empty.c
RUN aarch64-rpi3-linux-gnu-gcc ${STAGING_LD_FLAGS} ${STAGING_INCLUDE_FLAGS} -c empty.c


# Download & Build FFMPEG
WORKDIR /home/develop
RUN wget https://ffmpeg.org/releases/ffmpeg-4.2.tar.bz2 && \
    tar xjf ffmpeg-4.2.tar.bz2 && rm ffmpeg-4.2.tar.bz2
RUN mkdir ffmpeg-4.2/build-arm
WORKDIR /home/develop/ffmpeg-4.2/build-arm
RUN ../configure \
        --arch="aarch64" \
        --target-os="linux" \
        --prefix="$RPI3_SYSROOT/usr" \
        --enable-cross-compile \
        --cross-prefix="aarch64-rpi3-linux-gnu-" \
        --enable-gpl \
        --enable-avresample \
        --enable-shared \
        --disable-doc && \
    make -j$(($(nproc) * 2)) && \
    make install && \
    cd && rm -rf ffmpeg-4.2

# Install zbar
WORKDIR /home/develop
RUN wget http://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.bz2 && \
    tar xjf zbar-0.10.tar.bz2 && rm zbar-0.10.tar.bz2

WORKDIR /home/develop
RUN mkdir zbar-0.10/build-arm
WORKDIR /home/develop/zbar-0.10
# New autoconf gives an error
RUN sed -i 's/-Werror //g' configure.ac
# Original autoconf doesn't know aarch64, so run again with newer autoconf
RUN autoreconf --install --force
WORKDIR /home/develop/zbar-0.10/build-arm

RUN ../configure \
        --disable-video --without-imagemagick --without-gtk --without-python \
        --without-qt --without-jpeg \
        --host="aarch64-linux-gnu" \
        --prefix="$RPI3_SYSROOT/usr" \
        CFLAGS="-O2" \
        CC="aarch64-rpi3-linux-gnu-gcc" \
        CXX="aarch64-rpi3-linux-gnu-g++" \
        LD="aarch64-rpi3-linux-gnu-ld" && \
    make -j$(($(nproc) * 2)) && \
    make install && \
    cd && rm -rf /home/develop/zbar-0.10

# FFI Download
WORKDIR /home/develop
RUN wget -O libffi-3.2.1.tar.gz https://codeload.github.com/libffi/libffi/tar.gz/v3.2.1 && \
    tar xzf libffi-3.2.1.tar.gz && rm libffi-3.2.1.tar.gz

# FFI build
WORKDIR /home/develop/libffi-3.2.1
RUN ./autogen.sh
RUN mkdir build
WORKDIR /home/develop/libffi-3.2.1/build
RUN ../configure CFLAGS="-O2" CXXFLAGS="-O2" && \
    make -j$(($(nproc) * 2))
USER root
RUN make install
USER develop
RUN cd && rm -rf libffi-3.2.1/build

# FFI ARM
WORKDIR /home/develop/libffi-3.2.1
RUN mkdir build-arm
WORKDIR /home/develop/libffi-3.2.1/build-arm
RUN ../configure \
        --host="aarch64-linux-gnu" \
        --prefix="$RPI3_SYSROOT/usr" \
        CFLAGS="-O2" CXXFLAGS="-O2" \
        CC="aarch64-rpi3-linux-gnu-gcc" \
        CXX="aarch64-rpi3-linux-gnu-g++" \
        LD="aarch64-rpi3-linux-gnu-ld" && \
    make -j$(($(nproc) * 2)) && \
    make install && \
    cd && rm -rf libffi-3.2.1

# Zlib Download
WORKDIR /home/develop
RUN wget https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz && \
    tar xzf zlib-1.2.11.tar.gz && rm zlib-1.2.11.tar.gz

# Zlib build
RUN mkdir zlib-1.2.11/build
WORKDIR /home/develop/zlib-1.2.11/build
RUN ../configure && \
    make -j$(($(nproc) * 2))
USER root
RUN make install
USER develop
RUN cd && rm -rf zlib-1.2.11/build

# Zlib ARM
WORKDIR /home/develop
RUN mkdir zlib-1.2.11/build-arm
WORKDIR /home/develop/zlib-1.2.11/build-arm
RUN CFLAGS="${STAGING_INCLUDE_FLAGS}" \
    LDFLAGS="${STAGING_LD_FLAGS}" \
    CC="aarch64-rpi3-linux-gnu-gcc" \
    LD="aarch64-rpi3-linux-gnu-ld" \
    ../configure \
        --prefix="$RPI3_SYSROOT/usr" && \
    make -j$(($(nproc) * 2)) && \
    make install && \
    cd && rm -rf zlib-1.2.11

# Download OpenSSL
WORKDIR /home/develop
RUN wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1c.tar.gz
RUN tar xzf OpenSSL_1_1_1c.tar.gz

# OpenSSL build
WORKDIR /home/develop/openssl-OpenSSL_1_1_1c
RUN ./config && \
    make -j$(($(nproc) * 2))
USER root
RUN make install && \
    make distclean && \
    cd && rm -rf openssl-OpenSSL_1_1_1c
USER develop

# OpenSSL ARM
WORKDIR /home/develop
RUN tar xzf OpenSSL_1_1_1c.tar.gz && rm OpenSSL_1_1_1c.tar.gz
WORKDIR /home/develop/openssl-OpenSSL_1_1_1c
RUN ./Configure linux-aarch64 \
        --prefix="$RPI3_SYSROOT/usr" \
        --cross-compile-prefix="aarch64-rpi3-linux-gnu-" && \
    make -j$(($(nproc) * 2)) && \
    make install && \
    cd && rm -rf openssl-OpenSSL_1_1_1c

# Python Download
WORKDIR /home/develop
RUN wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz && \
    tar xzf Python-3.7.4.tgz && rm Python-3.7.4.tgz

# Python build
ENV PKG_CONFIG_PATH=
RUN mkdir Python-3.7.4/build
WORKDIR /home/develop/Python-3.7.4/build
RUN ../configure && \
    make -j$(($(nproc) * 2))
USER root
RUN make install
USER develop
RUN cd && rm -rf Python-3.7.4/build
ENV PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/lib/pkgconfig

# # Bzip2 Download
# WORKDIR /home/develop
# RUN wget https://downloads.sourceforge.net/project/bzip2/bzip2-1.0.6.tar.gz && \
#     tar xzf bzip2-1.0.6.tar.gz && rm bzip2-1.0.6.tar.gz
# WORKDIR /home/develop/bzip2-1.0.6
# # LD="aarch64-rpi3-linux-gnu-ld --sysroot=$RPI3_SYSROOT" \
# RUN CC="aarch64-rpi3-linux-gnu-gcc --sysroot=$RPI3_SYSROOT" \
#     make -f Makefile-libbz2_so -j $(($(nproc) * 2))
# RUN cp libbz2.so.1.0 $RPI3_SYSROOT/usr/lib
# RUN cp libbz2.so.1.0.6 $RPI3_SYSROOT/usr/lib
# RUN CC="aarch64-rpi3-linux-gnu-gcc --sysroot=$RPI3_SYSROOT" \
#     make -j $(($(nproc) * 2))
# RUN make -n install PREFIX="$RPI3_SYSROOT/usr"
# RUN echo "prefix=$RPI3_SYSROOT/usr\n\
# exec_prefix=\${prefix}/bin\n\
# libdir=\${prefix}/lib\n\
# sharedlibdir=\${prefix}/lib\n\
# includedir=\${prefix}/include\n\
# \n\
# Name: libbz2\n\
# Description: BZip2 compression library\n\
# Version: 1.0.6\n\
# \n\
# Requires:\n\
# Libs: -L\${prefix}/lib -lbz2\n\
# Cflags: -I\${prefix}/include\n\
# " > "$RPI3_SYSROOT/usr/lib/pkgconfig/bz2.pc"
# # TODO: why doesn't Python recognize it?

# Python ARM
WORKDIR /home/develop/Python-3.7.4
# COPY setup.py setup.py
RUN echo "ac_cv_file__dev_ptmx=no\nac_cv_file__dev_ptc=no" > config.site
RUN cat config.site
RUN mkdir build-arm
WORKDIR /home/develop/Python-3.7.4/build-arm
RUN CONFIG_SITE=../config.site ../configure \
        --enable-ipv6 \
        --enable-shared --with-lto --enable-optimizations \
        --with-ensurepip=install \
        --build="$(gcc -dumpmachine)" \
        --host="aarch64-rpi3-linux-gnu" \
        --prefix="$RPI3_SYSROOT/usr" \
        CC="aarch64-rpi3-linux-gnu-gcc" \
        CXX="aarch64-rpi3-linux-gnu-g++" \
        LD="aarch64-rpi3-linux-gnu-ld" \
        LDFLAGS="${STAGING_LD_FLAGS} --sysroot=${RPI3_SYSROOT}" \
        CFLAGS="${STAGING_INCLUDE_FLAGS} --sysroot=${RPI3_SYSROOT}" \
        CXXFLAGS="${STAGING_INCLUDE_FLAGS} --sysroot=${RPI3_SYSROOT}" && \
    cat config.log && \
    make -j$(($(nproc) * 2)) && \
    make install && \
    cd && rm -rf Python-3.7.4/build-arm 
WORKDIR /home/develop
USER root
RUN rm -rf Python-3.7.4
USER develop

# Install Numpy
# RUN wget -O numpy-1.16.5.tar.gz https://github.com/numpy/numpy/archive/v1.16.5.tar.gz && \
#     tar xzf numpy-1.16.5.tar.gz && rm numpy-1.16.5.tar.gz
# # RUN touch numpy-1.16.5/numpy/core/include/numpy/_numpyconfig.h
# WORKDIR /home/develop/numpy-1.16.5
# RUN python3 setup.py build -j $(($(nproc) * 2)) install --prefix $HOME/.local
RUN python3 -m pip install --user numpy

# Download OpenCV
WORKDIR /home/develop
RUN wget -O opencv-4.1.1.tar.gz https://codeload.github.com/opencv/opencv/tar.gz/4.1.1 && \
    tar xzf opencv-4.1.1.tar.gz && rm opencv-4.1.1.tar.gz

# Build OpenCV ARM
RUN mkdir /home/develop/opencv-4.1.1/build-arm
WORKDIR /home/develop/opencv-4.1.1/build-arm
RUN cmake \
        -DCMAKE_TOOLCHAIN_FILE=../opencv-4.1.1/platforms/linux/arm.toolchain.cmake \
        -DCMAKE_EXE_LINKER_FLAGS="${STAGING_LD_FLAGS}" \
        -DCMAKE_SHARED_LINKER_FLAGS="${STAGING_LD_FLAGS}" \
        -DCMAKE_C_FLAGS="${STAGING_INCLUDE_FLAGS}" \
        -DCMAKE_CXX_FLAGS="${STAGING_INCLUDE_FLAGS}" \
        -DGNU_MACHINE="aarch64-rpi3-linux-gnu" \
        -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
        -DWITH_V4L=ON -DWITH_LIBV4L=ON \
        -DWITH_JPEG=ON -DBUILD_JPEG=ON \
        -DWITH_PNG=ON -DBUILD_PNG=ON \
        -DWITH_TBB=ON -DBUILD_TBB=ON \
        -DWITH_FFMPEG=ON \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_INSTALL_PREFIX=$RPI3_SYSROOT/usr \
        -DOPENCV_GENERATE_PKGCONFIG=ON \
        -DPYTHON3_INCLUDE_PATH=$RPI3_SYSROOT/usr/include/python3.7m \
        -DPYTHON3_LIBRARIES=$RPI3_SYSROOT/usr/lib/libpython3.7m.so \
        -DPYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include(),end='')") \
        .. && \
    make -j$(($(nproc) * 2)) && \
    make install && \
    cd && rm -rf /home/develop/opencv-4.1.1 && rm -rf numpy


# # LibJPEG
# WORKDIR /home/develop
# RUN wget https://ijg.org/files/jpegsrc.v9c.tar.gz
# RUN tar xzf jpegsrc.v9c.tar.gz && rm jpegsrc.v9c.tar.gz
# RUN mkdir jpeg-9c/build-arm
# WORKDIR /home/develop/jpeg-9c/build-arm
# RUN ../configure \
#         --host="aarch64-linux-gnu" \
#         --prefix="$RPI3_SYSROOT/usr" \
#         CFLAGS="-O2" \
#         CC="aarch64-rpi3-linux-gnu-gcc --sysroot=$RPI3_SYSROOT" \
#         CXX="aarch64-rpi3-linux-gnu-g++ --sysroot=$RPI3_SYSROOT" \
#         LD="aarch64-rpi3-linux-gnu-ld --sysroot=$RPI3_SYSROOT"
# RUN make -j$(($(nproc) * 2))
# RUN make install
# 
# 
# # LibPNG
# WORKDIR /home/develop
# RUN wget https://netcologne.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz
# RUN tar xzf libpng-1.6.37.tar.gz && rm libpng-1.6.37.tar.gz
# 
# RUN mkdir libpng-1.6.37/build-arm
# WORKDIR /home/develop/libpng-1.6.37/build-arm
# RUN ../configure \
#         --host="aarch64-linux-gnu" \
#         --prefix="$RPI3_SYSROOT/usr" \
#         CFLAGS="-O2" \
#         CC="aarch64-rpi3-linux-gnu-gcc --sysroot=$RPI3_SYSROOT" \
#         CXX="aarch64-rpi3-linux-gnu-g++ --sysroot=$RPI3_SYSROOT" \
#         LD="aarch64-rpi3-linux-gnu-ld --sysroot=$RPI3_SYSROOT"
# RUN make -j$(($(nproc) * 2))
# RUN make install

# TBB
# WORKDIR /home/develop
# RUN wget -O tbb.tar.gz https://codeload.github.com/intel/tbb/tar.gz/2019_U8
# RUN tar xzf tbb.tar.gz && rm tbb.tar.gz
# 
# WORKDIR /home/develop/tbb-2019_U8
# RUN CFLAGS="-O2" \
#     CC="aarch64-rpi3-linux-gnu-gcc --sysroot=$RPI3_SYSROOT" \
#     CXX="aarch64-rpi3-linux-gnu-g++ --sysroot=$RPI3_SYSROOT" \
#     LD="aarch64-rpi3-linux-gnu-ld --sysroot=$RPI3_SYSROOT" \
#     make arch=aarch64

WORKDIR /home/develop
RUN cp -r $TOOLCHAIN_PATH/aarch64-rpi3-linux-gnu/debug-root/* ~/RPi3-sysroot/
RUN tar cf x-tools.tar x-tools
RUN tar cf RPi3-sysroot.tar RPi3-sysroot
ENV PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/lib/pkgconfig
RUN pkg-config --libs zlib