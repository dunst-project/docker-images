#!/bin/bash

IMAGE=bebehei/dunst
XSOCK=/tmp/.X11-unix

[ -z "${DBUS_SESSION_BUS_ADDRESS}" ] && echo '$DBUS_SESSION_BUS_ADDRESS missing' && exit 1
[ -z "${DISPLAY}" ] && echo '\$DISPLAY missing' && exit 1

# Build image on the fly, if not available yet
docker image inspect "${IMAGE}" &>/dev/null || ([ -f Dockerfile ] && docker build -t "${IMAGE}" .)

XAUTH=$(mktemp)

DBUS_PATH=$(echo ${DBUS_SESSION_BUS_ADDRESS} | cut -d = -f 2)

touch ~/.config/dunst/dunstrc

xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -

docker run -it --rm \
	--cap-add=SYS_ADMIN \
	--env="USER_UID=$(id -u)" \
	--env="USER_GID=$(id -g)" \
	--env="USER_NAME=$(id -un)" \
	--env="DISPLAY" \
	--env="DBUS_SESSION_BUS_ADDRESS" \
	--env="XAUTHORITY=${XAUTH}" \
	--volume=${DBUS_PATH}:${DBUS_PATH} \
	--volume=${XSOCK}:${XSOCK} \
	--volume=${XAUTH}:${XAUTH} \
	--volume=$HOME/.config/dunst/dunstrc:/tmp/dunstrc:ro \
	--volume=/usr/share/icons:/usr/share/icons:ro \
	--volume=/usr/share/fonts:/usr/share/fonts:ro \
	${IMAGE} $*

rm ${XAUTH}
