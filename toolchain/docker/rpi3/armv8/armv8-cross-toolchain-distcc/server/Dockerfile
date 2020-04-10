FROM rpi-cpp-toolchain-base-ubuntu as armv8-cross-toolchain-distcc

# Copy the cross compilation toolchain
COPY --from=rpi3-armv8-cross-toolchain \
        /home/develop/x-tools/armv8-rpi3-linux-gnueabihf \
        /home/develop/x-tools/armv8-rpi3-linux-gnueabihf

# Add the cross compilers to the path
ENV TOOLCHAIN_PATH=/home/develop/x-tools/armv8-rpi3-linux-gnueabihf
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop

# Install distcc
USER root
RUN apt-get update && \
    apt-get install -y libiberty-dev python3-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/distcc/distcc.git \
    --depth=1 --single-branch && \
    cd distcc && \
    ./autogen.sh && \
    ./configure && \
    make -j$(($(nproc) * 2)) && \
    make install && \
    cd .. && rm -rf distcc

# Add the cross compilers to distcc
RUN mkdir -p "/usr/local/lib/distcc" \
 && bash -c 'ln -vs "${TOOLCHAIN_PATH}/bin/"{*gcc,*g++,*gfortran} \
             "/usr/local/lib/distcc"'
RUN update-distcc-symlinks
USER develop
