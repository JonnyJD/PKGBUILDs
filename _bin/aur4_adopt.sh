#!/bin/bash

if [ $# -lt 1 -o \( "$1" = "-h" -o "$1" = "--help" \) ]; then
	echo "usage: $0 <repository> [<target>]"
	echo "(should be done in root of the original repository)"
	exit -1
fi

repo=$1
path=${2%/}		# the trailing / is removed
pkg=`basename $path`
email=`git config user.email`
slash_path=${path//[^\/]}
dir_depth=${#slash_path} # number of slashes in path

# add the AUR 4 package as a submodule at the previous path
echo git submodule add $repo $path
git submodule add $repo $path


# add a separate pushurl for write access
# (OPTIONAL, you can also just use the url above)

# (we need to be in the root of the repository to find .gitmodules)
#echo git config --file=.gitmodules submodule.${path}.pushurl \
#	ssh+git://aur@aur4.archlinux.org/${pkg}.git $path
#git config --file=.gitmodules submodule.${path}.pushurl \
#	ssh+git://aur@aur4.archlinux.org/${pkg}.git $path

# write urls from .gitmodules to separate .git/modules/*/config files
#echo git submodule sync
#git submodule sync

# mark changes in .gitmodules to be committed
#echo git add .gitmodules
#git add .gitmodules


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
