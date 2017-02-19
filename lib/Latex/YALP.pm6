#!/usr/bin/env perl6
#
# yall -- yet another latex lexer
#

use v6;

unit module Latex::YALP;

grammar Latex::Grammer {
    token name { <[ \w _ \- ]>+: }
    token val  { <-[ \, \} \] ]>*: }
    token line { <block> || <command> || <text> }
    token text { ( <-[\n \\]>+: || \\ ) }
    rule block {
        '\begin{' $<blockname>=[<name>] '}'
        [ '[' <option>*: %% ',' ']' ]?:
        [ <line> ]*
        '\end{' $<blockname> '}'
    }
    rule command {
        '\\' <name>
        [ '[' <option>*:   %% ',' ']' ]?:
        [ '{' <argument>*: %% ',' '}' ]?:
    }
    rule option {
        <name> [ '=' <val> ]?
    }
    rule argument {
        $<name>=[ <-[ , \} \= ]>+: ] [ '=' <val> ]?
    }

    token TOP {
        \n*
        [ <line> \n* ]*
    }
}

class Latex::Action {
    method TOP($/) {
        make $<line>».ast;
    }
    method line($/) {
        make $/.values[0].ast;
    }
    method text($/) {
        make $0.Str.trim;
    }
    method command($/) {
        my %options = self!convert_kvpair_to_hash($<option>.list);
        my %args    = self!convert_kvpair_to_hash($<argument>.list);
        make {
            command => $<name>.Str.trim,
            opts => %options,
            args => %args
        };
    }
    method block($/) {
        my %options = self!convert_kvpair_to_hash($<option>.list);
        make {
            block => $<name>.Str.trim,
            opts => %options,
            contents => $<line>».ast
        };
    }

    method !convert_kvpair_to_hash(@kvlist) {
        my %hash = %{};
        for @kvlist {
            my $key = $_<name>:exists ?? $_<name>.Str.trim !! "";
            my $val = $_<val>:exists  ?? $_<val>.Str.trim  !! "";
            %hash.push: ( $key => $val );
        }
        %hash;
    }
}

class Latex::YALP {
    method parse($contents) {
        my $actions = Latex::Action;
        Latex::Grammer.parse($contents, :$actions).made;
    }
}
