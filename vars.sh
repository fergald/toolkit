DIR=~/toolkit/vars/
for f in $(run-parts --list $DIR); do
  . $f
done

if [[ -x ~/.local_vars.sh ]]; then
  . ~/.local_vars.sh
fi
