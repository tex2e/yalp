#!/usr/bin/env perl6

use v6.c;
use Test;
use lib './lib';
use Latex::YALP;

plan 1;

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

done-testing;
