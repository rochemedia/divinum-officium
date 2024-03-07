#!/usr/bin/perl
use strict;
use warnings;
use autodie;
$\ = "\n";

use Getopt::Long;
use FindBin;

my $verbose = 1;
my $trial = 1;
my $log = "$FindBin::Bin/log";
my $source = 'https://divinum-officium.googlecode.com/svn/tags/web';
my $target = '/home1/lzkissne/public_html/divinumofficium';
my $tag = '';
my $help = 0;

my $debug = defined $ENV{DEBUG};

sub saydo($)
{
    my $command = shift;
    print STDERR "DEBUG: saydo('$command')" if $debug;

    print STDERR $command if $verbose;

    system $command or die "fatal: failed $command: $!";
}

sub main()
{
    # Process command line

    my $USAGE = <<END;
Usage: release_web [options] tag
