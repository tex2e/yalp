#!/usr/bin/env perl6

use v6;
use Test;
use lib './lib';
use Latex::YALP;

plan 2;

given '$ -- math' {
    my $input = q:to/EOS/;
    The equation representing a straight line in the Cartesian plane
    is of the form $ax+by+c=0$
    EOS

    my @expected = [
        "The equation representing a straight line in the Cartesian plane\nis of the form",
        { math => "ax+by+c=0" },
    ];


    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '$$ -- math' {
    my $input = q:to/EOS/;
    The equation representing a straight line in the Cartesian plane is
    of the form
    $$
    ax+by+c=0
    $$
    EOS

    my @expected = [
        "The equation representing a straight line in the Cartesian plane is\nof the form",
        { math => "ax+by+c=0" },
    ];


    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
