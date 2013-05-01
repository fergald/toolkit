#! /usr/bin/python

import os
import sys

def ReadLinks(filename):
  for line in file(filename):
    line = line.strip()
    if not line:
      continue
    src, dest = line.split(" ")
    yield src, dest


def GetDots(dirname):
  for filename in sorted(os.listdir(dirname)):
    if filename.startswith("."):
      continue
    yield os.path.join(dirname, filename), "." + filename


def MakeLinks(homedir, tooldir, links):
  for src, dest in links:
    full_dest = os.path.join(homedir, dest)
    if not os.path.islink(full_dest) and os.path.exists(full_dest):
      raise "%s exists but is not a link" % full_dest
    else:
      os.remove(full_dest)
    full_src = os.path.join(tooldir, src)
    print "link %r %r" % (full_src, full_dest)
    os.symlink(full_src, full_dest)


def main(args):
  if len(args) < 2:
    raise "Must supply a home dir."
  homedir = args[1]
  tooldir = os.path.abspath(os.path.join(homedir, "toolkit"))
  MakeLinks(homedir, tooldir, GetDots(os.path.join(tooldir, "dots")))
  MakeLinks(homedir, tooldir, ReadLinks("LINKS"))


if __name__ == "__main__":
  main(sys.argv)
