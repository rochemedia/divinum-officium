#!/usr/bin/env perl

use utf8; # Enable UTF-8 encoding
use strict;
use warnings;
use feature 'say'; # Enable 'say' for printing with a newline
use open qw( :encoding(UTF-8) :std ); # Set UTF-8 encoding for STDIN, STDOUT, and STDERR
use autodie; # Enable autodie for automatic error handling
use File::Temp qw/ tempfile /; # Import tempfile function from File::Temp module
use File::Copy; # Import move function from File::Copy module

# Usage function to print the script usage and exit
sub Usage {
    print <<EOF;
$0 -h
$0          (read from STDIN)
$0 FILES

Corrects some usual errors on the french punctuation and accents.
If a file from FILES must be corrected, the original one is save with the ".old" extension.

EOF
    exit 0;
}

# Main function to handle command-line arguments and call ConvertStream or ConvertFile
sub Main {
    return ConvertStream() unless @_;
    return Usage() if ($_[0] =~ m/-h/);
    ConvertFile($_) for (@_);
}

# ConvertFile function to process a file, save the original file with ".old" extension if changes are made
sub ConvertFile($) {
    my $filename = shift;
    my $modified = 0;
    say "Reading \"", $filename, "\"… ";
    my ($tmpfh, $tmpfilename) = tempfile; binmode $tmpfh, ':utf8'; # Create a temporary file with UTF-8 encoding
    open my $fh, '<', $filename;
    while (<$fh>) {
        chomp;
        $modified |= ConvertLine(1); # Call ConvertLine with 1 to indicate a file context
        say $tmpfh $_;
    }
    close $fh;
    close $tmpfh;
    if ($modified) {
        move $filename, $filename.".old"; # Rename the original file with ".old" extension
        move $tmpfilename, $filename; # Move the modified file to the original file name
        say "corrected! Original file is \"", $filename.".old", "\"";
    } else {
        say "no error found!";
    }
    say "";  # newline
    return $modified;
}

# ConvertStream function to process STDIN
sub ConvertStream {
    foreach (<STDIN>) {
        ConvertLine(0); # Call ConvertLine with 0 to indicate a stream context
        print $_;
    }
}

# ConvertLine function to perform the actual text conversion
sub ConvertLine($) {
    my $verbose = shift or 0;
    my
