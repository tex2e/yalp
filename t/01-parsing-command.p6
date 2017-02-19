#!/usr/bin/env perl6

use v6.c;
use Test;
use lib './lib';
use Latex::YALP;

plan 6;

given 'basic command' {
    my $input = q:to/EOS/;
    \documentclass{jsarticle}
    EOS

    my @expected = [];
    @expected.push: {
        command => "documentclass",
        args => { jsarticle => "" },
        opts => {}
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command without {}' {
    my $input = q:to/EOS/;
    \clearpage
    EOS

    my @expected = [];
    @expected.push: {
        command => "clearpage",
        args => {},
        opts => {}
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command with many args' {
    my $input = q:to/EOS/;
    \usepackage{amsmath, amssymb, graphicx}
    EOS

    my @expected = [];
    @expected.push: {
        command => "usepackage",
        args => { amsmath => "", amssymb => "", graphicx => "" },
        opts => {}
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command with many args, key-value pairs' {
    my $input = q:to/EOS/;
    \lstset{
        language = c, numbers = left, breaklines = true
    }
    EOS

    my @expected = [];
    @expected.push: {
        command => "lstset",
        args => { language => "c", numbers => "left", breaklines => "true" },
        opts => {}
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command with opts and args' {
    my $input = q:to/EOS/;
    \special_command
    [prop1, prop2 = 10cm, prop3 = true]
    {args1 = ./img/image.png, args2}
    EOS

    my @expected = [];
    @expected.push: {
        command => "special_command",
        args => { args1 => "./img/image.png", args2 => ""},
        opts => { prop1 => "", prop2 => "10cm", prop3 => "true" }
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command in text' {
    my $input = q:to/EOS/;
    Fig. \ref{fig:test-result} indicates...
    EOS

    my @expected = [];
    @expected.push: "Fig.";
    @expected.push: {
        command => "ref",
        args => { "fig:test-result" => "" },
        opts => {}
    }
    @expected.push: "indicates...";

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
