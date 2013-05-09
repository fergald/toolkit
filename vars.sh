date >> /tmp/all
DIR=~/toolkit/vars/
for f in $(run-parts --list $DIR); do
  . $f
done
