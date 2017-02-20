#!/usr/bin/env perl6

use v6.c;
use Test;
use lib './lib';
use Latex::YALP;

plan 5;

given '\documentclass' {
    my $input = q:to/EOS/;
    \documentclass[a4j, titlepage, 10pt]{jsarticle}
    EOS

    my @expected = [];
    @expected.push: {
        command => "documentclass",
        args => { 'jsarticle' => "" },
        opts => { 'a4j' => "", 'titlepage' => "", '10pt' => "" }
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\usepackage' {
    my $input = q:to/EOS/;
    \usepackage[top=30truemm, bottom=30truemm, left=25truemm, right=25truemm]{geometry}
    EOS

    my @expected = [];
    @expected.push: {
        command => "usepackage",
        args => { 'geometry' => "" },
        opts => {
            'top' => "30truemm",
            'bottom' => "30truemm",
            'left' => "25truemm",
            'right' => "25truemm"
        }
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\newcommand' {
    my $input = q:to/EOS/;
    \newcommand{\code}[1]{\texttt{#1}}
    EOS

    my @expected = [];
    @expected.push: {
        command => "newcommand",
        args => { '\code' => "" },
        opts2 => '1',
        args2 => '\texttt{#1}'
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\renewcommand' {
    my $input = q:to/EOS/;
    \renewcommand{\lstlistingname}{リスト}
    EOS

    my @expected = [];
    @expected.push: {
        command => "renewcommand",
        args => { '\lstlistingname' => "" },
        args2 => 'リスト'
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\lstset' {
    my $input = q:to/EOS/;
    \lstset{
      language = c,
      numbers = left,
      stepnumber = 1,
      numberstyle = \footnotesize,
      numbersep = 10pt,
      breaklines = false,
      breakindent = 20pt,
      frame = tRBl,
      framesep = 5pt,
      basicstyle = \ttfamily\small,
      commentstyle = \textit,
      keywordstyle = \bfseries,
      classoffset = 1,
      showstringspaces = false,
      tabsize = 2
    }
    EOS

    my @expected = [];
    @expected.push: {
        command => "lstset",
        args => {
            'language' => 'c',
            'numbers' => 'left',
            'stepnumber' => '1',
            'numberstyle' => '\footnotesize',
            'numbersep' => '10pt',
            'breaklines' => 'false',
            'breakindent' => '20pt',
            'frame' => 'tRBl',
            'framesep' => '5pt',
            'basicstyle' => '\ttfamily\small',
            'commentstyle' => '\textit',
            'keywordstyle' => '\bfseries',
            'classoffset' => '1',
            'showstringspaces' => 'false',
            'tabsize' => '2'
        }
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}


done-testing;
