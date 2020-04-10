FROM tttapa/rpi-cpp-toolchain-base-ubuntu as python-opencv-build

# Set the path to the toolchain executables
ENV HOST_ARCH=armv6
ENV HOST_TRIPLE=armv6-rpi-linux-gnueabihf
ENV TOOLCHAIN_PATH="/home/develop/x-tools/${HOST_TRIPLE}"
ENV PATH="${PATH}:${TOOLCHAIN_PATH}/bin"
ENV DOWNLOADS="/tmp/downloads"

# Copy the toolchain from the previous Docker image
COPY --from=rpi-armv6-cross-toolchain \
    /home/develop/x-tools/${HOST_TRIPLE} \
    ${TOOLCHAIN_PATH}

# Create a sysroot and staging area for the RPi
WORKDIR /home/develop
ENV RPI_SYSROOT=/home/develop/RPi-sysroot
ENV RPI_STAGING=/home/develop/RPi-staging
RUN mkdir RPi-sysroot && \
    cp -rp $TOOLCHAIN_PATH/${HOST_TRIPLE}/sysroot/* ~/RPi-sysroot/ && \
    chmod -R u+w /home/develop/RPi-sysroot

RUN mkdir -p "${DOWNLOADS}"
COPY --chown=develop:develop tools/ ./tools/
ENV PATH="/home/develop/tools:${PATH}"

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
COPY install-scripts/RPi.toolchain.userland.cmake .
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
RUN python3.8 -m crossenv "${RPI_SYSROOT}/usr/local/bin/python3.8" crossenv

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
       "${RPI_STAGING}/usr/local/lib/python3.8/site-packages"

# Copy gdbserver to the staging area, as well as the latest C++ and Fortran 
# libraries
RUN mkdir -p "${RPI_STAGING}/usr/local/lib/arm-linux-gnueabihf/" && \
    cp -a \
        "${RPI_SYSROOT}/lib/libstdc++.so"* \
        "${RPI_STAGING}/usr/local/lib/arm-linux-gnueabihf/" && \
    cp -a \
        "${RPI_SYSROOT}/lib/libgfortran.so"* \
        "${RPI_STAGING}/usr/local/lib/arm-linux-gnueabihf/" && \
    cp -a \
        "$TOOLCHAIN_PATH/${HOST_TRIPLE}/debug-root/usr/bin/gdbserver" \
        "${RPI_STAGING}/usr/local/bin"

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
COPY --chown=develop:develop install-scripts/RPi.toolchain.cmake.cmake .
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

# CMake build
COPY --chown=develop:develop install-scripts/cmake-build.sh .
RUN chmod +x cmake-build.sh && ./cmake-build.sh

# Ninja ARM
COPY --chown=develop:develop install-scripts/ninja.sh .
RUN chmod +x ninja.sh && ./ninja.sh

# Copy the GCC toolchain
COPY --from=rpi-armv6-cross-native-toolchain \
    /home/develop/x-tools/HOST-armv6-linux-gnueabihf \
    ${RPI_STAGING}/opt
# Create links to the toolchain in /usr/local/bin
RUN cd "${RPI_STAGING}/usr/local/bin" && \
    find "../../../opt/${HOST_TRIPLE}/bin" -type f \
        -name "${HOST_TRIPLE}-*" \
        -exec ln -s {} . ';'
# Create links without the target prefix 
# (e.g. gcc instead of armv6-rpi-linux-gnueabihf-gcc)
COPY --chown=develop:develop dev-tools/strip-toolchain-prefix.sh .
RUN chmod +x strip-toolchain-prefix.sh \
 && cd "${RPI_STAGING}/usr/local/bin" \
 && /home/develop/strip-toolchain-prefix.sh \
        "${HOST_TRIPLE}" \
        "../../../opt/${HOST_TRIPLE}/bin" \
        "${RPI_STAGING}/usr/local/bin"
# Make links to distcc for gcc and g++
RUN mkdir -p "${RPI_STAGING}/usr/local/lib/distcc/bin" \
 && cd "${RPI_STAGING}/usr/local/lib/distcc/bin" \
 && ln -s "../../../bin/distcc" "${HOST_TRIPLE}-gcc" \
 && ln -s "../../../bin/distcc" "${HOST_TRIPLE}-g++"
