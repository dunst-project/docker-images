# Default flags
XSOCK?=/tmp/.X11-unix
DUNSTRC=${HOME}/.config/dunst/dunstrc
DOCKER_REPO?=dunst/dunst
DOCKER_REPO_CI?=dunst/ci
DOCKER_TECHNIQUE?=build
REPO=./dunst
CFLAGS?=-Werror
DOCKER_TARGETS?=all dunstify test-valgrind install

# Structure of the makefile
#
# We have generic targets (run push pull build clean), wich
# depend on the image's specific target
#
# Every docker image flavor has a unique name. It is used as
# the docker repository's tag and the tag is encoded in the
# target's name, whenever the target is image-specific.
#
# Every target is constructed by `ci-<action>-<flavor>`,
# which actually build/pull/run the single docker image.
#
# The image names for the flavors are found in the variable
# IMG_CI, which is automatically filled (if unset) by the
# Dockerfiles in the ci folder.

IMG_CI?=$(shell find ci -name 'Dockerfile.*' | sed 's/ci\/Dockerfile\.\(.*\)/\1/')
# force make to execute the find call only once
IMG_CI:=${IMG_CI}

.PHONY: all ci push pull build clean
all: ci
ci: ci-run
run: ci-run
push: ci-push
pull: ci-pull
build: ci-build
clean: ci-clean

# Push all images to docker hub
ci-push: ${IMG_CI:%=ci-push-%}
ci-push-%: ci-build-%
	docker push "${DOCKER_REPO_CI}:${@:ci-push-%=%}"

# Pull all images from docker hub
ci-pull: ${IMG_CI:%=ci-pull-%}
ci-pull-%:
	docker pull "${DOCKER_REPO_CI}:${@:ci-pull-%=%}"

# Build all images locally from the git repository
ci-build: ${IMG_CI:%=ci-build-%}
ci-build-%:
	docker build \
		-t "${DOCKER_REPO_CI}:${@:ci-build-%=%}" \
		-f ci/Dockerfile.${@:ci-build-%=%} \
		ci

# Run the CI scripts on different distros
# This requires the docker images to be locally on the machine
# with the variable DOCKER_TECHNIQUE=(pull|build) you can define,
# if the images will get built or pulled before
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

# Remove the images from your local docker machine
ci-clean: ${IMG_CI:%=ci-clean-%}
ci-clean-%:
	-docker image rm "${DOCKER_REPO_CI}:${@:ci-clean-%=%}"
