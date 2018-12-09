FROM alpine

RUN apk add --no-cache \
        cairo \
        cairo-dev \
        clang \
        dbus \
        dbus-dev \
        gcc \
        git \
        glib \
        glib-dev \
        libnotify \
        libnotify-dev \
        librsvg \
        libxft \
        libxft-dev \
        libxinerama \
        libxinerama-dev \
        libxrandr \
        libxrandr-dev \
        libxscrnsaver \
        libxscrnsaver-dev \
        make \
        musl-dev \
        openssh-client \
        pango \
        pango-dev \
        valgrind \
 && true

ADD entrypoint-dev.sh /srv/entrypoint

ENTRYPOINT ["/srv/entrypoint"]
