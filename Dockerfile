# syntax=docker/dockerfile:1

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG PREMAKE_REF=v5.0.0-beta8

USER root

LABEL org.opencontainers.image.source="https://github.com/MonoGame/steamrt-build-images"
LABEL org.opencontainers.image.description="Steam Runtime Sniper SDK with Premake5"
LABEL org.opencontainers.image.licenses="MIT"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        gcc-14 \
        g++-14 \
        git \
        libtool \
        nasm \
        pkg-config \
        uuid-dev \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 100 \
        --slave /usr/bin/g++ g++ /usr/bin/g++-14 \
    && gcc --version \
    && g++ --version \
    && git clone --depth 1 --branch "${PREMAKE_REF}" \
        https://github.com/premake/premake-core.git \
        /tmp/premake-core \
    && cd /tmp/premake-core \
    && ./Bootstrap.sh \
    && install -m 0755 \
        bin/release/premake5 \
        /usr/local/bin/premake5 \
    && premake5 --version \
    && rm -rf /tmp/premake-core \
    && rm -rf /var/lib/apt/lists/*
