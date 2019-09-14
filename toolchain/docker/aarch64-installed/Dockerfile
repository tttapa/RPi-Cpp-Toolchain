FROM base-ubuntu:v1 as python

COPY --from=aarch64-toolchain:v1 \
    /home/develop/x-tools/aarch64-rpi3-linux-gnu \
    /home/develop/x-tools/aarch64-rpi3-linux-gnu
 
ENV TOOLCHAIN_PATH=/home/develop/x-tools/aarch64-rpi3-linux-gnu
ENV PATH=${PATH}:${TOOLCHAIN_PATH}/bin

# Create a sysroot and staging area for the RPi
WORKDIR /home/develop
ENV RPI3_SYSROOT=/home/develop/RPi3-sysroot
ENV RPI3_STAGING=/home/develop/RPi3-staging
RUN mkdir RPi3-sysroot && \
    cp -rp $TOOLCHAIN_PATH/aarch64-rpi3-linux-gnu/sysroot/* ~/RPi3-sysroot/ && \
    chmod -R u+w /home/develop/RPi3-sysroot
 
# Use the pkg-config folder inside of the root filesystem
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot
 
# Zlib Download
WORKDIR /home/develop
RUN wget https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz && \
    tar xzf zlib-1.2.11.tar.gz && rm zlib-1.2.11.tar.gz
 
# Zlib build
ENV PKG_CONFIG_LIBDIR="" \
    PKG_CONFIG_PATH="" \
    PKG_CONFIG_SYSROOT_DIR=""
 
RUN mkdir zlib-1.2.11/build
WORKDIR /home/develop/zlib-1.2.11/build
RUN ../configure && \
    make -j$(($(nproc) * 2))
USER root
RUN make install
USER develop
RUN cd && rm -rf zlib-1.2.11/build
 
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
 
# Download OpenSSL
WORKDIR /home/develop
RUN wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1c.tar.gz && \
    tar xzf OpenSSL_1_1_1c.tar.gz
 
# OpenSSL build
ENV PKG_CONFIG_LIBDIR="" \
    PKG_CONFIG_PATH="" \
    PKG_CONFIG_SYSROOT_DIR=""
 
WORKDIR /home/develop/openssl-OpenSSL_1_1_1c
RUN ./config --prefix="/usr/local" && \
    make -j$(($(nproc) * 2))
USER root
RUN make install_sw && \
    make distclean && \
    cd && rm -rf openssl-OpenSSL_1_1_1c
USER develop
 
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
 
# FFI build
ENV PKG_CONFIG_LIBDIR="" \
    PKG_CONFIG_PATH="" \
    PKG_CONFIG_SYSROOT_DIR=""
 
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
RUN wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz && \
    tar xzf Python-3.7.4.tgz && rm Python-3.7.4.tgz
 
# Python build
ENV PKG_CONFIG_LIBDIR="" \
    PKG_CONFIG_PATH="" \
    PKG_CONFIG_SYSROOT_DIR=""
 
WORKDIR /home/develop/Python-3.7.4
RUN mkdir build
WORKDIR /home/develop/Python-3.7.4/build
USER root
RUN ln -s /usr/local/lib/libffi-3.2.1/include/* /usr/local/include
USER develop
RUN ../configure && \
    make -j$(($(nproc) * 2))
USER root
RUN make install
USER develop
RUN cd && rm -rf Python-3.7.4/build
 
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot
 
# Bzip2 Download
WORKDIR /home/develop
RUN git clone --branch bzip2-1.0.8 --depth 1 git://sourceware.org/git/bzip2.git
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
 
# GNU NCurses
WORKDIR /home/develop
RUN wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz
RUN tar xzf ncurses-6.1.tar.gz && rm ncurses-6.1.tar.gz
 
ENV PKG_CONFIG_LIBDIR="" \
    PKG_CONFIG_PATH="" \
    PKG_CONFIG_SYSROOT_DIR=""
 
RUN mkdir ncurses-6.1/build
WORKDIR /home/develop/ncurses-6.1/build
RUN ../configure \
        --without-shared --without-debug && \
    make -j$(($(nproc) * 2)) -C include && \
    make -j$(($(nproc) * 2)) -C progs tic && \
    chmod u+w ${TOOLCHAIN_PATH}/bin/ && \
    install -v -m755 progs/tic ${TOOLCHAIN_PATH}/bin/
 
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot
 
WORKDIR /home/develop
RUN mkdir ncurses-6.1/build-arm
WORKDIR /home/develop/ncurses-6.1/build-arm
RUN ../configure \
        --enable-termcap \
        --enable-getcap \
        --without-normal \
        --enable-pc-files \
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
    make install DESTDIR=${RPI3_SYSROOT} INSTALL="install --strip-program=aarch64-rpi3-linux-gnu-strip" && \
    make install DESTDIR=${RPI3_STAGING} INSTALL="install --strip-program=aarch64-rpi3-linux-gnu-strip"
 
# GNU Readline
WORKDIR /home/develop
RUN wget https://ftp.gnu.org/gnu/readline/readline-8.0.tar.gz && \
    tar xzf readline-8.0.tar.gz && rm readline-8.0.tar.gz && \
    mkdir readline-8.0/build-arm
WORKDIR /home/develop/readline-8.0/build-arm
# --with-curses
RUN ../configure \
        --enable-shared \
        --prefix="/usr/local" \
        --host="aarch64-rpi3-linux-gnu" \
        CFLAGS="--sysroot=${RPI3_SYSROOT}" \
        CC="aarch64-rpi3-linux-gnu-gcc" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR=${RPI3_SYSROOT} && \
    make install DESTDIR=${RPI3_STAGING}
 
# GNU DBM
WORKDIR /home/develop
RUN wget ftp://ftp.gnu.org/gnu/gdbm/gdbm-1.18.1.tar.gz && \
    tar xzf gdbm-1.18.1.tar.gz && rm gdbm-1.18.1.tar.gz && \
    mkdir gdbm-1.18.1/build-arm
WORKDIR /home/develop/gdbm-1.18.1/build-arm
RUN ../configure \
        --prefix="/usr/local" \
        --host="aarch64-rpi3-linux-gnu" \
        CFLAGS="--sysroot=${RPI3_SYSROOT} -I${RPI3_SYSROOT}/usr/local/include -L${RPI3_SYSROOT}/usr/local/lib" \
        LDFLAGS="-I${RPI3_SYSROOT}/usr/local/include -L${RPI3_SYSROOT}/usr/local/lib" \
        CC="aarch64-rpi3-linux-gnu-gcc" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR=${RPI3_SYSROOT} && \
    make install DESTDIR=${RPI3_STAGING}
 
# SQLite
WORKDIR /home/develop
RUN wget https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz && \
    tar xzf sqlite-autoconf-3290000.tar.gz && rm sqlite-autoconf-3290000.tar.gz && \
    mkdir sqlite-autoconf-3290000/build-arm
WORKDIR /home/develop/sqlite-autoconf-3290000/build-arm
RUN ../configure \
        --prefix="/usr/local" \
        --host="aarch64-rpi3-linux-gnu" \
        CFLAGS="--sysroot=${RPI3_SYSROOT}" \
        CC="aarch64-rpi3-linux-gnu-gcc" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR=${RPI3_SYSROOT} && \
    make install DESTDIR=${RPI3_STAGING}
 
# UUID
WORKDIR /home/develop
RUN wget https://downloads.sourceforge.net/project/libuuid/libuuid-1.0.3.tar.gz && \
    tar xzf libuuid-1.0.3.tar.gz && rm libuuid-1.0.3.tar.gz && \
    mkdir libuuid-1.0.3/build-arm
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
WORKDIR /home/develop/Python-3.7.4
RUN echo "ac_cv_file__dev_ptmx=yes\nac_cv_file__dev_ptc=no" > config.site && \
    mkdir build-arm
# COPY setup.py setup.py
WORKDIR /home/develop/Python-3.7.4/build-arm
 
RUN ln -s ${RPI3_SYSROOT}/usr/local/lib/libffi-3.2.1/include/* ${RPI3_SYSROOT}/usr/local/include/ && \
    CONFIG_SITE=../config.site \
    ../configure \
        --enable-ipv6 \
        --enable-shared --with-lto --enable-optimizations \
        --enable-loadable-sqlite-extensions --with-dbmliborder=bdb:gdbm \
        --with-ensurepip=install \
        --build="$(gcc -dumpmachine)" \
        --host="aarch64-rpi3-linux-gnu" \
        --prefix="/usr/local" \
        CFLAGS="--sysroot=${RPI3_SYSROOT} -I${RPI3_SYSROOT}/usr/local/include -L${RPI3_SYSROOT}/usr/local/lib -L${RPI3_SYSROOT}/usr/local/lib64" \
        CPPFLAGS="--sysroot=${RPI3_SYSROOT} -I${RPI3_SYSROOT}/usr/local/include -L${RPI3_SYSROOT}/usr/local/lib -L${RPI3_SYSROOT}/usr/local/lib64" \
        CXXFLAGS="--sysroot=${RPI3_SYSROOT} -I${RPI3_SYSROOT}/usr/local/include -L${RPI3_SYSROOT}/usr/local/lib -L${RPI3_SYSROOT}/usr/local/lib64" \
        LDFLAGS="--sysroot=${RPI3_SYSROOT} -I${RPI3_SYSROOT}/usr/local/include -L${RPI3_SYSROOT}/usr/local/lib -L${RPI3_SYSROOT}/usr/local/lib64" \
        CC="aarch64-rpi3-linux-gnu-gcc" \
        CXX="aarch64-rpi3-linux-gnu-g++" \
        LD="aarch64-rpi3-linux-gnu-ld" && \
    cat config.log && \
    make -j$(($(nproc) * 2)) && \
    make altinstall DESTDIR="${RPI3_SYSROOT}" && \
    make altinstall DESTDIR="${RPI3_STAGING}" && \
    cd && rm -rf Python-3.7.4/build-arm
WORKDIR /home/develop
USER root
RUN rm -rf Python-3.7.4
USER develop
 
FROM python as aarch64-installed
 
# zbar
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
        --prefix="/usr/local" \
        CFLAGS="-O2" \
        CC="aarch64-rpi3-linux-gnu-gcc --sysroot=${RPI3_SYSROOT}" \
        CXX="aarch64-rpi3-linux-gnu-g++ --sysroot=${RPI3_SYSROOT}" \
        LD="aarch64-rpi3-linux-gnu-ld --sysroot=${RPI3_SYSROOT}" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_SYSROOT}" && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd && rm -rf /home/develop/zbar-0.10
 
# Userland
WORKDIR /home/develop
RUN git clone --depth 1 https://github.com/raspberrypi/userland.git
COPY RPi3.toolchain.cmake RPi3.toolchain.cmake
RUN mkdir -p userland/build/arm-linux/release && cd userland/build/arm-linux/release && \
    cmake -DCMAKE_TOOLCHAIN_FILE=/home/develop/RPi3.toolchain.cmake -DCMAKE_BUILD_TYPE=Release ../../.. \
        -DCMAKE_SYSROOT=${RPI3_SYSROOT} && \
    make -j $(($(nproc) * 2)) && \
    make install DESTDIR=${RPI3_SYSROOT} && \
    make install DESTDIR=${RPI3_STAGING}
 
# Download & Build FFMPEG
WORKDIR /home/develop
RUN wget https://ffmpeg.org/releases/ffmpeg-4.2.tar.bz2 && \
    tar xjf ffmpeg-4.2.tar.bz2 && rm ffmpeg-4.2.tar.bz2
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
 
# Install Numpy
RUN python3.7 -m pip install --user numpy

# Download OpenCV
WORKDIR /home/develop
RUN wget -O opencv-4.1.1.tar.gz https://codeload.github.com/opencv/opencv/tar.gz/4.1.1 && \
    tar xzf opencv-4.1.1.tar.gz && rm opencv-4.1.1.tar.gz
 
# Build OpenCV ARM
RUN mkdir /home/develop/opencv-4.1.1/build-arm
WORKDIR /home/develop/opencv-4.1.1/build-arm
RUN cmake \
        -DCMAKE_TOOLCHAIN_FILE=../opencv-4.1.1/platforms/linux/arm.toolchain.cmake \
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
        -DPYTHON3_INCLUDE_PATH="${RPI3_SYSROOT}/usr/local/include/python3.7m" \
        -DPYTHON3_LIBRARIES="${RPI3_SYSROOT}/usr/local/lib/libpython3.7m.so" \
        -DPYTHON3_NUMPY_INCLUDE_DIRS=$(python3.7 -c "import numpy; print(numpy.get_include(),end='')") \
        .. && \
    cat CMakeFiles/CMakeOutput.log && \
    cat CMakeFiles/CMakeError.log && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_SYSROOT}" && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd && rm -rf /home/develop/opencv-4.1.1
 
# Use the pkg-config folder inside of the root filesystem
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot
 
# Why is the architecture wrong?
RUN mv ${RPI3_SYSROOT}/usr/local/lib/python3.7/site-packages/cv2/python-3.7/cv2.cpython-37m-x86_64-linux-gnu.so \
       ${RPI3_SYSROOT}/usr/local/lib/python3.7/site-packages/cv2/python-3.7/cv2.cpython-37m-aarch64-linux-gnu.so && \
    mv ${RPI3_STAGING}/usr/local/lib/python3.7/site-packages/cv2/python-3.7/cv2.cpython-37m-x86_64-linux-gnu.so \
       ${RPI3_STAGING}/usr/local/lib/python3.7/site-packages/cv2/python-3.7/cv2.cpython-37m-aarch64-linux-gnu.so
 
WORKDIR /home/develop
RUN python3.7 -m pip install --user crossenv && \
    python3.7 -m crossenv ${RPI3_SYSROOT}/usr/local/bin/python3.7 venv && \
    . venv/bin/activate && python3.7 -m pip -v install wheel && \
    export NPY_NUM_BUILD_JOBS=$(($(nproc) * 2)) && \
    . venv/bin/activate && python3.7 -m pip -v install numpy
# RUN . venv/bin/activate && python3.7 -m pip -v install scipy
 
RUN mv venv/cross/lib/python3.7/site-packages/wheel* ${RPI3_STAGING}/usr/local/lib/python3.7/site-packages && \
    mv venv/cross/lib/python3.7/site-packages/numpy* ${RPI3_STAGING}/usr/local/lib/python3.7/site-packages
 
WORKDIR /home/develop
RUN cp -ar $TOOLCHAIN_PATH/aarch64-rpi3-linux-gnu/debug-root/* ${RPI3_SYSROOT} && \
    cp -ar $TOOLCHAIN_PATH/aarch64-rpi3-linux-gnu/debug-root/* ${RPI3_STAGING} && \
    mkdir -p ${RPI3_STAGING}/usr/lib/aarch64-linux-gnu/ && \
    cp -a ${RPI3_SYSROOT}/lib/libstdc++.so.6.0.26 ${RPI3_STAGING}/usr/lib/aarch64-linux-gnu/libstdc++.so.6.0.26
RUN tar zcf x-tools.tar.gz x-tools & \
    tar zcf RPi3-sysroot.tar.gz RPi3-sysroot & \
    tar zcf RPi3-staging.tar.gz RPi3-staging & \
    wait