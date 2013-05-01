#! /bin/bash

if [ $# -gt 0 ]; then
		DEST=$1
		shift
else
		DEST="$HOME/toolkit"
fi
echo Installing to $DEST. Hit enter to delete.
read f
rm -rf "$DEST"
rsync -avr $(cat MANIFEST) $DEST/
