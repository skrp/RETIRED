#!/usr/local/bin/perl
use strict; use warnings;
# unix or you a bitch-button-smash-hack hacker
########################################################
#                HIVE OVER NFS                         #
# bobby          t_'(o_0)"'      daemon summons scroll #
#                                                      #
# check immutable file shas                            #
########################################################
use Digest::SHA 'sha256_hex';
use POSIX;
use Sys::Hostname 'hostname';
use File::Path;
use File::Copy 'move';
########################################################
# DATA LOCATIONS ###############################
# HOST --------------------
# /tmp/$NAME_dump/:    host work dir
# /tmp/PING       :    host PID roster
# NFS ---------------------
# /HIVE/          :    nfs mount
# /HIVE/TODO/     :    nfs node-workdir
# /HIVE/FEED/     :    nfs project dir
# example: /HIVE/FEED/archive/
#                      $FEED/ALL  = all iterations
#                      $FEED/DONE = success list
#                      $FEED/FAIL = failure list
#                      $FEED/QUE/ = que dump
# /HIVE/BIO/      :    nfs logs
#                      RAW_$NAME  = daemon diary 
# DUMPSITE ----------------
# /$DUMPPATH/pool/ :   data dump
# /$DUMPPATH/g/    :   metadata dump
########################################################
my ($DUMPPATH) = @ARGV;
die "ARG1 dump-site" if (!defined $DUMP);
$DUMPPATH =~ s?$?/? if (substr($DUMPPATH, -1, 1) ne "/");
# BIRTH ################################################
die "STILLBORN" if ((my $birth = daemon()) != 0);
# PREP @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
$DUMPPATH =~ s?$?/? if (substr($DUMPPATH, -1, 1) ne "/");
# HOST VARIABLES ----------
my $HOST = hostname(); chomp $HOST;
my $NAME = name();
my $DUMP = '/tmp/'.$NAME.'_dump/'; # unique process hostside dump
my $HOSTPING = '/tmp/PING';
# NET VARIABLES -----------
my $NFSPATH = '/usr/nfs/HIVE/';
my $BIO = $NFSPATH.'BIO/'; # DEMON logs
my $TPATH = '/HIVE/TODO/'; # current DEMONS
# LOG VARIABLES -----------
my $RAW = $BIO.$NAME; # output
my $TODO = $TPATH.$NAME; # leftovers that need to be put back in $FEED
my $DONE = $RAW.'DONE_'.$NAME; # successful iterations
my $FAIL = $RAW.'FAIL_'.$NAME; # failed iterations that need to be cleaned up
# CONTROL VARIABLES -------
my $SLEEP = $TPATH.'SLEEP_'.$NAME; # triggers sleep
# DEMON VARIABLES ---------
my $BIRTH = age();
my $RATE = 100;
# GLOBALS -----------------
my $YAY = 0; # total sucesses
my $FA = 0;  # total failures
$SIG{INT} = \&SUICIDE;
# OUTPUT ------------------
open(my $Lfh, '>>', $RAW); $Lfh->autoflush(1); 
open(my $FAILfh, '>>', $FAIL); $FAILfh->autoflush(1); 
open(my $DONEfh, '>>', $DONE); $DONEfh->autoflush(1);
# PREP --------------------
chdir('/tmp/');
unless (mkdir $DUMP)
	{ print $Lfh "cant create dump $DUMP \n"; exit; }

h_ping(); # host roster
printf $Lfh ("HELLOWORLD %s\n", TIME());

# LIVE &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
while (1)
{
  SLEEP($count, $ttl, @QUE) if (-e $SLEEP);
  work();
  tombstone($count, $ttl) if ($count % $RATE == 0);
  sleep 100000;
  $count++;
}
# LOGIC ///////////////////////////////////////////////
sub work
{
  my %list;
  my $list = '~/immute_LIST';
  open(my $fh, '<', $list);

  my @files = readline $fh; 
  close $fh; chomp @files;
  
  for (@files)
  {
    my @i = split(' ', $_);
    $list{$i[0]}=$i[1];
  }

  for (keys %list}
  {
    my $isha = sha($_);
    print FAILfh "FAIL $_ $isha != $list{$_}\n"  unless ($isha eq $list{$_}); 
  }
}
sub sha
{
  my ($file) = @_;
  my $digester = Digest::SHA->new('sha256');
  $digester->addfile( $file, 'b' );
  return $digester->hexdigest;
}
# CORE SUBS ////////////////////////////////////////////
sub daemon 
{
 	die "FAIL daemon1 $!\n" if ((my $pid = fork()) < 0);
   	if ($pid != 0)
   		{ exit(0); }
   	POSIX::setsid() or die "FAIL setsid $!";
   	die "FAIL daemon2 $!\n" if ((my $pid2 = fork()) < 0);
  	if ($pid2 != 0)
   		{ exit(0); }
	chdir('/tmp');
   	umask 0;
   	my $fds = 3;
  	while ($fds < 1024)
   	 	{ POSIX::close($fds); $fds++;  }
   	my $des = '/dev/null';
   	open(STDIN, "<$des");
   	open(STDOUT, ">$des");
   	open(STDERR, ">$des");
   	return 0;
}
# CONTROL -----------------
sub SUICIDE
{
	my ($count, $ttl, @QUE) = @_;
	my $curTIME = TIME();
	printf $Lfh "$curTIME FKTHEWORLD\n";
	tombstone($count, $ttl);
	que_flush(@QUE);
	move($TODO, $QPATH);
	exit;
}
sub SLEEP
{
	my ($count, $ttl, @QUE) = @_;
	open(my $Sfh, '<', $SLEEP);
	my $timeout = readline $Sfh; chomp $timeout;
	my $curTIME = TIME();
	print $Lfh "$curTIME SLEEP $timeout\n";
	close $Sfh; unlink $SLEEP;
	SUICIDE($count, $ttl, @QUE) if ($timeout eq "SUICIDE");
	tombstone($count, $ttl);
	sleep $timeout;
}
# REPORT ------------------
sub name
{
	my $id = int(rand(999));
	my $name = $HOST.'_'.$id.'_'.$$;
	return $name;
}
sub tombstone
{
	my ($count, $ttl) = @_;

	my $Ttime = age();
	my $Ntime = TIME();
	my $life = "$BIRTH $Ttime";

	print $Lfh "$Ntime  yay: $YAY   name: $NAME  age: $life  fails: $FA\n";
}
sub h_ping
{
  open(my $Pfh, '>>', $HOSTPING);
  my $curTIME = TIME();
  printf $Pfh "$curTIME $$\n";
  close $Pfh;
}
sub age
{
  my $age = localtime();
  $age =~ s/..........20..//;
  $age =~ s/^....//;
  $age =~ s/ /_/;
  return $age;
}
sub TIME
{
  my $t = localtime;
  my $mon = (split(/\s+/, $t))[1];
  my $day = (split(/\s+/, $t))[2];
  my $hour = (split(/\s+/, $t))[3];
  my $time = $mon.'_'.$day.'_'.$hour;
  return $time;
}
