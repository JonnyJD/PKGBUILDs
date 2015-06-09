if [ $# -lt 1 -o \( "$1" = "-h" -o "$1" = "--help" \) ]; then
	echo "usage: $0 <path/to/project>"
	exit -1
fi

path=$1
pkg=`basename $path`
email=`git config user.email`

echo git rm -r \"$path\"
git rm -r "$path"

echo mv \"$path\" \"${pkg}_aur4_bak\"
mv "$path" "${pkg}_aur4_bak"

echo git submodule add ssh+git://aur@aur4.archlinux.org/${pkg}.git $path
git submodule add ssh+git://aur@aur4.archlinux.org/${pkg}.git $path

echo cp -r \"${pkg}_aur4_bak/\"* \"$path\"
cp -r "${pkg}_aur4_bak/"* "$path"

echo rm -rf \"${pkg}_aur4_bak/\"
rm -rf "${pkg}_aur4_bak"

echo pushd ${path}
pushd ${path}

  echo git config user.email $email
  git config user.email $email

echo popd
popd
