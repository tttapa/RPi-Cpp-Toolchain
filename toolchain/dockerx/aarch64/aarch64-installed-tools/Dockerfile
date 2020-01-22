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
        --host="aarch64-rpi3-linux-gnu" \
        --prefix="/usr/local" \
        CFLAGS="-O3 -Wimplicit-fallthrough=0 --sysroot ${RPI3_SYSROOT}" \
        CXXFLAGS="-O3 -Wimplicit-fallthrough=0 --sysroot ${RPI3_SYSROOT}" && \
    make -j$(($(nproc) * 2)) && \
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
# COPY make-4.2.patch .
#    git apply ../make-4.2.patch && \
RUN wget https://ftpmirror.gnu.org/gnu/make/make-4.3.tar.gz && \
    tar xzf make-4.3.tar.gz && rm make-4.3.tar.gz && \
    cd make-4.3 && \
    ./configure \
        --host="aarch64-rpi3-linux-gnu" \
        --prefix="/usr/local" \
        CFLAGS="--sysroot=${RPI3_SYSROOT} -O3" \
        CXXFLAGS="--sysroot=${RPI3_SYSROOT} -O3" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd .. && rm -rf make-4.3

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
    make install DESTDIR="${RPI3_SYSROOT}" && \
    cd .. && rm -rf curl-7.68.0

# The Git build process has to call `curl-config` script to find the right 
# cURL libraries
RUN mkdir /tmp/curl-config && \
    ln -s "${RPI3_SYSROOT}/usr/local/bin/curl-config" /tmp/curl-config/
ENV PATH="/tmp/curl-config:${PATH}"

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

# CCache build
WORKDIR /home/develop
RUN wget https://github.com/ccache/ccache/releases/download/v3.7.7/ccache-3.7.7.tar.gz && \
    tar xzf ccache-3.7.7.tar.gz && rm ccache-3.7.7.tar.gz && \
    cd ccache-3.7.7 && \
    ./configure \
        --host="aarch64-rpi3-linux-gnu" \
        --prefix="/usr/local" \
        CFLAGS="--sysroot ${RPI3_SYSROOT} -O3 \
                $(pkg-config zlib --cflags)" \
        CXXFLAGS="--sysroot ${RPI3_SYSROOT} -O3 \
                $(pkg-config zlib --cflags)" \
        LDFLAGS="$(pkg-config zlib --libs)" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd .. && rm -rf ccache-3.7.7

# libpipeline build
WORKDIR /home/develop
RUN wget http://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.2.tar.gz && \
    tar xzf libpipeline-1.5.2.tar.gz && \
    cd libpipeline-1.5.2 && \
    ./configure \
        --prefix="/usr/local" \
        --with-sysroot="${RPI3_SYSROOT}" \
        --host="${HOST_TRIPLE}" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_SYSROOT}" && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd .. && rm -rf libpipeline-1.5.2

# groff build
WORKDIR /home/develop
RUN wget https://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz && \
    tar xzf groff-1.22.4.tar.gz && \
    mkdir groff-1.22.4/build-arm && \
    mkdir groff-1.22.4/build && \
    cd groff-1.22.4/build-arm && \
    ../configure \
        --prefix="/usr/local" \
        --host="${HOST_TRIPLE}" \
        --with-doc="info" \
        CPPFLAGS="--sysroot=${RPI3_SYSROOT}" \
        CFLAGS="--sysroot=${RPI3_SYSROOT}" \
        LDFLAGS="--sysroot=${RPI3_SYSROOT}" \
        CXXFLAGS="--sysroot=${RPI3_SYSROOT}" && \
    make -j$(($(nproc) * 2)) && \
    make install DESTDIR="${RPI3_SYSROOT}" && \
    make install DESTDIR="${RPI3_STAGING}" && \
    cd ../build && \
    ../configure \
        --prefix="$HOME/.local" \
        --with-doc="no" &&\
    make -j$(($(nproc) * 2)) && \
    make install && \
    cd ../.. && rm -rf groff-1.22.4

ENV PATH="/home/develop/.local/bin:${PATH}"

# # man-db build
# WORKDIR /home/develop
# RUN wget http://download.savannah.nongnu.org/releases/man-db/man-db-2.9.0.tar.xz && \
#     tar xJf man-db-2.9.0.tar.xz && \
#     cd man-db-2.9.0 && \
#     ./configure \
#         --enable-mb-groff \
#         --prefix="/usr/local" \
#         --with-sysroot="${RPI3_SYSROOT}" \
#         --host="${HOST_TRIPLE}" \
#         CFLAGS="$(pkg-config libpipeline --cflags) \
#                 --sysroot=${RPI3_SYSROOT}" \
#         CPPFLAGS="$(pkg-config libpipeline --cflags) \
#                 --sysroot=${RPI3_SYSROOT}" \
#         CXXFLAGS="$(pkg-config libpipeline --cflags) \
#                 --sysroot=${RPI3_SYSROOT}" \
#         LDFLAGS="$(pkg-config libpipeline --libs) \
#                 --sysroot=${RPI3_SYSROOT}" && \
#         make -j$(($(nproc) * 2)) && \
#     make install DESTDIR="${RPI3_STAGING}" && \
#     cd .. && rm -rf man-db-2.9.0