#!/usr/bin/perl

use strict;
use warnings;
use utf8;
binmode STDOUT, ':encoding(utf-8)';

use POSIX qw(strftime);
use FindBin qw($Bin);
use CGI;
use CGI::Cookie;
use CGI::Carp qw(fatalsToBrowser);
use File::Basename;
use Time::Local;
use locale;

# Adding use statements for the required modules
use Horas::IO;
use Horas::Common;
use Horas::DialogCommon;
use Horas::Ewebdia;
use Horas::Setup;
use Horas::Horas;
use Horas::Specials;
use Horas::SpecMatins;
use Horas::Monastic if -e "$Bin/monastic.pl";
use Horas::TferTable;

# Loading the setup and dialog data
my $q = CGI->new;
my %dialog = %{ setupstring($datafolder, '', 'horas.dialog') };
my %setup = %{ setupstring($datafolder, '', 'Ehoras.setup') };

# Processing cookies and parameters
my $horasp_params = getcookies('horasp', 'parameters') // '';
my $horasgp_general = getcookies('horasgp', 'general') // '';

my ($lang1, $lang2, $expand, $column, $accented);
my %translate;

if (!$horasgp_general) {
    %setup = %{ setupstring($datafolder, '', 'Ehoras.setup') };
}
else {
    %setup = split(';;;', $horasgp_general);
}

# Setting up the default values
$lang1 = $setup[2] // 'English';
$expand = $setup[0] // 'all';
$version = $setup[1] // 'Rubrics 1960';
@versions = ('Trident 1570', 'Trident 1910', 'Divino Afflatu', 'Reduced 1955', 'Rubrics 1960', '1960 Newcalendar');

# Other global variables
my $date1 = $q->param('date1') // strftime('%Y-%m-%d', localtime);
my $hora = $q->param('hora') // '';
my $command = $q->param('command') // '';
my $searchvalue = $q->param('searchvalue') // '0';
my $caller = $q->param('caller') // '';
my $dirge = $q->param('dirge') // 0;
my $screenheight = $q->param('screenheight') // 600;
my $textwidth = $q->param('textwidth') // 800;

# Processing the command
process_command($command, $hora, $date1);

# Setting up the precedence
precedence($date1);

# Building the HTML
build_html($hora, $date1, \%dialog, \%setup, $screenheight, $textwidth);

sub process_command {
    my ($command, $hora, $date1) = @_;

    if ($command =~ /change/i) {
        $command = $';
        getsetupvalue($command);
        if ($command =~ /parameters/) { setcookies('horasp', 'parameters'); }
    }

    eval($setup{'parameters'});
    eval($setup{'general'});

    # Preparing test mode and other settings
    my $testmode = $q->param('testmode') // 'regular';
    my $votive = $q->param('votive');
    my $expandnum = $q->param('expandnum');

    # Setting up the priest, languages, version, and accent settings
    set_priest_and_lang($q, \%setup);

    # Setting the $only flag
    my $only = ($lang1 eq $lang2) ? 1 : 0;

    # Setting the MDIR
    setmdir($version);
}

sub set_priest_and_lang {
    my ($q, $setup) = @_;

    my %params = $q->param();

    foreach my $key (qw(priest lang1 lang2 accented)) {
        if (exists $params{$key}) {
            $setup->{$key} = $params{$key};
        }
    }
}

sub precedence {
    my ($date1) = @_;

    # Filling the hashes and variables required for precedence
}

sub build_html {
    my ($hora, $date1, $dialog, $setup, $screenheight, $textwidth) = @_;

    print header();

    print << "PrintTag";
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Divinum Officium$hora - $date1</title>
    <style>
        body {
            font-family: 'Gentium Book Basic', serif;
            font-size: 87%;
            line-height: 130%;
        }
    </style>
    <script>
PrintTag

    # Calling the JavaScript functions
    horasjs();

    print << "PrintTag";
    </script>
</head>
<body>
PrintTag

    # Calling the relevant subroutines based on the command
    if ($command =~ /setup/i) {
        setup_table($command);
    }
    elsif ($command =~ /pray/i) {
        pray_hora($hora, $date1, $dialog, $setup);
    }
    else {
        main_page($hora, $date1, $dialog, $setup, $screenheight, $textwidth);
    }

    # Common widgets for main and hora

    # Printing the common end for programs
}

sub setup_table {

