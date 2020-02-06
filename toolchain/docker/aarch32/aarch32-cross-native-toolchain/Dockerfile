FROM aarch32-cross-toolchain as aarch32-cross-native-toolchain

RUN echo $PATH && ls /home/develop/x-tools/armv8-rpi3-linux-gnueabihf/bin
RUN rm -rf /home/develop/RPi3 && mkdir /home/develop/RPi3
WORKDIR /home/develop/RPi3
COPY config .config
RUN ct-ng build && rm -rf .build