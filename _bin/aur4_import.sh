if [ $# -lt 1 -o \( "$1" = "-h" -o "$1" = "--help" \) ]; then
	echo "usage: $0 <path/to/project>"
	echo "(has to be started from root of the existing repository)"
	exit -1
fi

prefix=$1
pkg=`basename $prefix`
gitignore=`pwd`/gitignore-pkg

git subtree split --prefix="$prefix" -b aur4/$pkg || exit -1
git filter-branch -f --tree-filter "cp $gitignore .gitignore; mksrcinfo" \
	-- aur4/$pkg || exit -1

#ssh aur@aur4.archlinux.org setup-repo $pkg
git push ssh+git://aur@aur4.archlinux.org/${pkg}.git/ aur4/$pkg:master \
	|| exit -1
git branch -D aur4/$pkg
