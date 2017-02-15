#!/usr/local/bin/perl6
#
# yall -- yet another latex lexer
#
# https://docs.perl6.org/language/regexes
# https://docs.perl6.org/language/grammar_tutorial

use v6;

grammar Latex::Grammer {
  token name { <[ \w _ \- ]>+: }
  token val  { <-[ \, \} \] ]>*: }
  token line { <block> || <command> || <-[\n]>+: }
  rule block {
    '\begin{' $<blockname>=[<name>] '}'
    [ <line> ]*
    '\end{' $<blockname> '}'
  }
  rule command {
    '\\' <name>
      [ '[' [ <option> ','?: ]+: ']' ]?:
      [ '{' $<val>=[ <-[ \} ]>*: ] '}' ]?:
  }
  rule option {
    <name> '=' <val>
  }

  token TOP {
    [ <line> \n* ]*
  }
}

# my $contents = "test-data/sample.tex".IO.slurp;
my $contents = q:to/EOI/;
\documentclass[a4j, titlepage, 10pt]{jsarticle}

\begin{foo}
  \begin{bar}
    nested block test
  \end{bar}

  \lstinputlisting
  [caption = Caption, label = code:kadai2-3]
  {../src/kadai2-3.c}

  \clearpage
\end{foo}

EOI

my $m = Latex::Grammer.parse($contents);
say $m;
