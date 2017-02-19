#!/usr/bin/env perl6

use v6.c;
use Test;
use lib './lib';
use Latex::YALP;

plan 1;

given 'truth' {
    is 1 + 1, 2, $_;
}

done-testing;
