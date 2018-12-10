#!/bin/sh

set -eu


# We want to build the code independent of our given source
# as other simultaneously running build containers could compete
cp -r "${DIR_REPO}" "${DIR_BUILD}"

make -C "${DIR_BUILD}" clean
make -C "${DIR_BUILD}" -j all dunstify test-valgrind
make -C "${DIR_BUILD}" -j install
