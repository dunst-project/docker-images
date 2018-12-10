XSOCK?=/tmp/.X11-unix
DUNSTRC=${HOME}/.config/dunst/dunstrc
DOCKER_REPO?=dunst/dunst
DOCKER_REPO_CI?=dunst/ci
DOCKER_TECHNIQUE?=build
REPO=./dunst
CFLAGS?=-Werror

IMG_CI?=$(shell find ci -name 'Dockerfile.*' | sed 's/ci\/Dockerfile\.\(.*\)/\1/')
IMG_CI:=${IMG_CI}

.PHONY: all ci push pull build clean
all: ci
ci: ${IMG_CI:%=ci-run-%}
run: run-latest
push: ci-push img-push-latest
pull: ci-pull img-pull-latest
build: ci-build img-build-latest
clean: ci-clean img-clean-latest

ci-push-%: ci-build-%
	docker push "${DOCKER_REPO_CI}:${@:ci-push-%=%}"

ci-push: ${IMG_CI:%=ci-push-%}
ci-push-%: ci-build-%
	docker push "${DOCKER_REPO_CI}:${@:ci-push-%=%}"

ci-pull-%:
	docker pull "${DOCKER_REPO_CI}:${@:ci-pull-%=%}"

ci-build: ${IMG_CI:%=ci-build-%}
ci-build-%:
	docker build \
		-t "${DOCKER_REPO_CI}:${@:ci-build-%=%}" \
		-f ci/Dockerfile.${@:ci-build-%=%} \
		ci

ci-run-%: ci-${DOCKER_TECHNIQUE}-%
	$(eval RAND := $(shell date +%s))

	[ -e "${REPO}" ]

	docker run \
		--rm \
		--hostname "${@:ci-run-%=%}" \
		-v "$(shell readlink -f ${REPO}):/dunstrepo" \
		-e CC \
		-e CFLAGS \
		"${DOCKER_REPO_CI}:${@:ci-run-%=%}" \
		"/dunstrepo" \
		"/srv/dunstrepo-${RAND}" \
		"/srv/${RAND}-install"

ci-clean: ${IMG_CI:%=ci-clean-%}
ci-clean-%:
	-docker image rm "${DOCKER_REPO_CI}:${@:ci-clean-%=%}"

img-push-%: img-build-%
	docker push "${DOCKER_REPO}:${@:img-push-%=%}"

img-pull-%:
	docker pull "${DOCKER_REPO}:${@:img-pull-%=%}"

img-build-latest:
	docker build \
		-t "${DOCKER_REPO}" \
		.

run: run-latest
run-%: img-${DOCKER_TECHNIQUE}-%
	@[ -n "${DBUS_SESSION_BUS_ADDRESS}" ] \
		|| ( echo '$DBUS_SESSION_BUS_ADDRESS missing' && exit 1)
	@[ -n "${DISPLAY}" ] \
		|| ( echo '\$DISPLAY missing' && exit 1)
	@[ -f "${DUNSTRC}" ] \
		|| (echo 'Please create a dunstrc in "${DUNSTRC}"' && exit 1)

	$(eval XAUTH := $(shell mktemp))
	$(eval DBUS_PATH:=$(shell echo ${DBUS_SESSION_BUS_ADDRESS} | cut -d = -f 2))

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
		--volume=${DUNSTRC}:/tmp/dunstrc:ro \
		--volume=/usr/share/icons:/usr/share/icons:ro \
		--volume=/usr/share/fonts:/usr/share/fonts:ro \
		"${DOCKER_REPO}:${@:run-%=%}" ${DUNST_ARGS}

	rm ${XAUTH}

img-clean-%:
	-docker image rm "${DOCKER_REPO}:${@:img-clean-%=%}"
