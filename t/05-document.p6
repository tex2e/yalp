#!/usr/bin/env perl6

use v6;
use Test;
use lib './lib';
use Latex::YALP;

plan 5;

given '\title' {
    my $input = q:to/EOS/;
    \title{{ \Huge Main Title }~\\\\{ \LARGE Sub Title }}
    EOS

    my @expected = [
        {
            command => 'title',
            contents => [
                {
                    contents => [
                        { command => 'Huge' },
                        'Main Title',
                    ]
                },
                '~',
                { command => '\\' },
                {
                    contents => [
                        { command => 'LARGE' },
                        'Sub Title',
                    ]
                }
            ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\author' {
    my $input = q:to/EOS/;
    \author{{ \Large Mako }}
    EOS

    my @expected = [
        {
            command => 'author',
            contents => [
                {
                    contents => [
                        { command => 'Large' },
                        'Mako',
                    ]
                },
            ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\author with 2 authors' {
    my $input = q:to/EOS/;
    \author{
        Author 1\\\\
        Address line 11\\\\
        Address line 12
        \and
        Author 2\\\\
        Address line 21\\\\
        Address line 22}
    EOS

    my @expected = [
        {
            command => 'author',
            contents => [
                'Author 1',
                { command => '\\' },
                'Address line 11',
                { command => '\\' },
                'Address line 12',
                { command => 'and' },
                'Author 2',
                { command => '\\' },
                'Address line 21',
                { command => '\\' },
                'Address line 22',
            ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\date' {
    my $input = q:to/EOS/;
    \date{\today}
    EOS

    my @expected = [
        {
            command => 'date',
            contents => [
                { command => 'today' },
            ]
        },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

given '\section* -- produces no number' {
    my $input = q:to/EOS/;
    \section*{Preface}
    EOS

    my @expected = [
        { command => 'section*', args => { 'Preface' => '' } },
    ];

    is-deeply Latex::YALP.parse($input), @expected, $_;
}

done-testing;
