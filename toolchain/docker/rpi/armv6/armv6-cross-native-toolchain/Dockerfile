FROM rpi-armv6-cross-toolchain as armv6-cross-native-toolchain

RUN rm -rf /home/develop/RPi && mkdir /home/develop/RPi
WORKDIR /home/develop/RPi
COPY config .config
RUN ct-ng build || { cat build.log && false; } && rm -rf .build
WORKDIR /home/develop
