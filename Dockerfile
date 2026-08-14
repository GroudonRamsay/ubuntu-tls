FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        openssl \
        ca-certificates \
        iproute2 \
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
        procps \
        psmisc \
        lsof \
        vim \
        nano \
        less \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root

CMD ["/bin/bash"]
