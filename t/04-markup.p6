#!/usr/bin/env perl6

use v6.c;
use Test;
use lib './lib';
use Latex::YALP;

plan 6;

given 'Mixed text and command' {
    my $input = q:to/EOS/;
    This is my \emph{first} document prepared in \LaTeX. I typed it
    on \today.
    EOS

    my @expected = [
        "This is my",
        { command => "emph", args => { 'first' => "" } },
        "document prepared in",
        { command => "LaTeX" },
        ". I typed it",
        "on",
        { command => "today" },
        "."
    ];

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
    \'{E}l est\'{a} aqu\'{\i}
    EOS

    my @expected = [
        { command => "'", args => { 'E' => '' } },
        "l est",
        { command => "'", args => { 'a' => '' } },
        "aqu",
        { command => "'", args => { '\i' => '' } }
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'Special symbols' {
    my $input = q:to/EOS/;
    \textasciitilde
    \#
    \$
    \%
    \textasciicircum
    \&
    \_
    \textbackslash
    \{
    \}
    EOS

    my @expected = [
        { command => 'textasciitilde' },
        { command => '#' },
        { command => '$' },
        { command => '%' },
        { command => 'textasciicircum' },
        { command => '&' },
        { command => '_' },
        { command => 'textbackslash' },
        { command => '{' },
        { command => '}' },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'Break lines' {
    my $input = q:to/EOS/;
    This is the first line.\\\\[10pt]
    This is the second line
    EOS

    my @expected = [
        'This is the first line.',
        { command => '\\', opts => { '10pt' => '' } },
        'This is the second line'
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given 'Text positioning' {
    my $input = q:to/EOS/;
    \begin{center}
      The \TeX nical Institute\\\\[.75cm]
        Certificate
    \end{center}
    EOS

    my @expected = [
        {
            block => 'center',
            contents => [
                'The',
                { command => 'TeX' },
                'nical Institute',
                { command => '\\', opts => { '.75cm' => '' } },
                'Certificate',
            ],
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}


done-testing;
