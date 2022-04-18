FROM ubuntu:focal as ct-ng

# Install dependencies to build toolchain
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y gcc g++ gperf bison flex texinfo help2man make libncurses5-dev unzip \
                       python3-dev autoconf automake libtool libtool-bin gawk wget rsync git && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Add a user called `develop` and add him to the sudo group
RUN useradd -m develop && \
    echo "develop:develop" | chpasswd && \
    adduser develop sudo

USER develop
WORKDIR /home/develop

RUN wget https://ftp.debian.org/debian/pool/main/b/binutils/binutils-source_2.31.1-16_all.deb && \
    mkdir binutils && cd binutils && \
    ar x ../binutils-source_2.31.1-16_all.deb && \
    tar xf data.tar.xz && \
    cp usr/src/binutils/patches/129_multiarch_libpath.patch /home/develop

# Download and install the latest version of crosstool-ng
RUN git clone -b master --single-branch --depth 1 \
        https://github.com/crosstool-ng/crosstool-ng.git
WORKDIR /home/develop/crosstool-ng
RUN git show --summary && \
    ./bootstrap && \
    mkdir build && cd build && \
    ../configure --prefix=/home/develop/.local && \
    make -j$(($(nproc) * 2)) && \
    make install &&  \
    cd .. && rm -rf build
ENV PATH=/home/develop/.local/bin:$PATH
WORKDIR /home/develop 