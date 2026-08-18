# ============================================================
# Stage 1: Build OpenSSL
# ============================================================
FROM ubuntu:24.04 AS openssl-builder

ARG OPENSSL_VERSION=3.6.3

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        perl \
        wget \
        tar \
        && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
    tar -xzf openssl-${OPENSSL_VERSION}.tar.gz && \
    cd openssl-${OPENSSL_VERSION} && \
    ./Configure \
        --prefix=/opt/openssl \
        --openssldir=/opt/openssl/ssl \
        shared \
        linux-x86_64 && \
    make -j"$(nproc)" && \
    make install_sw && \
    rm -rf /tmp/openssl-${OPENSSL_VERSION}*


# ============================================================
# Stage 2: Final container
# ============================================================
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        iproute2 \
        iptables \
        bridge-utils \
        iputils-ping \
        net-tools \
        tcpdump \
        tshark \
        netcat-openbsd \
        socat \
        curl \
        wget \
        dnsutils \
        traceroute \
        ethtool \
        conntrack \
        procps \
        psmisc \
        lsof \
        vim \
        nano \
        less \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# ------------------------------------------------------------
# Install custom OpenSSL
# ------------------------------------------------------------
COPY --from=openssl-builder /opt/openssl /opt/openssl

RUN mkdir -p /opt/openssl/ssl && \
    cp /etc/ssl/openssl.cnf /opt/openssl/ssl/openssl.cnf

# ------------------------------------------------------------
# Use custom OpenSSL by default
# ------------------------------------------------------------
ENV PATH="/opt/openssl/bin:${PATH}"

ENV LD_LIBRARY_PATH="/opt/openssl/lib64:/opt/openssl/lib"

ENV OPENSSL_CONF="/opt/openssl/ssl/openssl.cnf"


# ------------------------------------------------------------
# Verify OpenSSL during image build
# ------------------------------------------------------------
RUN openssl version -a


WORKDIR /root

CMD ["/bin/bash"]
