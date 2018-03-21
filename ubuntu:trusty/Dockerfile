FROM ubuntu:trusty

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git \
        libdbus-1-dev \
        libglib2.0-dev \
        libgtk-3-dev \
        libpango1.0-dev \
        libx11-dev \
        libxdg-basedir-dev \
        libxinerama-dev \
        libxrandr-dev \
        libxss-dev \
        valgrind \
 && apt-get clean \
 && true

ARG REPO_URL=https://github.com/dunst-project/dunst
ARG REPO_BRANCH=master

RUN true \
 && git clone "${REPO_URL}" /tmp/dunst \
 && git -C /tmp/dunst checkout "${REPO_BRANCH}" \
 && make -C /tmp/dunst -j $(nproc) all install test-valgrind \
 && true
