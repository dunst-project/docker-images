# dunst-docker

Dockerimages for dunst. Used for testing or running in a super small Alpine image.

# Running

Please clone the git repository and run make in there. Many flags have to get triggered to run dunst inside docker.

```
git clone https://github.com/dunst-project/docker-images dunst-docker
cd dunst-docker
make run
```

If you want to have a specific version, use `make run-<versiontag>` to run the specific version.

# Usage

Use `make` for this and point the `REPO` variable to your repository. So a `make -j REPO=code/to/dunst` will do:

- do a complete build for all images
- **copy** the repo into the container (you local repo stays untouched)
- execute the tests in the docker image

If you do not want to build the images, but download the prebuilt ones from dockerhub, add the variable `DOCKER_TECHNIQUE=pull` to your make call.

If you do not use docker but a replacement (with compatible CLI; e.g. [podman](https://github.com/containers/podman)), add the variable `DOCKER=podman` to your make call.

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
- Debian Bookworm (`debian-bookworm`)
- Debian Bullseye (`debian-bullseye`)
- Debian Buster (`debian-buster`)
- Fedora 30 (`fedora30`)
- Ubuntu 16.04 (`ubuntu-xenial`)
- Ubuntu 18.04 (`ubuntu-bionic`)
- Ubuntu 20.04 (`ubuntu-focal`)

CentOS is not supported, as [basic libraries are missing on CentOS](https://unix.stackexchange.com/questions/115304/dunst-notifier-on-centos).

# Adding new images

- Add your new `Dockerfile.<name>` in [`./ci/`](./ci) folder.
- Edit the [build settings of the project](https://hub.docker.com/repository/docker/dunst/ci/builds/edit) to have a mapping from `Dockerfile.<name>` to `dunst-project/ci:<name>`.
- In the [GitHub Action workflow](https://github.com/dunst-project/dunst/blob/master/.github/workflows/main.yml) of the main dunst project, add the new tag names in the matrix.
