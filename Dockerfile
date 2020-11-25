FROM alpine

# Add general dependencies
RUN apk add --no-cache \
        cairo \
        dbus \
        gdk-pixbuf \
        glib \
        librsvg \
        libxft \
        libxinerama \
        libxrandr \
        libxscrnsaver \
        pango

# Build and install dunst
RUN apk add --no-cache --virtual dunstbuild \
        cairo-dev \
        dbus-dev \
        gcc \
        gdk-pixbuf-dev \
        git \
        glib-dev \
        libnotify-dev \
        libxft-dev \
        libxinerama-dev \
        libxrandr-dev \
        libxscrnsaver-dev \
        make \
        musl-dev \
        pango-dev \
        perl \
 && git clone https://github.com/dunst-project/dunst /tmp/dunst \
 && sed -i 's/-g//g' /tmp/dunst/config.mk \
 && make -C /tmp/dunst -j all install test \
 && rm -rf /tmp/dunst \
 && apk del --purge dunstbuild

ADD entrypoint.sh /srv/entrypoint

ENTRYPOINT ["/srv/entrypoint"]
