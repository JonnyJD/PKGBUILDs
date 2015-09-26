#!/bin/bash

if [ $# -lt 1 -o \( "$1" = "-h" -o "$1" = "--help" \) ]; then
	echo "usage: $0 <path/to/package>"
	echo "(has to be started from root of the existing repository)"
	exit -1
fi

prefix=$1
pkg=`basename $prefix`
gitignore=`pwd`/gitignore.pkg

# create a new repository only for $pkg in the branch aur4/$pkg
echo git subtree split --prefix=\"$prefix\" -b aur4/$pkg
git subtree split --prefix="$prefix" -b aur4/$pkg || exit -1

# add/update .gitignore and .SRCINFO for every commit in the new branch
echo git filter-branch -f --tree-filter \
	\"cp $gitignore .gitignore\; mksrcinfo\" -- aur4/$pkg
git filter-branch -f --tree-filter "cat $gitignore >> .gitignore; mksrcinfo" \
	-- aur4/$pkg || exit -1


# allowing a (manual) rebase (OPTIONAL)
echo starting shell to inspect and/or rebase the branch
git checkout aur4/$pkg || exit -1
echo '(exit with "exit")'
bash --init-file <(echo "gitk &")
git checkout master

# reset committer date, because that is used in the AUR changes
echo git filter-branch -f --env-filter \
	'export GIT_COMMITTER_DATE=$GIT_AUTHOR_DATE' -- aur4/$pkg
git filter-branch -f --env-filter \
	'export GIT_COMMITTER_DATE=$GIT_AUTHOR_DATE' -- aur4/$pkg || exit -1


# push the new branch to the repo on AUR 4
echo git push ssh+git://aur@aur4.archlinux.org/${pkg}.git/ aur4/$pkg:master
git push --set-upstream ssh+git://aur@aur4.archlinux.org/${pkg}.git/ aur4/$pkg:master \
	|| exit -1

# delete the temporary branch
# the AUR 4 repository can be added as a submodule, see aur4_make_submodule.sh
echo git branch -D aur4/$pkg
git branch -D aur4/$pkg
