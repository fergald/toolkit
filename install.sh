#! /bin/bash -xe

if [ $# -gt 0 ]; then
		home=$1
		shift
else
		home="$HOME"
fi
tooldir=$home/toolkit
echo Installing to $home. Hit enter to delete $tooldir
read f
rm -rf "$tooldir"
rsync --delete-after -avr $(cat MANIFEST) $tooldir/
./make_links.py $home
git log -n 1 --format="format:%H%n" > $tooldir/version
