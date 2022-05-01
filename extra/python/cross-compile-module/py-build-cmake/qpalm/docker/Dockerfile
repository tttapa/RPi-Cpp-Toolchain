ARG HOST_TRIPLET
FROM tttapa/docker-arm-cross-build-scripts:${HOST_TRIPLET}

# You can download or install any dependencies you need here

# The advantage of installing them here instead of in the build-docker.sh
# script is that they will only be installed once, whereas the build-docker.sh
# script is executed in a fresh Docker container every time you want to build
# your module.

RUN wget -qO cmake.sh https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-$(uname -m).sh && \
    sudo bash cmake.sh --prefix=/usr/local --skip-license --exclude-subdir && \
    rm cmake.sh
# TODO: only the x86 version of Ninja is available as a binary
RUN wget -qO ninja.zip https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip && \
    unzip ninja.zip && \
    sudo mv ninja /usr/local/bin && \
    rm ninja.zip
RUN cmake --version
RUN ninja --version
RUN git clone --single-branch --depth=1 --branch 3.4.0 https://gitlab.com/libeigen/eigen.git && \
    cd eigen && \
    cmake -Bbuild -S. -G "Ninja Multi-Config" \
        -D CMAKE_INSTALL_PREFIX="/usr/local" && \
    cmake --build build --config Debug -j && \
    sudo cmake --install build --config Debug && \
    cmake --build build --config Release -j && \
    sudo cmake --install build --config Release && \
    cmake -Bcross -S. -G "Ninja Multi-Config" \
        -D CMAKE_INSTALL_PREFIX="${RPI_SYSROOT}/usr/local" \
        -D CMAKE_TOOLCHAIN_FILE="${HOME}/${HOST_TRIPLE}.cmake" && \
    cmake --build cross --config Debug -j && \
    cmake --install cross --config Debug && \
    cmake --build cross --config Release -j && \
    cmake --install cross --config Release && \
    cd .. && \
    rm -rf eigen

# Install the build package to build Python packages
RUN python3.10 -m pip install build
RUN . ~/crossenv/bin/activate && \
    pip install auditwheel patchelf
