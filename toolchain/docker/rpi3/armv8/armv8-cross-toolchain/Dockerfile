FROM tttapa/crosstool-ng-master as armv8-toolchain

WORKDIR /home/develop
RUN mkdir /home/develop/RPi3 && mkdir /home/develop/src
WORKDIR /home/develop/RPi3
COPY config .config

RUN ct-ng build || { cat build.log && false; } && rm -rf .build

ENV TOOLCHAIN_PATH=/home/develop/x-tools/armv8-rpi3-linux-gnueabihf
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH
WORKDIR /home/develop