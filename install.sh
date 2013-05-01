#! /bin/bash -e

if [ $# -gt 0 ]; then
		DESTDIR=$1
		shift
else
		DESTDIR="$HOME/toolkit"
fi
echo Installing to $DESTDIR. Hit enter to delete.
read f
rm -rf "$DESTDIR"
rsync -avr $(cat MANIFEST) $DESTDIR/
