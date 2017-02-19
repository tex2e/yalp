#!/usr/bin/env perl6
#
# yall -- yet another latex lexer
#
# https://docs.perl6.org/language/regexes
# https://docs.perl6.org/language/grammar_tutorial

use v6;
use JSON::Fast;
use lib './lib';
use Latex::YALP;

sub MAIN($filename!, Bool :$pretty) {
    my $contents = $filename.IO.slurp;
    my $json = Latex::YALP.parse($contents);
    say to-json($json, :$pretty);
}
