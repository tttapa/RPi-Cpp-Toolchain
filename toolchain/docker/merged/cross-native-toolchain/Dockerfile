ARG HOST_TRIPLE

FROM tttapa/rpi-cross-toolchain:${HOST_TRIPLE} as cross-native-toolchain

ARG HOST_TRIPLE

RUN rm -rf /home/develop/RPi && mkdir /home/develop/RPi
WORKDIR /home/develop/RPi
COPY ${HOST_TRIPLE}.config .config
RUN ct-ng build || { cat build.log && false; } && rm -rf .build
WORKDIR /home/develop
