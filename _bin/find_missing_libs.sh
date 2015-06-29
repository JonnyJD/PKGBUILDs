#!/bin/bash

ldd_check() {
	output=`ldd $1 2> /dev/null | grep "not found"`
	if [ -n "$output" ]; then
		pkg=`pacman -Qoq $1`
		echo "$1 ($pkg)"
		echo "$output"
	fi
}

if [ -n "$1" ]; then
	ldd_check $1
	if [ -z "$output" ]; then
		echo everything fine with $1
		exit 0
	else
		exit -1
	fi
fi

echo
echo "running testdb.."
echo
testdb
echo

echo "checking 32 bit libraries.."
echo
for lib in /usr/lib32/*.so; do
	ldd_check $lib
done
echo

echo "checking libraries.."
echo
for lib in /usr/lib/*.so; do
	ldd_check $lib
done
echo

echo "checking binaries.."
echo
for bin in /usr/bin/*; do
	ldd_check $bin
done
echo
