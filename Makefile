all: $(shell find * -name Dockerfile -printf 'img-%h\n')

img-%:
	docker build \
		-t dunst:${@:img-%=%} \
		-f ${@:img-%=%}/Dockerfile \
		.
