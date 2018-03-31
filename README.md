# dunst-docker

Dockerimages for dunst. Mainly used for testing. **Except for alpine. You can use this, too**

# Usage

Use `make` for this and point the `REPO` variable to your repository.

A make without a target will build all dev images by default and run the testsuite.

To test dunst in a specific image, use `make test-<image>`.

Example: `make REPO=../dunst.git test-alpine`

# Images

- Alpine Latest ([`alpine`](./alpine))
- Fedora 27 ([`fedora27`](./fedora27))
- Ubuntu 14.04 ([`ubuntu-trusty`](./ubuntu-trusty))

CentOS is not supported, as [basic libraries are missing on CentOS](https://unix.stackexchange.com/questions/115304/dunst-notifier-on-centos).
