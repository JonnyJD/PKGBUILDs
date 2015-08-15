#!/bin/bash

if [ $# -lt 1 -o \( "$1" = "-h" -o "$1" = "--help" \) ]; then
	echo "usage: $0 <path/to/package>"
	echo "(should be done in root of the original repository)"
	exit -1
fi

path=${1%/}		# the trailing / is removed
pkg=`basename $path`
email=`git config user.email`
slash_path=${path//[^\/]}
dir_depth=${#slash_path} # number of slashes in path

# add the AUR 4 package as a submodule at the previous path
echo git submodule add ssh+git://aur@aur.archlinux.org/${pkg}.git $path
git submodule add https://aur@aur.archlinux.org/${pkg}.git $path


# add a separate pushurl for write access
# (OPTIONAL, you can also just use this url above)
# (we need to be in the root of the repository to find .gitmodules)
echo git config --file=.git/modules/$path/config remote.origin.pushurl \
	ssh+git://aur@aur.archlinux.org/${pkg}.git $path
git config --file=.git/modules/$path/config remote.origin.pushurl \
	ssh+git://aur@aur.archlinux.org/${pkg}.git $path


# add mksrcinfo as pre-commit hook (OPTIONAL)

echo pushd .git/modules/$path/hooks/
pushd .git/modules/$path/hooks/

# add more .. for deeper paths
more_dots=""
for i in $(seq 1 $dir_depth); do
	more_dots+="../"
done

echo ln -s ../../../../${more_dots}pre-commit.pkg pre-commit
ln -s ../../../../${more_dots}pre-commit.pkg pre-commit

echo popd
popd


# change to new submodule
echo pushd ${path}
pushd ${path}

  # set same commit email as for the original repository (OPTIONAL)
  echo git config user.email $email
  git config user.email $email

# return to original directory
echo popd
popd
