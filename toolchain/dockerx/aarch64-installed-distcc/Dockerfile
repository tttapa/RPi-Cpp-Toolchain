FROM aarch64-installed-x
ARG TARGETPLATFORM
ARG BUILDPLATFORM

COPY --from=aarch64-cross-native-toolchain \
    /home/develop/x-tools/HOST-aarch64-linux-gnu \
    /opt

ENV PATH="${PATH}:/opt/aarch64-rpi3-linux-gnu/bin"
ENTRYPOINT [ "bash" ]