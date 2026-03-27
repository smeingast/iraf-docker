# --- Builder stage ---
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update -y && apt-get install -y \
    wget \
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
    && rm -rf /var/lib/apt/lists/*

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
RUN make > /dev/null && \
    make test && \
    make install

# Build x11iraf
WORKDIR /iraf/x11iraf-2.1
RUN make && \
    make install

# --- Runtime stage ---
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=host.docker.internal:0
ENV USER=root

# Install only runtime dependencies (no build tools or -dev packages)
RUN apt-get update -y && apt-get install -y \
    saods9 \
    libcurl4 \
    libexpat1 \
    libreadline8 \
    libncurses6 \
    tcl \
    libxaw7 \
    libxmu6 \
    xaw3dg \
    libxpm4 \
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy installed IRAF and x11iraf from builder
COPY --from=builder /usr/local /usr/local
COPY --from=builder /etc/iraf /etc/iraf
COPY --from=builder /etc/terminfo/x/xgterm /etc/terminfo/x/xgterm

WORKDIR /root

CMD ["/bin/bash"]

