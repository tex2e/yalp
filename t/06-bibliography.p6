#!/usr/bin/env perl6

use v6;
use Test;
use lib './lib';
use Latex::YALP;

plan 1;

given 'thebibliography' {
    my $input = q:to/EOS/;
    \begin{thebibliography}{99}
    \bibitem{les85}Leslie Lamport, 1985. \emph{\LaTeX---A Document
      Preparation System---User’s Guide and Reference Manual},
      Addision-Wesley, Reading.
    \end{thebibliography}
    EOS

    my @expected = [
        {
            block => "thebibliography",
            args => [ ["99"], ],
            contents => [
                { command => "bibitem", args => [ ["les85"], ] },
                "Leslie Lamport, 1985.",
                {
                    command => "emph",
                    args => [
                        [
                            { command => 'LaTeX' },
                            "---A Document\n  Preparation System---User’s Guide and Reference Manual"
                        ],
                    ],
                },
                ",\n  Addision-Wesley, Reading."
            ],
        },
    ];


    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
