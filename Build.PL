#!/usr/bin/perl

use strict;
use warnings;

use lib 'web/cgi-bin';
use Module::Build;

my $build = Module::Build->new(
    module_name           => 'DivinumOfficium',
    dist_version          => 0,
    dist_author           => 'Divinum Officium',
    dist_abstract         => 'Generates texts for the traditional Roman liturgy.',
    license               => 'artistic_2',
    requires              => {
        'perl'                 => '5.10.1',
        'CGI'                  => 0,
        'CGI::Carp'            => 0,
        'CGI::Cookie'          => 0,
        'Encode'               => 0,
        'File::Basename'       => 0,
        'FindBin'              => 0,
        'Time::Local'          => 0,
        'Test::Cmd'            => 0,
        'Test::Carp'           => 0,
        'DateTime'             => 0,
        'List::MoreUtils'      => 0,
    },
    add_to_cleanup        => [ 'DivinumOfficium-*' ],
    meta_merge => {
        resources => {
            repository => 'https://github.com/divinumofficium/divinumofficium',
            bugtracker => 'https://github.com/divinumofficium/divinumofficium/issues',
        },
    },
);

$build->create_build_script();
