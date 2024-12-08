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

If you do not want to build the images, but download the prebuilt ones from Github Container Registry (ghcr.io), add the variable `DOCKER_TECHNIQUE=pull` to your make call.

If you do not use docker but a replacement (with compatible CLI; e.g. [podman](https://github.com/containers/podman)), add the variable `DOCKER=podman` to your make call.

To test dunst in a specific image, use `make ci-run-<image>`.

Example: `make REPO=../dunst.git ci-run-alpine`

# Other make targets

- `ci-pull`: Download all images from GitHub Package Registry
- `ci-build`: Build all docker images locally
- `ci-clean`: Remove all local docker images

# Images

- Alpine Latest (`alpine`)
- Alpine Edge (`alpine-edge`)
- ArchLinux Latest (`archlinux`)
- Debian Bookworm (`debian-bookworm`)
- Debian Bullseye (`debian-bullseye`)
- Debian Buster (`debian-buster`)
- Fedora 40 (`fedora40`)
- Ubuntu 20.04 (`ubuntu-focal`)
- Ubuntu 22.04 (`ubuntu-jammy`)
- Ubuntu 24.04 (`ubuntu-noble`)

CentOS is not supported, as [basic libraries are missing on CentOS](https://unix.stackexchange.com/questions/115304/dunst-notifier-on-centos).

# Adding new images

- Add your new `Dockerfile.<name>` in [`./ci/`](./ci) folder.
- Add the new `<name>` in the GitHub Actions matrix:
  - In the [GitHub Action workflow](.github/workflows/main.yml) of this project.
  - In the [GitHub Action workflow](https://github.com/dunst-project/dunst/blob/master/.github/workflows/main.yml) of the main dunst project
