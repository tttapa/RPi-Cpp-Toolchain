FROM crosstool-ng:v1 as aarch64-toolchain

WORKDIR /home/develop
RUN mkdir /home/develop/RPi3
WORKDIR /home/develop/RPi3
RUN ct-ng aarch64-rpi3-linux-gnu
RUN sed -i 's/CT_GCC_VERSION=\"[0-9.]*\"/CT_GCC_VERSION="9.1.0"/g' .config && \
    sed -i 's/CT_LINUX_VERSION=\"[0-9.]*\"/CT_LINUX_VERSION="4.15"/g' .config && \
    sed -i 's/CT_GLIBC_VERSION=\"[0-9.]*\"/CT_GLIBC_VERSION="2.27"/g' .config
RUN ct-ng build && rm -rf .build

ENV TOOLCHAIN_PATH=/home/develop/x-tools/aarch64-rpi3-linux-gnu
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop