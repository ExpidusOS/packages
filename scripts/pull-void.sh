#!/usr/bin/env bash

set -e
srcdir=$(dirname $(dirname $0))
rm -rf "$basedir"

cd "$srcdir"

if git rev-parse --verify merging; then
	echo ">> Removing stale branch"
	git branch -d merging
fi

if ! git remote | grep voidpackages; then
	echo ">> Adding remote voidpackages"
	git remote add voidpackages https://github.com/void-linux/void-packages
fi

git checkout master
masterpkglist=($(ls -d srcpkgs/*))

git fetch --all
git checkout -b origin/merging voidpackages/master

for dir in srcpkgs/*; do
	pkgname=$(basename "$dir")
	if ! echo "${masterpkglist[@]}" | grep "$pkgname" >/dev/null; then
		rm -rf "$dir"
	else
		echo ">> Keeping package $pkgname"
	fi
done

git add -A
git commit -a -m "Merged Void Linux packages (automated)"
git checkout master
git branch -d merging
