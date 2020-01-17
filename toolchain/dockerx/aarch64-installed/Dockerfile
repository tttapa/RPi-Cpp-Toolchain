FROM --platform=$BUILDPLATFORM base-ubuntu:v1 as python
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo $BUILDPLATFORM

# Copy the toolchain from the previous Docker image
COPY --from=aarch64-cross-toolchain \
    /home/develop/x-tools/aarch64-rpi3-linux-gnu \
    /home/develop/x-tools/aarch64-rpi3-linux-gnu
# Set the path to the toolchain executables
ENV TOOLCHAIN_PATH=/home/develop/x-tools/aarch64-rpi3-linux-gnu
ENV PATH=${PATH}:${TOOLCHAIN_PATH}/bin

# Create a sysroot and staging area for the RPi
WORKDIR /home/develop
ENV RPI3_SYSROOT=/home/develop/RPi3-sysroot
ENV RPI3_STAGING=/home/develop/RPi3-staging
RUN mkdir RPi3-sysroot && \
    cp -rp $TOOLCHAIN_PATH/aarch64-rpi3-linux-gnu/sysroot/* ~/RPi3-sysroot/ && \
    chmod -R u+w /home/develop/RPi3-sysroot

# Use the pkg-config folder inside of the RPi's root filesystem  
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot

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

# Use the pkg-config folder inside of the RPi's root filesystem 
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot
 
# Zlib ARM
WORKDIR /home/develop
RUN mkdir zlib-1.2.11/build-arm
WORKDIR /home/develop/zlib-1.2.11/build-arm
RUN CFLAGS="--sysroot=${RPI3_SYSROOT}" \
    LDFLAGS="--sysroot=${RPI3_SYSROOT}" \
    CC="aarch64-rpi3-linux-gnu-gcc" \
    LD="aarch64-rpi3-linux-gnu-ld" \
    ../configure \
        --prefix="/usr/local" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_SYSROOT}" && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd && rm -rf zlib-1.2.11
 
# OpenSSL Download
WORKDIR /home/develop
RUN wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1c.tar.gz && \
    tar xzf OpenSSL_1_1_1c.tar.gz

# Use the build system's pkg-config folders
ENV PKG_CONFIG_LIBDIR="" \
    PKG_CONFIG_PATH="" \
    PKG_CONFIG_SYSROOT_DIR=""
 
# OpenSSL build
WORKDIR /home/develop/openssl-OpenSSL_1_1_1c
RUN ./config --prefix="/usr/local" && \
    make -j$(($(nproc) * 2))
USER root
RUN make install_sw && \
    make distclean && \
    cd && rm -rf openssl-OpenSSL_1_1_1c
USER develop
 
# Use the pkg-config folder inside of the RPi's root filesystem 
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot
 
# OpenSSL ARM
WORKDIR /home/develop
RUN tar xzf OpenSSL_1_1_1c.tar.gz && rm OpenSSL_1_1_1c.tar.gz
WORKDIR /home/develop/openssl-OpenSSL_1_1_1c
RUN ./Configure \
        --prefix="/usr/local" \
        --cross-compile-prefix="aarch64-rpi3-linux-gnu-" \
        CFLAGS="--sysroot=${RPI3_SYSROOT}" \
        CPPFLAGS="--sysroot=${RPI3_SYSROOT}" \
        LDFLAGS="--sysroot=${RPI3_SYSROOT}" \
        linux-aarch64 && \
    make -j$(($(nproc) * 2)) && \
    make install_sw DESTDIR="${RPI3_SYSROOT}" && \
    make install_sw DESTDIR="${RPI3_STAGING}" && \
    cd && rm -rf openssl-OpenSSL_1_1_1c
 
# FFI Download
WORKDIR /home/develop
RUN wget -O libffi-3.2.1.tar.gz https://codeload.github.com/libffi/libffi/tar.gz/v3.2.1 && \
    tar xzf libffi-3.2.1.tar.gz && rm libffi-3.2.1.tar.gz

# Use the build system's pkg-config folders
ENV PKG_CONFIG_LIBDIR="" \
    PKG_CONFIG_PATH="" \
    PKG_CONFIG_SYSROOT_DIR=""

# FFI build
WORKDIR /home/develop/libffi-3.2.1
RUN ./autogen.sh && \
    mkdir build
WORKDIR /home/develop/libffi-3.2.1/build
RUN ../configure CFLAGS="-O2" CXXFLAGS="-O2" && \
    make -j$(($(nproc) * 2))
USER root
RUN make install
USER develop
RUN cd && rm -rf libffi-3.2.1/build

# Use the pkg-config folder inside of the RPi's root filesystem  
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot
 
# FFI ARM
WORKDIR /home/develop/libffi-3.2.1
RUN mkdir build-arm
WORKDIR /home/develop/libffi-3.2.1/build-arm
RUN ../configure \
        --host="aarch64-linux-gnu" \
        --prefix="/usr/local" \
        CFLAGS="-O2" CXXFLAGS="-O2" \
        --with-sysroot="${RPI3_SYSROOT}" \
        CC="aarch64-rpi3-linux-gnu-gcc" \
        CXX="aarch64-rpi3-linux-gnu-g++" \
        LD="aarch64-rpi3-linux-gnu-ld" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_SYSROOT}" && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd && rm -rf libffi-3.2.1
 
# Python Download
WORKDIR /home/develop
RUN wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz && \
    tar xzf Python-3.8.1.tgz && rm Python-3.8.1.tgz

# Use the build system's pkg-config folders
ENV PKG_CONFIG_LIBDIR="" \
    PKG_CONFIG_PATH="" \
    PKG_CONFIG_SYSROOT_DIR=""
 
# Python build
WORKDIR /home/develop/Python-3.8.1
RUN mkdir build
WORKDIR /home/develop/Python-3.8.1/build
USER root
RUN ln -s /usr/local/lib/libffi-3.2.1/include/* /usr/local/include
USER develop
RUN ../configure && \
    make -j$(($(nproc) * 2))
USER root
RUN make install
USER develop
RUN cd && rm -rf Python-3.8.1/build
 
# Use the pkg-config folder inside of the RPi's root filesystem 
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot
 
# Bzip2 Download
WORKDIR /home/develop
RUN git clone --branch bzip2-1.0.8 --depth 1 git://sourceware.org/git/bzip2.git

# Bzip2 ARM
WORKDIR /home/develop/bzip2
RUN make -f Makefile-libbz2_so -j $(($(nproc) * 2)) \
    CC="aarch64-rpi3-linux-gnu-gcc --sysroot=${RPI3_SYSROOT}" && \
    cp -a libbz2.so.1.0 $RPI3_SYSROOT/usr/local/lib && \
    cp -a libbz2.so.1.0.8 $RPI3_SYSROOT/usr/local/lib && \
    ln -s libbz2.so.1.0 ${RPI3_SYSROOT}/usr/local/lib/libbz2.so && \
    cp -a libbz2.so.1.0 $RPI3_STAGING/usr/local/lib && \
    cp -a libbz2.so.1.0.8 $RPI3_STAGING/usr/local/lib && \
    ln -s libbz2.so.1.0 ${RPI3_STAGING}/usr/local/lib/libbz2.so && \
    make bzip2 bzip2recover -j $(($(nproc) * 2)) \
    CC="aarch64-rpi3-linux-gnu-gcc --sysroot=${RPI3_SYSROOT}" && \
    make install PREFIX="${RPI3_SYSROOT}/usr/local" && \
    make install PREFIX="${RPI3_STAGING}/usr/local"
 
# GNU NCurses Download
WORKDIR /home/develop
RUN wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz
RUN tar xzf ncurses-6.1.tar.gz && rm ncurses-6.1.tar.gz
 
# Use the build system's pkg-config folders
ENV PKG_CONFIG_LIBDIR="" \
    PKG_CONFIG_PATH="" \
    PKG_CONFIG_SYSROOT_DIR=""

# GNU NCurses build
RUN mkdir ncurses-6.1/build
WORKDIR /home/develop/ncurses-6.1/build
RUN ../configure \
        --without-shared --without-debug && \
    make -j$(($(nproc) * 2)) -C include && \
    make -j$(($(nproc) * 2)) -C progs tic && \
    chmod u+w ${TOOLCHAIN_PATH}/bin/ && \
    install -v -m755 progs/tic ${TOOLCHAIN_PATH}/bin/

# Use the pkg-config folder inside of the RPi's root filesystem
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot
 
# GNU NCurses ARM
WORKDIR /home/develop
RUN mkdir ncurses-6.1/build-arm
WORKDIR /home/develop/ncurses-6.1/build-arm
RUN ../configure \
        --enable-termcap \
        --enable-getcap \
        --without-normal \
        --with-shared --without-debug \
        --without-ada --enable-overwrite \
        --prefix="/usr/local" \
        --datadir="/usr/local/share" \
        --with-build-cc="gcc" \
        --host="aarch64-rpi3-linux-gnu" \
        CFLAGS="--sysroot=${RPI3_SYSROOT}" \
        CC="aarch64-rpi3-linux-gnu-gcc" \
        STRIP="aarch64-rpi3-linux-gnu-strip" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR=${RPI3_SYSROOT} \
         INSTALL="install --strip-program=aarch64-rpi3-linux-gnu-strip" && \
    make install DESTDIR=${RPI3_STAGING} \
         INSTALL="install --strip-program=aarch64-rpi3-linux-gnu-strip"
 
# GNU Readline Download
WORKDIR /home/develop
RUN wget https://ftp.gnu.org/gnu/readline/readline-8.0.tar.gz && \
    tar xzf readline-8.0.tar.gz && rm readline-8.0.tar.gz && \
    mkdir readline-8.0/build-arm

# GNU Readline ARM
WORKDIR /home/develop/readline-8.0/build-arm
RUN ../configure \
        --with-curses \
        --enable-shared \
        --prefix="/usr/local" \
        --host="aarch64-rpi3-linux-gnu" \
        CFLAGS="--sysroot=${RPI3_SYSROOT}" \
        CC="aarch64-rpi3-linux-gnu-gcc" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR=${RPI3_SYSROOT} && \
    make install DESTDIR=${RPI3_STAGING}
 
# GNU DBM Download
WORKDIR /home/develop
RUN wget ftp://ftp.gnu.org/gnu/gdbm/gdbm-1.18.1.tar.gz && \
    tar xzf gdbm-1.18.1.tar.gz && rm gdbm-1.18.1.tar.gz && \
    mkdir gdbm-1.18.1/build-arm

# GNU DBM ARM
WORKDIR /home/develop/gdbm-1.18.1/build-arm
RUN ../configure \
        --prefix="/usr/local" \
        --host="aarch64-rpi3-linux-gnu" \
        CFLAGS="--sysroot=${RPI3_SYSROOT} \
                -I${RPI3_SYSROOT}/usr/local/include \
                -L${RPI3_SYSROOT}/usr/local/lib" \
        LDFLAGS="--sysroot=${RPI3_SYSROOT} \
                 -L${RPI3_SYSROOT}/usr/local/lib" \
        CC="aarch64-rpi3-linux-gnu-gcc" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR=${RPI3_SYSROOT} && \
    make install DESTDIR=${RPI3_STAGING}
 
# SQLite Download
WORKDIR /home/develop
RUN wget https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz && \
    tar xzf sqlite-autoconf-3290000.tar.gz && rm sqlite-autoconf-3290000.tar.gz && \
    mkdir sqlite-autoconf-3290000/build-arm

# SQLite ARM
WORKDIR /home/develop/sqlite-autoconf-3290000/build-arm
RUN ../configure \
        --prefix="/usr/local" \
        --host="aarch64-rpi3-linux-gnu" \
        CFLAGS="--sysroot=${RPI3_SYSROOT}" \
        CC="aarch64-rpi3-linux-gnu-gcc" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR=${RPI3_SYSROOT} && \
    make install DESTDIR=${RPI3_STAGING}
 
# UUID Download
WORKDIR /home/develop
RUN wget https://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz && \
    tar xzf libuuid-1.0.3.tar.gz && rm libuuid-1.0.3.tar.gz && \
    mkdir libuuid-1.0.3/build-arm

# UUID ARM
WORKDIR /home/develop/libuuid-1.0.3/build-arm
RUN ../configure \
        --prefix="/usr/local" \
        --host="aarch64-rpi3-linux-gnu" \
        CFLAGS="--sysroot=${RPI3_SYSROOT}" \
        CC="aarch64-rpi3-linux-gnu-gcc" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR=${RPI3_SYSROOT} && \
    make install DESTDIR=${RPI3_STAGING} && \
    ln -s uuid/uuid.h ${RPI3_SYSROOT}/usr/local/include/uuid.h
 
# Python ARM
WORKDIR /home/develop/Python-3.8.1
RUN echo "ac_cv_file__dev_ptmx=yes\nac_cv_file__dev_ptc=no" > config.site && \
    mkdir build-arm
WORKDIR /home/develop/Python-3.8.1/build-arm
 
RUN ln -s ${RPI3_SYSROOT}/usr/local/lib/libffi-3.2.1/include/* \
          ${RPI3_SYSROOT}/usr/local/include/ && \
    CONFIG_SITE=../config.site \
    ../configure \
        --enable-ipv6 \
        --enable-shared --with-lto --enable-optimizations \
        --enable-loadable-sqlite-extensions --with-dbmliborder=bdb:gdbm \
        --with-ensurepip=install \
        --build="$(gcc -dumpmachine)" \
        --host="aarch64-rpi3-linux-gnu" \
        --prefix="/usr/local" \
        CFLAGS="--sysroot=${RPI3_SYSROOT} \
                -I${RPI3_SYSROOT}/usr/local/include \
                -L${RPI3_SYSROOT}/usr/local/lib \
                -L${RPI3_SYSROOT}/usr/local/lib64" \
        CPPFLAGS="--sysroot=${RPI3_SYSROOT} \
                  -I${RPI3_SYSROOT}/usr/local/include \
                  -L${RPI3_SYSROOT}/usr/local/lib \
                  -L${RPI3_SYSROOT}/usr/local/lib64" \
        CXXFLAGS="--sysroot=${RPI3_SYSROOT} \
                  -I${RPI3_SYSROOT}/usr/local/include \
                  -L${RPI3_SYSROOT}/usr/local/lib \
                  -L${RPI3_SYSROOT}/usr/local/lib64" \
        LDFLAGS="--sysroot=${RPI3_SYSROOT} \
                 -I${RPI3_SYSROOT}/usr/local/include \
                 -L${RPI3_SYSROOT}/usr/local/lib \
                 -L${RPI3_SYSROOT}/usr/local/lib64" \
        CC="aarch64-rpi3-linux-gnu-gcc" \
        CXX="aarch64-rpi3-linux-gnu-g++" \
        LD="aarch64-rpi3-linux-gnu-ld" && \
    cat config.log && \
    make -j$(($(nproc) * 2)) && \
    make altinstall DESTDIR="${RPI3_SYSROOT}" && \
    make altinstall DESTDIR="${RPI3_STAGING}" && \
    cd && rm -rf Python-3.8.1/build-arm
WORKDIR /home/develop
USER root
RUN rm -rf Python-3.8.1
USER develop

# DistCC build
WORKDIR /home/develop
RUN git clone https://github.com/distcc/distcc.git --depth=1 --single-branch && \
    cd distcc && \
    ./autogen.sh && \
    ./configure \
        --host="aarch64-linux-gnu" \
        --prefix="/usr/local" \
        CFLAGS="-O2" \
        CXXFLAGS="-O2" \
        CC="aarch64-rpi3-linux-gnu-gcc --sysroot ${RPI3_SYSROOT} \
            -Wimplicit-fallthrough=0" \
        CXX="aarch64-rpi3-linux-gnu-g++ --sysroot ${RPI3_SYSROOT}" \
        LD="aarch64-rpi3-linux-gnu-ld --sysroot ${RPI3_SYSROOT}" && \
    make -j`nproc` && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd .. && rm -rf distcc
 
# ZBar Download
WORKDIR /home/develop
RUN wget http://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.bz2 && \
    tar xjf zbar-0.10.tar.bz2 && rm zbar-0.10.tar.bz2

# ZBar ARM
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
        --prefix="/usr/local" \
        CFLAGS="-O2" \
        CC="aarch64-rpi3-linux-gnu-gcc --sysroot=${RPI3_SYSROOT}" \
        CXX="aarch64-rpi3-linux-gnu-g++ --sysroot=${RPI3_SYSROOT}" \
        LD="aarch64-rpi3-linux-gnu-ld --sysroot=${RPI3_SYSROOT}" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_SYSROOT}" && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd && rm -rf /home/develop/zbar-0.10
 
# Raspberry Pi Userland (VideoCore) Download
WORKDIR /home/develop
RUN git clone --depth 1 https://github.com/raspberrypi/userland.git
COPY RPi3.toolchain.cmake RPi3.toolchain.cmake

# Raspberry Pi Userland ARM
RUN mkdir -p userland/build/arm-linux/release && \
    cd userland/build/arm-linux/release && \
    cmake -DCMAKE_TOOLCHAIN_FILE=/home/develop/RPi3.toolchain.cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_SYSROOT=${RPI3_SYSROOT} \
        ../../.. && \
    make -j $(($(nproc) * 2)) && \
    make install DESTDIR=${RPI3_SYSROOT} && \
    make install DESTDIR=${RPI3_STAGING}
 
# FFmpeg Download
WORKDIR /home/develop
RUN wget https://ffmpeg.org/releases/ffmpeg-4.2.tar.bz2 && \
    tar xjf ffmpeg-4.2.tar.bz2 && rm ffmpeg-4.2.tar.bz2

# FFmpeg ARM
RUN mkdir ffmpeg-4.2/build-arm
WORKDIR /home/develop/ffmpeg-4.2/build-arm
RUN ../configure \
        --arch="aarch64" \
        --target-os="linux" \
        --prefix="/usr/local" \
        --sysroot="${RPI3_SYSROOT}" \
        --enable-cross-compile \
        --cross-prefix="aarch64-rpi3-linux-gnu-" \
        --enable-gpl \
        --enable-avresample \
        --enable-omx \
        --enable-omx-rpi \
        --enable-shared \
        --disable-static \
        --disable-doc \
        --extra-cflags="-I${RPI3_SYSROOT}/opt/vc/include/IL" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_SYSROOT}" && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd && rm -rf ffmpeg-4.2
 
# Install NumPy on build
RUN python3.8 -m pip install --user numpy

# OpenCV Download
WORKDIR /home/develop
RUN wget -O opencv-4.2.0.tar.gz https://codeload.github.com/opencv/opencv/tar.gz/4.2.0 && \
    tar xzf opencv-4.2.0.tar.gz && rm opencv-4.2.0.tar.gz

# OpenCV ARM
RUN mkdir /home/develop/opencv-4.2.0/build-arm
WORKDIR /home/develop/opencv-4.2.0/build-arm
RUN cmake \
        -DCMAKE_TOOLCHAIN_FILE=../platforms/linux/arm.toolchain.cmake \
        -DGNU_MACHINE="aarch64-rpi3-linux-gnu" \
        -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
        -DCMAKE_SYSROOT="${RPI3_SYSROOT}" \
        -DWITH_JPEG=ON -DBUILD_JPEG=ON \
        -DWITH_PNG=ON -DBUILD_PNG=ON \
        -DWITH_TBB=ON -DBUILD_TBB=ON \
        -DWITH_FFMPEG=ON \
        -DWITH_V4L=ON -DWITH_LIBV4L=ON \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_INSTALL_PREFIX="/usr/local" \
        -DOPENCV_GENERATE_PKGCONFIG=ON \
        -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF \
        -DPYTHON3_INCLUDE_PATH="${RPI3_SYSROOT}/usr/local/include/python3.8" \
        -DPYTHON3_LIBRARIES="${RPI3_SYSROOT}/usr/local/lib/libpython3.8.so" \
        -DPYTHON3_NUMPY_INCLUDE_DIRS=$( \
            python3.8 -c "import numpy; print(numpy.get_include(),end='')") \
        .. && \
    cat CMakeFiles/CMakeOutput.log && \
    cat CMakeFiles/CMakeError.log && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_SYSROOT}" && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd && rm -rf /home/develop/opencv-4.2.0
 
# Why is the architecture wrong?
RUN mv ${RPI3_SYSROOT}/usr/local/lib/python3.8/site-packages/cv2/python-3.8/cv2.cpython-38-x86_64-linux-gnu.so \
       ${RPI3_SYSROOT}/usr/local/lib/python3.8/site-packages/cv2/python-3.8/cv2.cpython-38-aarch64-linux-gnu.so && \
    mv ${RPI3_STAGING}/usr/local/lib/python3.8/site-packages/cv2/python-3.8/cv2.cpython-38-x86_64-linux-gnu.so \
       ${RPI3_STAGING}/usr/local/lib/python3.8/site-packages/cv2/python-3.8/cv2.cpython-38-aarch64-linux-gnu.so

# Crossenv, Wheel ARM and NumPy ARM
WORKDIR /home/develop
RUN python3.8 -m pip install --user crossenv && \
    python3.8 -m crossenv ${RPI3_SYSROOT}/usr/local/bin/python3.8 venv && \
    . venv/bin/activate && python3.8 -m pip -v install wheel && \
    export NPY_NUM_BUILD_JOBS=$(($(nproc) * 2)) && \
    . venv/bin/activate && python3.8 -m pip -v install numpy

# SciPy doesn't want to cross-compile
# RUN . venv/bin/activate && python3.8 -m pip -v install scipy

# Move the compiled Wheel and NumPy packages to the staging area
RUN mv venv/cross/lib/python3.8/site-packages/wheel* ${RPI3_STAGING}/usr/local/lib/python3.8/site-packages && \
    mv venv/cross/lib/python3.8/site-packages/numpy* ${RPI3_STAGING}/usr/local/lib/python3.8/site-packages

RUN mkdir -p ${RPI3_STAGING}/usr/lib/aarch64-linux-gnu/ && \
    cp -a ${RPI3_SYSROOT}/lib/libstdc++.so.*.*.* ${RPI3_STAGING}/usr/lib/aarch64-linux-gnu/
# Copy gdbserver to the sysroot and staging area, as well as the latest C++ 
# library, and store everything in tar.gz archives.
# WORKDIR /home/develop
# RUN cp -ar $TOOLCHAIN_PATH/aarch64-rpi3-linux-gnu/debug-root/* ${RPI3_SYSROOT} && \
#     cp -ar $TOOLCHAIN_PATH/aarch64-rpi3-linux-gnu/debug-root/* ${RPI3_STAGING} && \
#     chmod u+w ${RPI3_STAGING}/usr && \
#     mkdir -p ${RPI3_STAGING}/usr/lib/aarch64-linux-gnu/ && \
#     cp -a ${RPI3_SYSROOT}/lib/libstdc++.so.6.0.26 ${RPI3_STAGING}/usr/lib/aarch64-linux-gnu/libstdc++.so.6.0.26
# RUN tar zcf x-tools.tar.gz x-tools & \
#     tar zcf RPi3-sysroot.tar.gz RPi3-sysroot & \
#     tar zcf RPi3-staging.tar.gz RPi3-staging & \
#     wait

FROM arm64v8/ubuntu:latest as aarch64-installed
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN mv /usr/local/man /usr/local/man-tmp
COPY --from=python /home/develop/RPi3-staging /
RUN cp -ar /usr/local/man/* /usr/local/man-tmp && \
    ls /usr/local/man && \
    rm -rf /usr/local/man && \
    mv /usr/local/man-tmp /usr/local/man 
RUN ldconfig

ENTRYPOINT [ "bash" ]