#!/usr/bin/env perl6

use v6;
use Test;
use lib './lib';
use Latex::YALP;

plan 4;

given 'Basic block' {
    my $input = q:to/EOS/;
    \begin{document}
        hello, LaTeX.
    \end{document}
    EOS

    my @expected = [
        {
            block => "document",
            contents => [
                'hello, LaTeX.'
            ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'Nested block' {
    my $input = q:to/EOS/;
    \begin{document}
        \begin{quote}
            hello, LaTeX.
        \end{quote}
    \end{document}
    EOS

    my @nested = [];
    @nested.push: {

    }
    my @expected = [
        {
            block => "document",
            contents => [
                {
                    block => "quote",
                    contents => [ 'hello, LaTeX.' ]
                },
            ]
        },
    ];
    @expected.push:

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'Block with opts' {
    my $input = q:to/EOS/;
    \begin{table}[htbp]
        \centering
    \end{table}
    EOS

    my @expected = [
        {
            block => "table",
            opts => { "htbp" => "" },
            contents => [
                { command => "centering" },
            ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'Block with args' {
    my $input = q:to/EOS/;
    \begin{foo}{999}
        bar
    \end{foo}
    EOS

    my @expected = [
        {
            block => "foo",
            args => { "999" => "" },
            contents => [
                "bar"
            ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
