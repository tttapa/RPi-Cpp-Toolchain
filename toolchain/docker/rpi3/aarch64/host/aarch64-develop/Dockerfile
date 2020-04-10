ARG TARGETPLATFORM
ARG BUILDPLATFORM

FROM arm64v8/ubuntu:latest

# Move aside the original /usr/local/man folder (it's a symlink)
RUN mv /usr/local/man /usr/local/man-tmp
# Copy the staging area from the cross compilation to the root of the filesystem
COPY --from=rpi3-aarch64-develop-cross /home/develop/RPi-staging /
# Restore the man symlink
RUN cp -ar /usr/local/man/* /usr/local/man-tmp && \
    rm -rf /usr/local/man && \
    mv /usr/local/man-tmp /usr/local/man 

# Make Python 3.8 the default python3
RUN ln -s python3.8 /usr/local/bin/python3

# Copy the GCC toolchain
COPY --from=tttapa/rpi3-aarch64-cross-native-toolchain \
    /home/develop/x-tools/HOST-aarch64-linux-gnu \
    /opt
ENV PATH="/opt/aarch64-rpi3-linux-gnu/bin:${PATH}"
RUN ldconfig

COPY strip-toolchain-prefix.sh .
RUN chmod +x strip-toolchain-prefix.sh && \
    ./strip-toolchain-prefix.sh \
        "aarch64-rpi3-linux-gnu" \
        "/opt/aarch64-rpi3-linux-gnu/bin" \
        "/usr/local/bin" && \
    rm strip-toolchain-prefix.sh

# Install sudo, CA certificates and configure SSL for Git
RUN apt-get update && apt install -y sudo ca-certificates && \
    apt-get clean autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates && \
    git config --system http.sslCAPath /etc/ssl/certs

# Copy the distcc wrapper script to the bin
COPY distcc-wrapper.sh /usr/local/bin/distcc-wrapper
RUN chmod +x /usr/local/bin/distcc-wrapper

# Add a user called `develop`, and add him to the sudo group
RUN useradd -m develop && \
    echo "develop:develop" | chpasswd && \
    adduser develop sudo

USER develop
WORKDIR /home/develop

# Enable distcc by default if ccache is used
ENV CCACHE_PREFIX=distcc-wrapper

# Use the full compiler names for distcc
ENV CC=aarch64-rpi3-linux-gnu-gcc
ENV CXX=aarch64-rpi3-linux-gnu-g++
ENV FC=aarch64-rpi3-linux-gnu-gfortran

RUN git clone https://github.com/tttapa/Control-Surface && \
    cd Control-Surface && \
    git submodule update --init --recursive --depth 50
WORKDIR /home/develop/Control-Surface/build

RUN cmake .. \
        -DFAST_COMPILE=On

CMD [ "bash" ]