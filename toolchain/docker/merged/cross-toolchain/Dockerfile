FROM tttapa/crosstool-ng-master as cross-toolchain

ARG HOST_TRIPLE
ARG HOST_TRIPLE_LIB_DIR

WORKDIR /home/develop
RUN mkdir /home/develop/RPi && mkdir /home/develop/src
WORKDIR /home/develop/RPi
COPY ${HOST_TRIPLE}.config .config
RUN mkdir -p patches/binutils/2.31.1 && \
    cp /home/develop/129_multiarch_libpath.patch patches/binutils/2.31.1

# https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=280707&p=1700861#p1700861
ENV DEB_TARGET_MULTIARCH=${HOST_TRIPLE_LIB_DIR}
RUN ct-ng build || { cat build.log && false; } && rm -rf .build

ENV TOOLCHAIN_PATH=/home/develop/x-tools/${HOST_TRIPLE}
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop
