FROM centos:7 as ct-ng

# Install dependencies to build toolchain
RUN yum -y update && \
    yum install -y epel-release && \
    yum install -y autoconf gperf bison file flex texinfo help2man gcc-c++ \
    libtool make patch ncurses-devel python36-devel perl-Thread-Queue bzip2 \
    git wget which xz unzip && \
    yum clean all

# Add a user called `develop` and add him to the sudo group
RUN useradd -m develop && echo "develop:develop" | chpasswd && \
    usermod -aG wheel develop

USER develop
WORKDIR /home/develop

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
RUN wget https://ftp.debian.org/debian/pool/main/b/binutils/binutils-source_2.31.1-16_all.deb && \
    mkdir binutils && cd binutils && \
    ar x ../binutils-source_2.31.1-16_all.deb && \
    tar xf data.tar.xz && \
    cp usr/src/binutils/patches/129_multiarch_libpath.patch /home/develop