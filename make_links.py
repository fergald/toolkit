#! /usr/bin/python

import os
import sys

class Error(Exception):
  """Base class for exceptions."""


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


def FindLinks(dirname):
  links = []
  def HandleDir(arg, sub_dirname, fnames):
    for fname in fnames:
      src = os.path.join(sub_dirname, fname)
      if os.path.isdir(src):
        return
      links.append(
        (src,
         os.path.join(os.path.relpath(sub_dirname, dirname), fname)))

  os.path.walk(dirname, HandleDir, None)
  return links


def MakeLinks(homedir, tooldir, links):
  for src, dest in links:
    full_dest = os.path.join(homedir, dest)
    full_src = os.path.join(tooldir, src)
    dest_dir =  os.path.dirname(full_dest)
    if not os.path.exists(dest_dir):
      os.makedirs(dest_dir)
    if os.path.lexists(full_dest):
      if os.path.realpath(full_dest) == os.path.realpath(full_src):
        print "already link %r %r" % (full_src, full_dest)
      else:
        raise Error("%s exists but is not a link" % full_dest)
    else:
      print "link %r %r" % (full_src, full_dest)
      os.symlink(full_src, full_dest)


def main(args):
  if len(args) < 2:
    raise Error("Must supply a home dir.")
  homedir = args[1]
  tooldir = os.path.abspath(os.path.join(homedir, "toolkit"))

  MakeLinks(homedir, tooldir, GetDots(os.path.join(tooldir, "dots")))
  MakeLinks(homedir, tooldir, ReadLinks("LINKS"))
  MakeLinks(homedir, tooldir, FindLinks(os.path.join(tooldir, "links")))


if __name__ == "__main__":
  main(sys.argv)
