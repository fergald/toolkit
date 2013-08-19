DIR=~/toolkit/bash/
for f in $(run-parts --list $DIR); do
  . $f
done
