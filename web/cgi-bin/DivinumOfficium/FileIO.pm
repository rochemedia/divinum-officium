# Load the strict and warnings pragmas to enforce good practices in the code
use strict;
use warnings;

# Temporarily require the "horas/do_io.pl" file until a better solution is found
BEGIN {
  package DivinumOfficium::FileIO;
  require "horas/do_io.pl";
}

# Set up the DivinumOfficium::FileIO module as an Exporter
BEGIN {
  require Exporter;
  our $VERSION = 1.00;
  our @ISA = qw(Exporter);
  our @EXPORT_OK = qw(do_read do_write);
}

# Return a true value to indicate that the module has loaded successfully
1;
