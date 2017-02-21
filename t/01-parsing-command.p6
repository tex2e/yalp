#!/usr/bin/env perl6

use v6;
use Test;
use lib './lib';
use Latex::YALP;

plan 7;

given 'basic command' {
    my $input = q:to/EOS/;
    \documentclass{jsarticle}
    EOS

    my @expected = [
        {
            command => "documentclass",
            args => [
                [ 'jsarticle' ],
            ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command without args' {
    my $input = q:to/EOS/;
    \clearpage
    \clearpage{}
    EOS

    my @expected = [
        { command => "clearpage" },
        { command => "clearpage", args => [ [], ] },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command with many args' {
    my $input = q:to/EOS/;
    \usepackage{amsmath, amssymb, graphicx}
    EOS

    my @expected = [
        {
            command => "usepackage",
            args => [ ["amsmath, amssymb, graphicx"], ],
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command with args, key-value pairs' {
    my $input = q:to/EOS/;
    \lstset{
        language = c, numbers = left, breaklines = true
    }
    EOS

    my @expected = [
        {
            command => "lstset",
            args => [ ["language = c, numbers = left, breaklines = true"], ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command with opts and args' {
    my $input = q:to/EOS/;
    \special_command
    [prop1, prop2 = 10cm, prop3 = true]
    {args1 = ./img/image.png, args2}
    EOS

    my @expected = [
        {
            command => "special_command",
            opts => [ ["prop1, prop2 = 10cm, prop3 = true"], ],
            args => [ ["args1 = ./img/image.png, args2"], ],
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command with opts2 and args2' {
    my $input = q:to/EOS/;
    \special_command[]{}
    [hello, world! from opts2]
    {hello, world! from args2}
    EOS

    my @expected = [
        {
            command => "special_command",
            args => [ [], ["hello, world! from args2"] ],
            opts => [ [], ["hello, world! from opts2"] ],
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'command in text' {
    my $input = q:to/EOS/;
    Fig.\ref{fig:test-result} indicates...
    EOS

    my @expected = [
        "Fig.",
        { command => "ref", args => [ ["fig:test-result"], ] },
        "indicates...",
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
