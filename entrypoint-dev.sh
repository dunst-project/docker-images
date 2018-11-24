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

# disable the double tests on Alpine, when running under valgrind
# Alpine is running with Musl libc and musl uses extended precision
# doubles, while valgrind can't handle extended precision
# so 2.3 == atof("2.3") won't be true under valgrind
#
# This only matches valgrind, because valgrind's test call is indented
# with two tabs. (While the normal test call is indented with one tab.)
if [ "${HOSTNAME}" == "alpine" ]; then
	sed -i \
		's/^\t\t.\/test\/test/& -x get_double/' \
		"${DIR_BUILD}/Makefile"
fi

make -C "${DIR_BUILD}" clean
make -C "${DIR_BUILD}" all dunstify test-valgrind
make -C "${DIR_BUILD}" install
