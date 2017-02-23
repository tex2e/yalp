#!/usr/bin/env perl6

use v6;
use Test;
use lib './lib';
use Latex::YALP;

plan 1;

given 'Making tables' {
    my $input = q:to/EOS/;
    \begin{center}
      \begin{tabular}{cr}
        Planet & Diameter(km) \\\\[5pt]
        Mercury & 4878 \\\\
      \end{tabular}
    \end{center}
    EOS

    my @expected = [
        {
            block => "center",
            contents => [
                {
                    block => "tabular",
                    args => [ ["cr"], ],
                    contents => [
                        'Planet & Diameter(km)',
                        { command => '\\', opts => [ ['5pt'], ] },
                        'Mercury & 4878',
                        { command => "\\" },
                    ],
                },
            ],
        },
    ];


    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
