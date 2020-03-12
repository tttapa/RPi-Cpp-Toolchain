FROM crosstool-ng-master as armv6-toolchain

WORKDIR /home/develop
RUN mkdir /home/develop/RPi && mkdir /home/develop/src
WORKDIR /home/develop/RPi
COPY config .config

RUN ct-ng build || { cat build.log && false; } && rm -rf .build

ENV TOOLCHAIN_PATH=/home/develop/x-tools/armv6-rpi-linux-gnueabihf
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop