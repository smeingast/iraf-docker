FROM ubuntu:22.04

# set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=host.docker.internal:0
ENV USER=root

# Install dependencies
RUN apt-get update -y && apt-get install -y \
    wget \
    saods9 \
    unzip \
    gcc \
    make \
    flex \
    bison \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libexpat-dev \
    libreadline-dev \
    libncurses-dev \
    tcl-dev \
    libxaw7-dev \
    libxmu-dev \
    xaw3dg-dev \
    libxpm-dev \
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /iraf

# Download IRAF and x11iraf
RUN wget https://github.com/iraf-community/iraf/archive/refs/tags/v2.17.1.zip && \
    wget https://github.com/iraf-community/x11iraf/archive/refs/tags/v2.1.zip && \
    unzip v2.17.1.zip && \
    unzip v2.1.zip && \
    rm v2.17.1.zip && \
    rm v2.1.zip

# Build and test IRAF
WORKDIR /iraf/iraf-2.17.1
RUN make > build.log && \
    make test && \
    make install

# Build x11iraf
WORKDIR /iraf/x11iraf-2.1
RUN make && \
    make install

# Go back to home directory
WORKDIR /root

# Will start a shell when container runs
CMD ["/bin/bash"]

