#!/usr/bin/env bash

set -e
srcdir=$(dirname $(dirname $0))
rm -rf "$basedir"

cd "$srcdir"

if git rev-parse --verify merging; then
	echo ">> Removing stale branch"
	git branch -d merging
fi

git checkout -b master
masterpkglist=($(ls -d srcpkgs/*))

git checkout -b merging
git fetch voidpackages
git checkout -b origin/merging voidpackages/master

for dir in srcpkgs/*; do
	pkgname=$(basename "$dir")
	if ! echo "${masterpkglist[@]}" | grep "$pkgname" >/dev/null; then
		echo ">> Removing unneeded package $pkgname"
		rm -rf "$dir"
	fi
done

git add -A
git commit -a -m "Merged Void Linux packages (automated)"
git checkout -b master
git branch -d merging
