ARG TARGETPLATFORM
ARG BUILDPLATFORM

FROM arm64v8/ubuntu:latest

RUN mv /usr/local/man /usr/local/man-tmp
COPY --from=aarch64-installed-tools /home/develop/RPi3-staging /
RUN ls /lib
RUN cp -ar /usr/local/man/* /usr/local/man-tmp && \
    ls /usr/local/man && \
    rm -rf /usr/local/man && \
    mv /usr/local/man-tmp /usr/local/man && \
    ln -s python3.8 /usr/local/bin/python3
COPY --from=aarch64-cross-native-toolchain \
    /home/develop/x-tools/HOST-aarch64-linux-gnu \
    /opt
ENV PATH="/opt/aarch64-rpi3-linux-gnu/bin:${PATH}"
RUN ldconfig

RUN apt-get update && apt install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates && \
    git config --system http.sslCAPath /etc/ssl/certs

WORKDIR /home
COPY wrapper.sh .
RUN \
    chmod +x wrapper.sh  && \
    git clone https://github.com/tttapa/Control-Surface && \
    cd Control-Surface && \
    rm -rf googletest && \
    git clone https://github.com/google/googletest
WORKDIR /home/Control-Surface/build
RUN export CC=aarch64-rpi3-linux-gnu-gcc && \
    export CXX=aarch64-rpi3-linux-gnu-g++ && \
    export AR=aarch64-rpi3-linux-gnu-ar && \
    export LD=aarch64-rpi3-linux-gnu-ld && \
    export FC=aarch64-rpi3-linux-gnu-gfortran && \
    cmake .. \
        -DCMAKE_C_COMPILER_LAUNCHER=/home/wrapper.sh \
        -DCMAKE_CXX_COMPILER_LAUNCHER=/home/wrapper.sh \
        -DCMAKE_AR="/opt/aarch64-rpi3-linux-gnu/bin/${AR}" \
        -DFAST_COMPILE=On
# RUN export CC=aarch64-rpi3-linux-gnu-gcc && \
#     export CXX=aarch64-rpi3-linux-gnu-g++ && \
#     export AR=aarch64-rpi3-linux-gnu-ar && \
#     export LD=aarch64-rpi3-linux-gnu-ld && \
#     export FC=aarch64-rpi3-linux-gnu-gfortran && \
#     cmake .. \
#         -DCMAKE_AR="/opt/aarch64-rpi3-linux-gnu/bin/${AR}" \
#         -DCMAKE_BUILD_TYPE=Debug \
#         -DFAST_COMPILE=OFF

ENTRYPOINT [ "bash" ]