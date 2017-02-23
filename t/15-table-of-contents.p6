#!/usr/bin/env perl6

use v6;
use Test;
use lib './lib';
use Latex::YALP;

plan 1;

given 'truth' {
    my $input = q:to/EOS/;
    abc
    EOS

    my @expected = [
        "abc"
    ];


    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
