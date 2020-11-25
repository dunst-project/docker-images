#!/bin/sh

set -eu

# We want to build the code independent of our given source
# as other simultaneously running build containers could compete
cp -r "${DIR_REPO}" "${DIR_BUILD}"
make -C "${DIR_BUILD}" clean

if [ "${DUNST_DOCS_ONLY:-}" = "true" ]; then
	make -C "${DIR_BUILD}" -j doc-doxygen
else
	make -C "${DIR_BUILD}" -j ${TARGETS}

	if [ -x "${DIR_BUILD}/test/test-install.sh" ]; then
		"${DIR_BUILD}/test/test-install.sh"
	fi
fi
