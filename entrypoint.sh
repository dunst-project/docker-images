#!/bin/sh

export USER_UID=${USER_UID:-1000}
export USER_GID=${USER_GID:-1000}
export USER_NAME=${USER_NAME:-dunstuser}

id -g $USER_NAME 2>/dev/null >/dev/null || addgroup   -g $USER_GID $USER_NAME
id -u $USER_NAME 2>/dev/null >/dev/null || adduser -D -u $USER_UID -G $USER_NAME $USER_NAME

su $USER_NAME -s /bin/sh -c "/usr/local/bin/dunst -conf /tmp/dunstrc $*"
