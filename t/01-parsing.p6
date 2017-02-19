#!/usr/bin/env perl6

use v6.c;
use Test;
use lib './lib';
use Latex::YALP;

my $sample = q:to/EOS/;
\documentclass[a4j, titlepage, 10pt]{jsarticle}
\lstset{ language = c, numbers = left }

\begin{foo}
  \begin{bar}[htbp]
    nested block test
  \end{bar}

  \lstinputlisting
  [caption = Listing Caption, label = code:kadai2-3]
  {../src/kadai2-3.c}

  \clearpage
\end{foo}
EOS

plan 10;

{
    my $input = q:to/EOS/;
    \documentclass{jsarticle}
    EOS

    my @expected = [];
    @expected.push: {
        command => "documentclass",
        args => { jsarticle => "" },
        opts => {}
    }

    is-deeply Latex::YALP.parse($input), @expected, 'basic command';
}

{
    my $input = q:to/EOS/;
    \clearpage
    EOS

    my @expected = [];
    @expected.push: {
        command => "clearpage",
        args => {},
        opts => {}
    }

    is-deeply Latex::YALP.parse($input), @expected, 'command without {}';
}

{
    my $input = q:to/EOS/;
    \usepackage{amsmath, amssymb, graphicx}
    EOS

    my @expected = [];
    @expected.push: {
        command => "usepackage",
        args => { amsmath => "", amssymb => "", graphicx => "" },
        opts => {}
    }

    is-deeply Latex::YALP.parse($input), @expected, 'command with many args';
}

{
    my $input = q:to/EOS/;
    \lstset{
        language=c, numbers=left, breaklines=true
    }
    EOS

    my @expected = [];
    @expected.push: {
        command => "lstset",
        args => { language => "c", numbers => "left", breaklines => "true" },
        opts => {}
    }

    is-deeply Latex::YALP.parse($input), @expected, 'command with many args, key-value pairs';
}

done-testing;
