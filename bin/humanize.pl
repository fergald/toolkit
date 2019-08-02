#! /usr/bin/perl -lp

my @SUFFIXES = split("", "kMGTEPZY");

sub human {
  my $num = shift;
  my $s = -1;
  while (($num >= 1000) and ($s < $#SUFFIXES)) {
    $num = int($num) / 1000;
    $s++;
  }
  my $suffix = $s == -1 ? "" : $SUFFIXES[$s];
  my $num = sprintf("%.1f", $num).$suffix;
  $num =~ s/\.?0+$//;
  return $num;
}

# Apply to any stand-alone numbers.
s/(((?<=\s)|^)\d+(?=\s|$))/human($1)/ge;
