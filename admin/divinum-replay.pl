#!/usr/bin/perl

use autodie;
use utf8;
use open ':encoding(UTF-8)';
use warnings;
use strict;
use Getopt::Long 'GetOptions';
use Algorithm::Diff ();
use File::Temp 'tempfile';
use URI;

binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

my @filters = (
  'kalendar', 'hymns', 'titles', 'psalms', 'antiphons',
  'html', 'accents', 'case', 'ij', 'site', 'urls', 'punctuation',
  'spacing', 'cookies');
my $filters = join(' ', @filters);

my $USAGE = <<'USAGE';
Run divinumofficium regression tests against a current version.
Usage: divinum-replay [options] FILE...

Parameters:
  FILE...   file(s) of tests previously established by divinum-get

Options:
--base=BASE (new) base URL
            defaults to environment DIVINUM_OFFICIUM if defined
            otherwise http://divinumofficium.com
--filter=[+|-]FILTER  suppress (-) or include only (+) differences
                      of type FILTER
--[no]baulk don't report detailed differences if everything
            is different, which could happen if thete is a major
            regression or network issue. These are still failures.
--failures=FILENAME   Write failed test names to FILENAME 
--tests=FILENAME      Read test names from FILENAME
                      Tests specified as FILE.. are also replayed.
                      This option can be specfied multiple times.
--save=FILENAME       Output the current result to this file                      
            
Parameters:
FILTER   one of [$filters]
         When + is specified, compare only the content which
         the filter matches, and ignore everything else.
         This is the default.
         When - is
