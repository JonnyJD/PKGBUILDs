#!/bin/bash

if [ "$1" = "-h" -o "$1" = "--help" ]; then
	echo "usage: $0"
	echo "(should be done in root of the original repository)"
	exit -1
fi

for path in `find . -name PKGBUILD`; do
	path=${path#./}
	path=${path%/PKGBUILD}

	slash_path=${path//[^\/]}
	dir_depth=${#slash_path} # number of slashes in path

	pushd .git/modules/$path/hooks/ > /dev/null 2>&1 || continue

	echo $path
	echo $dir_depth

	# add more .. for deeper paths
	more_dots=""
	for i in $(seq 1 $dir_depth); do
		more_dots+="../"
	done

	ln -s -f ../../../../${more_dots}pre-commit.pkg pre-commit

	popd > /dev/null
done

