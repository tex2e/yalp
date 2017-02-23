#!/usr/bin/env perl6

use v6;
use Test;
use lib './lib';
use Latex::YALP;

plan 2;

given 'Making lists' {
    my $input = q:to/EOS/;
    \begin{itemize}
      \item \TeX\ is a typesetting language and not a word processor
    \end{itemize}
    EOS

    my @expected = [
        {
            block => "itemize",
            contents => [
                { command => "item" },
                { command => "TeX" },
                { command => " " },
                "is a typesetting language and not a word processor"
            ],
        },
    ];


    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'Change lists label' {
    my $input = q:to/EOS/;
    {\renewcommand{\labelitemi}{$\triangleright$}
    \begin{itemize}
    \end{itemize}}
    EOS

    my @expected = [
        {
            contents => [
                {
                    command => "renewcommand",
                    args => [
                        [ { command => "labelitemi" }, ],
                        [ { math => '\triangleright' }, ],
                    ],
                },
                {
                    block => "itemize",
                    contents => [],
                },
            ],
        },
    ];


    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
