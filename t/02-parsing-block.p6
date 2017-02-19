#!/usr/bin/env perl6

use v6.c;
use Test;
use lib './lib';
use Latex::YALP;

plan 1;

given 'basic block' {
    my $input = q:to/EOS/;
    \begin{document}
        hello, LaTeX.
    \end{document}
    EOS

    my @expected = [];
    @expected.push: {
        block => "document",
        opts => {},
        contents => [
            'hello, LaTeX.'
        ]
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
