# dunst-docker

Dockerimages for dunst. Mainly used for testing.

# Usage

Use `make` for this and point the `REPO` variable to your repository. So a `make -j REPO=code/to/dunst` will do:

- do a complete build for all images
- **copy** the repo into the container (you local repo stays untouched)
- execute the tests in the docker image

If you do not want to build the images, but download the prebuilt ones from dockerhub, add the variable `DOCKER_TECHNIQUE=pull` to your make call.

To test dunst in a specific image, use `make ci-run-<image>`.

Example: `make REPO=../dunst.git ci-run-alpine`

# Other make targets

- `ci-pull`: Download all images from Docker Hub
- `ci-push`: Push the local images to Docker Hub
- `ci-build`: Build all docker images locally
- `ci-clean`: Remove all local docker images

# Images

- ArchLinux Latest (`archlinux`)
- Alpine Latest (`alpine`)
- Debian Stretch (`debian-stretch`)
- Fedora 30 (`fedora30`)
- Ubuntu 14.04 (`ubuntu-trusty`)
- Ubuntu 16.04 (`ubuntu-xenial`)
- Ubuntu 18.04 (`ubuntu-bionic`)

CentOS is not supported, as [basic libraries are missing on CentOS](https://unix.stackexchange.com/questions/115304/dunst-notifier-on-centos).
