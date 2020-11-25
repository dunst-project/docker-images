XSOCK?=/tmp/.X11-unix
DUNSTRC=${HOME}/.config/dunst/dunstrc
DOCKER_REPO?=dunst/dunst
DOCKER_REPO_CI?=dunst/ci
DOCKER_TECHNIQUE?=build
REPO=./dunst
CFLAGS?=-Werror
DOCKER_TARGETS?=all dunstify test-valgrind install

IMG_CI?=$(shell find ci -name 'Dockerfile.*' | sed 's/ci\/Dockerfile\.\(.*\)/\1/')
IMG_CI:=${IMG_CI}

.PHONY: all ci push pull build clean
all: ci
ci: ci-run
run: ci-run
push: ci-push
pull: ci-pull
build: ci-build
clean: ci-clean

ci-push: ${IMG_CI:%=ci-push-%}
ci-push-%: ci-build-%
	docker push "${DOCKER_REPO_CI}:${@:ci-push-%=%}"

ci-pull: ${IMG_CI:%=ci-pull-%}
ci-pull-%:
	docker pull "${DOCKER_REPO_CI}:${@:ci-pull-%=%}"

ci-build: ${IMG_CI:%=ci-build-%}
ci-build-%:
	docker build \
		-t "${DOCKER_REPO_CI}:${@:ci-build-%=%}" \
		-f ci/Dockerfile.${@:ci-build-%=%} \
		ci

ci-run: ${IMG_CI:%=ci-run-%}
ci-run-%: ci-${DOCKER_TECHNIQUE}-%
	$(eval RAND := $(shell date +%s))

	[ -e "${REPO}" ]

	docker run \
		--rm \
		--hostname "${@:ci-run-%=%}" \
		-v "$(shell readlink -f ${REPO}):/dunstrepo" \
		-e DIR_REPO="/dunstrepo" \
		-e DIR_BUILD="/srv/dunstrepo-${RAND}" \
		-e PREFIX="/srv/${RAND}-install" \
		-e TARGETS="${DOCKER_TARGETS}" \
		-e CC="${CC}" \
		-e CFLAGS="${CFLAGS}" \
		"${DOCKER_REPO_CI}:${@:ci-run-%=%}"

ci-clean: ${IMG_CI:%=ci-clean-%}
ci-clean-%:
	-docker image rm "${DOCKER_REPO_CI}:${@:ci-clean-%=%}"
