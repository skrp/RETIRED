#!/usr/local/bin/perl
use strict; use warnings;
#############################
# VULTR - scrape minion dumps
# chronic
my ($pool, $dir) = @ARGV;
my @minions = `ls $dir`;
foreach my $minion (@minions) {
#  open(my $mfh, '<', $dir/$minion/LOG);
#  my @set;
#  my @preset = readline $mfh; chomp @preset; close $mfh;
#  foreach (@preset) {
#    if (/ ended$/)
#      { $_ =~ s/ ended$//); my $file = "$dir/$minion/dump/$_"; push @set, $file; }
#  }
  foreach my $i (@set) {
    my $sha = XS1($i);
    if (-e $pool/pool/$sha && -e $pool/g/g$sha)
      { unlink $i; }
    else { print $log "$i XS1 FAIL\n"; }
  }
  open(my $mfh, '>1', $dir/$minion/LOG);
  my @new
}
sub XS1 {
  my $i = shift;
}
