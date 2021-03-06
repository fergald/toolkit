#! /usr/bin/perl

# first arg is an optional factor to multiply everything by, e.g. if the inputs
# are already in 1024 blocks.

use strict;
use warnings;

my $FACTOR = shift || 1;

my @SUFFIXES = split("", "kMGTEPZY");

sub human {
  my $num = shift() * $FACTOR;
  my $s = -1;
  while (($num >= 1000) and ($s < $#SUFFIXES)) {
    $num = int($num) / 1000;
    $s++;
  }
  my $suffix = $s == -1 ? "" : $SUFFIXES[$s];
  $num = sprintf("%.1f", $num).$suffix;
  $num =~ s/\.?0+$//;
  return $num;
}

while (<>) {
  # Apply to any stand-alone numbers.
  s/(((?<=\s)|^)\d+(?=\s|$))/human($1)/ge;
} continue {
  print or die "-p destination: $!\n";
}
