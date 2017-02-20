#!/usr/bin/env perl6

use v6.c;
use Test;
use lib './lib';
use Latex::YALP;

plan 3;

given 'Title \title' {
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

given 'Title \author' {
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

given 'Title \date' {
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

done-testing;
