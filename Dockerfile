FROM alpine

RUN apk add --no-cache \
        cairo \
        dbus \
        glib \
        librsvg \
        libxft \
        libxinerama \
        libxrandr \
        libxscrnsaver \
        pango \
 && true

ARG REPO_URL=https://github.com/dunst-project/dunst
ARG REPO_BRANCH=master

RUN true \
 && apk add --no-cache --virtual dunstbuild \
        cairo-dev \
        dbus-dev \
        gcc \
        git \
        glib-dev \
        libxft-dev \
        libxinerama-dev \
        libxrandr-dev \
        libxscrnsaver-dev \
        make \
        musl-dev \
        pango-dev \
 && git clone "${REPO_URL}" /tmp/dunst \
 && sed -i 's/-g//g' /tmp/dunst/config.mk \
 && git -C /tmp/dunst checkout "${REPO_BRANCH}" \
 && make -C /tmp/dunst -j $(nproc) all install test \
 && rm -rf /tmp/dunst \
 && apk del --purge dunstbuild

ADD entrypoint.sh /srv/entrypoint

ENTRYPOINT ["/srv/entrypoint"]
