#!/usr/bin/env perl6

use v6.c;
use Test;
use lib './lib';
use Latex::YALP;

plan 3;

given 'mixed text and command' {
    my $input = q:to/EOS/;
    This is my \emph{first} document prepared in \LaTeX. I typed it
    on \today.
    EOS

    my @expected = [];
    @expected.push: "This is my";
    @expected.push: {
        command => "emph",
        args => { 'first' => "" }
    }
    @expected.push: "document prepared in";
    @expected.push: {
        command => "LaTeX",
    }
    @expected.push: ". I typed it";
    @expected.push: "on";
    @expected.push: {
        command => "today",
    }
    @expected.push: ".";

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\@ -- produce the extra space after the period' {
    my $input = q:to/EOS/;
    Carrots are good for your eyes, since they contain Vitamin A\@. Have
    you ever seen a rabbit wearing glasses?
    EOS

    my @expected = [
        "Carrots are good for your eyes, since they contain Vitamin A",
        { command => '@' },
        ". Have",
        "you ever seen a rabbit wearing glasses?"
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'Accents' {
    my $input = q:to/EOS/;
    \’{E}l est\’{a} aqu\’{\i}
    EOS

    my @expected = [
        { command => '’', args => { 'E' => '' } },
        "l est",
        { command => '’', args => { 'a' => '' } },
        "aqu",
        { command => '’', args => { '\i' => '' } }
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
