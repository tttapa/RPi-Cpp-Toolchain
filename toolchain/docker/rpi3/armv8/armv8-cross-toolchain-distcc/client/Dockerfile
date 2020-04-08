FROM arm32v7/ubuntu:latest

# Move aside the original /usr/local/man folder (it's a symlink)
RUN mv /usr/local/man /usr/local/man-tmp
# Copy the staging area from the cross compilation to the root of the filesystem
COPY --from=rpi3-armv8-develop-cross /home/develop/RPi-staging /
# Restore the man symlink
RUN cp -ar /usr/local/man/* /usr/local/man-tmp && \
    rm -rf /usr/local/man && \
    mv /usr/local/man-tmp /usr/local/man 
RUN ldconfig

# Make Python 3.8 the default python3
RUN ln -s python3.8 /usr/local/bin/python3

# Install sudo, CA certificates and configure SSL for Git
RUN apt-get update && apt install -y sudo ca-certificates && \
    apt-get clean autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates && \
    git config --system http.sslCAPath /etc/ssl/certs

# Add a user called `develop`, and add him to the sudo group
RUN useradd -m develop && \
    echo "develop:develop" | chpasswd && \
    adduser develop sudo

USER develop
WORKDIR /home/develop

# Use distcc as a compiler wrapper
ENV PATH="/usr/local/lib/distcc/bin:$PATH"

# Use the full compiler names for distcc
ENV CC=armv8-rpi3-linux-gnueabihf-gcc
ENV CXX=armv8-rpi3-linux-gnueabihf-g++
ENV FC=armv8-rpi3-linux-gnueabihf-gfortran

CMD [ "bash" ]