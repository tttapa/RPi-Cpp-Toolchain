FROM aarch64-cross-toolchain as toolchain

FROM base-ubuntu as aarch64-cross-toolchain-distcc

COPY --from=toolchain /home/develop/x-tools/aarch64-rpi3-linux-gnu \
                      /home/develop/x-tools/aarch64-rpi3-linux-gnu

ENV TOOLCHAIN_PATH=/home/develop/x-tools/aarch64-rpi3-linux-gnu
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop

USER root
RUN apt-get update && \
    apt-get install -y libiberty-dev python3-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/distcc/distcc.git --depth=1 --single-branch && \
    cd distcc && \
    ./autogen.sh && \
    ./configure && \
    make -j`nproc` && \
    make install && \
    cd .. && rm -rf distcc
RUN mkdir -p /usr/local/lib/distcc && ln -s ${TOOLCHAIN_PATH}/bin/* /usr/local/lib/distcc
RUN update-distcc-symlinks
USER develop