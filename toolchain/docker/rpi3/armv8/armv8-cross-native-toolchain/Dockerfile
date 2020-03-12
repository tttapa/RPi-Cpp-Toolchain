FROM armv8-cross-toolchain as armv8-cross-native-toolchain

RUN rm -rf /home/develop/RPi3 && mkdir /home/develop/RPi3
WORKDIR /home/develop/RPi3
COPY config .config
RUN ct-ng build || { cat build.log && false; } && rm -rf .build