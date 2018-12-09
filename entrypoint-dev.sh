#!/bin/sh

set -eu

echo "${@}"

DIR_REPO="${1}"
DIR_BUILD="${2}"
DIR_INST="${3}"

# We want to build the code independent of our given source
# as other simultaneously running build containers could compete
cp -r "${DIR_REPO}" "${DIR_BUILD}"

export PREFIX="${DIR_INST}"
export CFLAGS='-Werror'

make -C "${DIR_BUILD}" clean
make -C "${DIR_BUILD}" -j all dunstify test-valgrind
make -C "${DIR_BUILD}" -j install
