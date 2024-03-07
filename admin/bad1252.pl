#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

use Getopt::Long;
my $ignore_case = 0;
GetOptions("ignore-case" => \$ignore_case) or die "Error in command line arguments\n";

$\ = "\n";

for my $file (@ARGV)
{
    find_bad_chars($file) or next;
    print_result($file);
}

sub find_bad_chars {
    my ($file) = @_;

    local $/;
    if (open my $in_fh, "<", $file)
    {
        my $data = <$in_fh>;
        close $in_fh;

        if ($data)
        {
            my @bads = ();
            if ($ignore_case) {
                @bads = $data =~ /(\P{Print}|\p{Cntrl})/g;
            } else {
                @bads = $data =~ /([^\p{Print}\p{Cntrl}])/g;
            }

            if (@bads)
            {
                %bads = map { sprintf('0x%x', ord $_) => 1 } @bads;
                return \%bads;
            }
            else
            {
                return;
            }
        }
        else
        {
            return;
        }
    }
    else
    {
        warn "$file : can't read\n";
        return;
    }
}

sub print_result {
    my ($file) = @_;

    my $bads = find_bad_chars($file);
    if ($bads)
    {
        say "$file
