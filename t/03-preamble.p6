#!/usr/bin/env perl6

use v6;
use Test;
use lib './lib';
use Latex::YALP;

plan 5;

given '\documentclass' {
    my $input = q:to/EOS/;
    \documentclass[a4j, titlepage, 10pt]{jsarticle}
    EOS

    my @expected = [
        {
            command => "documentclass",
            args => [ ['jsarticle'], ],
            opts => [ ['a4j, titlepage, 10pt'], ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\usepackage' {
    my $input = q:to/EOS/;
    \usepackage[top=30truemm, bottom=30truemm, left=25truemm, right=25truemm]{geometry}
    EOS

    my @expected = [
        {
            command => "usepackage",
            args => [ ['geometry'], ],
            opts => [ ['top=30truemm, bottom=30truemm, left=25truemm, right=25truemm'], ],
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\newcommand' {
    my $input = q:to/EOS/;
    \newcommand{\code}[1]{\texttt{#1}}
    EOS

    my @expected = [
        {
            command => "newcommand",
            args => [
                [
                    { command => 'code' },
                ],
                [
                    { command => 'texttt', args => [ ["#1"], ] },
                ],
            ],
            opts => [ ['1'], ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\renewcommand' {
    my $input = q:to/EOS/;
    \renewcommand{\lstlistingname}{リスト}
    EOS

    my @expected = [
        {
            command => "renewcommand",
            args => [
                [
                    { command => 'lstlistingname' },
                ],
                [
                    "リスト"
                ],
            ],
        },
    ];

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
    }
    EOS

    my @expected = [
        {
            command => "lstset",
            args => [
                [
                    "language = c,\n  numbers = left,\n  stepnumber = 1,\n  numberstyle =",
                    { command => 'footnotesize' },
                    ",\n  numbersep = 10pt,\n  breaklines = false,\n  breakindent = 20pt,"
                ],
            ],
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}


done-testing;
