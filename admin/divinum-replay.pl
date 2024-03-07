#!/usr/bin/perl

# This script runs Divinum Officium regression tests against a current version.

use autodie;            # Ensures that system calls die on failure
use utf8;               # Allows UTF-8 encoding
use open ':encoding(UTF-8)';  # Sets the default output encoding to UTF-8
use warnings;           # Enables additional warnings
use strict;            # Enforces strict parsing rules
use Getopt::Long 'GetOptions';  # Allows parsing command-line options
use Algorithm::Diff ();  # Provides diff algorithm for comparing files
use File::Temp 'tempfile';  # Allows creating temporary files
use URI;               # Provides URI manipulation functions

# Sets the output and error streams to UTF-8 encoding
binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

# Defines the list of filters used for comparing files
my @filters = (
  'kalendar', 'hymns', 'titles', 'psalms', 'antiphons',
  'html', 'accents', 'case', 'ij', 'site', 'urls', 'punctuation',
  'spacing', 'cookies'
);
my $filters = join(' ', @filters);

# Defines the usage message for the script
my $USAGE = <<'USAGE';
... (the rest of the usage message)
