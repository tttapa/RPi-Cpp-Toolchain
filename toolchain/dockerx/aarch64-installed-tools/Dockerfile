FROM aarch64-installed

# Use the pkg-config folder inside of the RPi's root filesystem 
ENV PKG_CONFIG_LIBDIR=/home/develop/RPi3-sysroot/usr/local/lib \
    PKG_CONFIG_PATH=/home/develop/RPi3-sysroot/usr/local/lib/pkgconfig \
    PKG_CONFIG_SYSROOT_DIR=/home/develop/RPi3-sysroot

# DistCC build
WORKDIR /home/develop
RUN git clone https://github.com/distcc/distcc.git --depth=1 --single-branch && \
    cd distcc && \
    python3.8 -m crossenv ${RPI3_SYSROOT}/usr/local/bin/python3.8 venv && \
    . venv/bin/activate && \
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
 
# CMake build
WORKDIR /home/develop
COPY RPi3.toolchain.cmake .
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2.tar.gz && \
    tar xzf cmake-3.16.2.tar.gz && rm cmake-3.16.2.tar.gz && \
    cd cmake-3.16.2 && \
    ./bootstrap --parallel=$(($(nproc) * 2)) -- \
        -DCMAKE_TOOLCHAIN_FILE=../RPi3.toolchain.cmake \
        -DCMAKE_BUILD_TYPE=Release && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd .. && rm -rf cmake-3.16.2

# Make build
WORKDIR /home/develop
COPY make-4.2.patch .
RUN wget https://ftpmirror.gnu.org/gnu/make/make-4.2.tar.gz && \
    tar xzf make-4.2.tar.gz && rm make-4.2.tar.gz && \
    cd make-4.2 && \
    git apply ../make-4.2.patch && \
    ./configure \
        --host="aarch64-rpi3-linux-gnu" \
        --prefix="/usr/local" \
        CFLAGS="--sysroot=${RPI3_SYSROOT} -O3" \
        CXXFLAGS="--sysroot=${RPI3_SYSROOT} -O3" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd .. && rm -rf make-4.2

# cURL build
WORKDIR /home/develop
RUN wget https://curl.haxx.se/download/curl-7.68.0.tar.gz && \
    tar xzf curl-7.68.0.tar.gz && rm curl-7.68.0.tar.gz && \
    cd curl-7.68.0 && \
	./configure \
        --host="aarch64-rpi3-linux-gnu" \
        --prefix="/usr/local" \
        --with-ssl \
        CFLAGS="--sysroot ${RPI3_SYSROOT} -O3 \
                -I${RPI3_SYSROOT}/usr/local/include" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd .. && rm -rf curl-7.68.0

# Git build
WORKDIR /home/develop
COPY git-2.25.0.patch .
RUN wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.25.0.tar.gz && \
    tar xzf git-2.25.0.tar.gz && rm git-2.25.0.tar.gz && \
    cd git-2.25.0 && \
    make configure && \
    git apply ../git-2.25.0.patch && \
	./configure \
        --with-curl \
        --with-openssl \
        --host="aarch64-rpi3-linux-gnu" \
        --prefix="/usr/local" \
        CFLAGS="--sysroot ${RPI3_SYSROOT} -O3 \
                -I${RPI3_SYSROOT}/usr/local/include" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd .. && rm -rf git-2.25.0

# Patch DistCC Python path
WORKDIR ${RPI3_STAGING}/usr/local/bin
COPY pump.patch .
RUN git apply pump.patch && rm pump.patch
# Patch DistCC Python 3.8 compatibility
WORKDIR ${RPI3_STAGING}/usr/local/lib/python3.8/site-packages
COPY include_server.patch .
RUN git apply include_server.patch && rm include_server.patch