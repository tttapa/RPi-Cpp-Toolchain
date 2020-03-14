FROM aarch64-cross-toolchain as aarch64-cross-native-toolchain

RUN rm -rf /home/develop/RPi3 && mkdir /home/develop/RPi3
WORKDIR /home/develop/RPi3
COPY config .config
RUN ct-ng build || { cat build.log && false; } && rm -rf .build
WORKDIR /home/develop
