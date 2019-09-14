FROM crosstool-ng:v1 as aarch32-toolchain

WORKDIR /home/develop
RUN sed -i 's/CT_ARCH_FPU=\"neon-vfpv4\"/CT_ARCH_FPU="neon-fp-armv8"/g' \
    .local/share/crosstool-ng/samples/armv8-rpi3-linux-gnueabihf/crosstool.config
RUN mkdir /home/develop/RPi3
WORKDIR /home/develop/RPi3
RUN ct-ng armv8-rpi3-linux-gnueabihf
RUN sed -i 's/CT_GCC_VERSION=\"[0-9.]*\"/CT_GCC_VERSION="9.1.0"/g' .config && \
    sed -i 's/CT_LINUX_VERSION=\"[0-9.]*\"/CT_LINUX_VERSION="4.14"/g' .config && \
    sed -i 's/CT_GLIBC_VERSION=\"[0-9.]*\"/CT_GLIBC_VERSION="2.24"/g' .config
RUN ct-ng build && rm -rf .build

ENV TOOLCHAIN_PATH=/home/develop/x-tools/armv8-rpi3-linux-gnueabihf
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop