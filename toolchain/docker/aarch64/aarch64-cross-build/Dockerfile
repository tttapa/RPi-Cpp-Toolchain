FROM base-ubuntu as python-opencv-build

# Set the path to the toolchain executables
ENV HOST_CPU="CORTEXA53"
ENV HOST_ARCH="aarch64"
ENV HOST_TRIPLE="aarch64-rpi3-linux-gnu"
ENV TOOLCHAIN_PATH="/home/develop/x-tools/${HOST_TRIPLE}"
ENV PATH="${PATH}:${TOOLCHAIN_PATH}/bin"
ENV DOWNLOADS="/tmp/downloads"

# Copy the toolchain from the previous Docker image
COPY --from=aarch64-cross-toolchain \
    /home/develop/x-tools/${HOST_TRIPLE} \
    ${TOOLCHAIN_PATH}

# Create a sysroot and staging area for the RPi
WORKDIR /home/develop
ENV RPI3_SYSROOT=/home/develop/RPi3-sysroot
ENV RPI3_STAGING=/home/develop/RPi3-staging
RUN mkdir RPi3-sysroot && \
    cp -rp $TOOLCHAIN_PATH/${HOST_TRIPLE}/sysroot/* ~/RPi3-sysroot/ && \
    chmod -R u+w /home/develop/RPi3-sysroot

WORKDIR /home/develop
RUN mkdir -p "${DOWNLOADS}"
COPY --chown=develop:develop tools/ ./tools/
ENV PATH="/home/develop/tools:${PATH}"

WORKDIR /home/develop

# Zlib build
COPY --chown=develop:develop install-scripts/zlib-build.sh .
RUN chmod +x zlib-build.sh && ./zlib-build.sh

# Zlib ARM
COPY --chown=develop:develop install-scripts/zlib.sh .
RUN chmod +x zlib.sh && ./zlib.sh
 
# OpenSSL build
COPY --chown=develop:develop install-scripts/openssl-build.sh .
RUN chmod +x openssl-build.sh && ./openssl-build.sh

# OpenSSL ARM
COPY --chown=develop:develop install-scripts/openssl.sh .
RUN chmod +x openssl.sh && ./openssl.sh

# FFI build
COPY --chown=develop:develop install-scripts/libffi-build.sh .
RUN chmod +x libffi-build.sh && ./libffi-build.sh

# FFI ARM
COPY --chown=develop:develop install-scripts/libffi.sh .
RUN chmod +x libffi.sh && ./libffi.sh

# Bzip2 ARM
COPY --chown=develop:develop install-scripts/bzip2.sh .
RUN chmod +x bzip2.sh && ./bzip2.sh

# GNU NCurses build
COPY --chown=develop:develop install-scripts/ncurses-build.sh .
RUN chmod +x ncurses-build.sh && ./ncurses-build.sh

# GNU NCurses ARM
COPY --chown=develop:develop install-scripts/ncurses.sh .
RUN chmod +x ncurses.sh && ./ncurses.sh

# GNU Readline ARM
COPY --chown=develop:develop install-scripts/readline.sh .
RUN chmod +x readline.sh && ./readline.sh

# GNU DBM ARM
COPY --chown=develop:develop install-scripts/dbm.sh .
RUN chmod +x dbm.sh && ./dbm.sh

# SQLite ARM
COPY --chown=develop:develop install-scripts/sqlite.sh .
RUN chmod +x sqlite.sh && ./sqlite.sh

# UUID ARM
COPY --chown=develop:develop install-scripts/uuid.sh .
RUN chmod +x uuid.sh && ./uuid.sh

# Python build
COPY --chown=develop:develop install-scripts/python-build.sh .
RUN chmod +x python-build.sh && ./python-build.sh
ENV PATH="/home/develop/.local/bin:${PATH}"

# Python ARM
COPY --chown=develop:develop install-scripts/python.sh .
RUN chmod +x python.sh && ./python.sh

# ZBar ARM
COPY --chown=develop:develop install-scripts/zbar.sh .
RUN chmod +x zbar.sh && ./zbar.sh
 
# Raspberry Pi Userland (VideoCore)
COPY install-scripts/RPi3.toolchain.cmake .
COPY --chown=develop:develop install-scripts/userland.sh .
RUN chmod +x userland.sh && ./userland.sh

# VPX ARM
COPY --chown=develop:develop install-scripts/vpx.sh .
RUN chmod +x vpx.sh && ./vpx.sh

# x264 ARM
COPY --chown=develop:develop install-scripts/x264.sh .
RUN chmod +x x264.sh && ./x264.sh

# Xvid ARM
COPY --chown=develop:develop install-scripts/xvid.sh .
RUN chmod +x xvid.sh && ./xvid.sh

# FFmpeg ARM
COPY --chown=develop:develop install-scripts/ffmpeg.sh .
RUN chmod +x ffmpeg.sh && ./ffmpeg.sh

# Install NumPy and Crossenv on build
RUN python3.8 -m pip install crossenv
RUN python3.8 -m crossenv "${RPI3_SYSROOT}/usr/local/bin/python3.8" crossenv

# OpenBLAS ARM
COPY --chown=develop:develop install-scripts/openblas.sh .
RUN chmod +x openblas.sh && ./openblas.sh

# Wheel, Cython, Pybind11, Numpy and Scipy packages ARM
RUN . crossenv/bin/activate && pip install wheel cython pybind11 
COPY --chown=develop:develop install-scripts/numpy-scipy.sh .
COPY --chown=develop:develop patches/npymath.ini.patch .
RUN chmod +x numpy-scipy.sh && ./numpy-scipy.sh

# OpenCV ARM
COPY --chown=develop:develop install-scripts/opencv.sh .
RUN chmod +x opencv.sh && ./opencv.sh

# Move the compiled Python packages to the staging area
RUN rm -rf crossenv/cross/lib/python3.8/site-packages/__pycache__ && \
    mv "crossenv/cross/lib/python3.8/site-packages/"* \
       "${RPI3_STAGING}/usr/local/lib/python3.8/site-packages"

# Copy gdbserver to the staging area, as well as the latest C++ and Fortran 
# libraries
RUN mkdir -p "${RPI3_STAGING}/usr/local/lib/${HOST_ARCH}-linux-gnu/" && \
    cp -a \
        "${RPI3_SYSROOT}/lib/libstdc++.so"* \
        "${RPI3_STAGING}/usr/local/lib/${HOST_ARCH}-linux-gnu/" && \
    cp -a \
        "${RPI3_SYSROOT}/lib/libgfortran.so"* \
        "${RPI3_STAGING}/usr/local/lib/${HOST_ARCH}-linux-gnu/" && \
    cp -ar \
        "$TOOLCHAIN_PATH/${HOST_TRIPLE}/debug-root/"* \
        "${RPI3_STAGING}"

FROM python-opencv-build as developer-build

# DistCC ARM
COPY --chown=develop:develop install-scripts/distcc.sh .
COPY --chown=develop:develop patches/pump.patch .
RUN chmod +x distcc.sh && ./distcc.sh

# Make ARM
COPY --chown=develop:develop install-scripts/make.sh .
RUN chmod +x make.sh && ./make.sh

# CMake ARM
COPY --chown=develop:develop install-scripts/cmake.sh .
COPY --chown=develop:develop install-scripts/RPi3.toolchain.cmake.cmake .
RUN chmod +x cmake.sh && ./cmake.sh

# CCache ARM
COPY --chown=develop:develop install-scripts/ccache.sh .
RUN chmod +x ccache.sh && ./ccache.sh

# cURL ARM
COPY --chown=develop:develop install-scripts/curl.sh .
RUN chmod +x curl.sh && ./curl.sh

# Git ARM
COPY --chown=develop:develop install-scripts/git.sh .
COPY --chown=develop:develop patches/git-2.25.0.patch .
RUN chmod +x git.sh && ./git.sh
