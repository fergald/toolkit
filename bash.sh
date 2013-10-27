DIR=~/toolkit/bash/
for f in $(run-parts --list $DIR); do
  . $f
done

if [[ -x ~/.local_bash.sh ]]; then
  . ~/.local_bash.sh
fi
