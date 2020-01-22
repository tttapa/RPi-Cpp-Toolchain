FROM --platform=$BUILDPLATFORM aarch64-cross-native-toolchain as toolchain 

ARG TARGETPLATFORM
ARG BUILDPLATFORM

FROM arm64v8/ubuntu:latest
RUN mv /usr/local/man /usr/local/man-tmp
COPY --from=toolchain \
    /home/develop/x-tools/HOST-aarch64-linux-gnu \
    /opt
RUN ln -s /opt/aarch64-rpi3-linux-gnu/bin/* /usr/local/bin && \
    cp -arL /opt/aarch64-rpi3-linux-gnu/aarch64-rpi3-linux-gnu/lib64 /usr/local && \
    ldconfig

ENTRYPOINT [ "bash" ]