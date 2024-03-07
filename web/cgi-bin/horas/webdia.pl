#!/usr/bin/perl
use utf8;

# Name : Laszlo Kiss
# Date : 01-11-04
# WEB dialogs
# This script contains functions for generating HTML head and input elements
# for a web-based Divine Office application. It uses the CGI module to handle
# HTTP requests and responses.

#use warnings;
#use strict "refs";
#use strict "subs";
my $a = 4;

#*** htmlHead($title, $onload)
# generate html head
# This function generates the HTML head section for a web page, including
# the content type, character set, DOCTYPE, HTML, HEAD, and BODY tags. It also
# includes a script tag for a JavaScript file named 'horasjs()' and an onload
# attribute for the BODY tag.
sub htmlHead {
  my($title, $onload) = @_;

  my($horasjs) = "<SCRIPT TYPE='text/JavaScript' LANGUAGE='JavaScript1.2'>\n" . horasjs() . '</SCRIPT>';
  $onload && ($onload = " onload=\"$onload\";");

  print << "PrintTag";
Content-type: text/html; charset=utf-8

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML><HEAD>
  <META NAME="Resource-type" CONTENT="Document">
  <META NAME="description" CONTENT="Divine Office">
  <META NAME="keywords" CONTENT="Divine Office, Breviarium, Liturgy, Traditional, Zsolozsma">
  <META NAME="Copyright" CONTENT="Like GNU">
  <meta name="color-scheme" content="dark light">
  <STYLE>
    /* https://www.30secondsofcode.org/css/s/offscreen/ */
    .offscreen {
      border: 0;
      clip: rect(0 0 0 0);
      height: 1px;
      margin: -1px;
      overflow: hidden;
      padding: 0;
      position: absolute;
      width: 1px;
    }
    h1, h2 {
      text-align: center;
      font-weight: normal;
    }
    h2 {
      margin-top: 4ex;
      color: maroon;
      font-size: 112%;
      font-weight: bold;
      font-style: italic;
    }
    p {
      color: black;
    }
    .contrastbg { background: white; }
    \@media (prefers-color-scheme: dark) {
      table { color: black; }
      .contrastbg {
        background: #121212;
        color: white;
      }
    }
  </STYLE>
  <TITLE>$title</TITLE>
$horasjs
</HEAD>
<BODY VLINK=$visitedlink LINK=$link BGCOLOR="#eeeeee"$onload>
<FORM ACTION="$officium" METHOD=post TARGET=_self>
PrintTag
}

#*** htmlInput()
# generates html inputs as input, select, checkbox
# This function generates various types of HTML input elements based on the

