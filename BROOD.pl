#!/usr/local/bin/perl
use strict; use warnings;
use Proc::Daemon; use POSIX qw(mkfifo);
#######################################
# BROOD - daemon birth mother
# she lives to brood young
# the young live to build brood
# each reign a constant power range
# SETUP ###############################
my $dir = '/tmp/'; chdir $dir; #
my $work = '.';
# FILES
my $BUG = 'BROOD_BUG'; my $LOG = 'BROOD_LOG'; my $pid = 'BROOD_PID';
my $SLEEP = 'BROOD_SLEEP'; my $SUICIDE = 'BROOD_SUICIDE';
# DAEMONIZE ##########################
my $daemon = Proc::Daemon->new(
    work_dir     => $work,
    child_STDOUT => "+>>$LOG",
    child_STDERR => "+>>$BUG",
    pid_file     => $pid,
);
$daemon->Init();
# INIT ###############################
#my $WORD = 'WBROOD'; mkfifo($WORD, 0770) or die "mkfifo WORD fail\n"; # wrapped code location
#open(my $FWfh, '<', $WORD) or die "cant open WORD\n";
#my $POST = 'RBROOD'; mkfifo($POST, 0770) or die "mkfifo POST fail\n"; # $btime
#open(my $FPfh, '<', $POST) or die "cant open POST\n";
while(1)
{
  my $code = <$WORD>; chomp $code;
  if (not defined $code)
    { sleep 600; next; }
# SETUP ###############################
  my @set = ("A".."Z", "a".."z", "1".."9");
  my $id = $chars[rand @chars] for 1..8;
# BIRTH ###############################
  my $embryo = Proc::Daemon->new(
    work_dir => $home,
    child_STDOUT => "+>>$LOG",
    child_STDERR => "+>>$BUG",
    pid_file => $pid,
    exec_command => "DEMON.pl $id $id.'_que'",
  );
  $embryo->Init() or die "STILLBORN\n";
  my $btime = TIME(); print $FPfh "$set_name $btime\n";
}
# FN ################################
sub TIME
{
  my $t = localtime;
  my $mon = (split(/\s+/, $t))[1];
  my $day = (split(/\s+/, $t))[2];
  my $hour = (split(/\s+/, $t))[3];
  my $time = $mon.'_'.$day.'_'.$hour;
  return $time;
}
