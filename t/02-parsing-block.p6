#!/usr/bin/env perl6

use v6.c;
use Test;
use lib './lib';
use Latex::YALP;

plan 3;

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

given 'nested block' {
    my $input = q:to/EOS/;
    \begin{document}
        \begin{quote}
            hello, LaTeX.
        \end{quote}
    \end{document}
    EOS

    my @nested = [];
    @nested.push: {
        block => "quote",
        opts => {},
        contents => [ 'hello, LaTeX.' ]
    }
    my @expected = [];
    @expected.push: {
        block => "document",
        opts => {},
        contents => @nested
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'block with opts' {
    my $input = q:to/EOS/;
    \begin{table}[htbp]
        \centering
    \end{table}
    EOS

    my @nested = [];
    @nested.push: {
        command => "centering",
        args => {},
        opts => {}
    }
    my @expected = [];
    @expected.push: {
        block => "table",
        opts => { "htbp" => "" },
        contents => @nested
    }

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
