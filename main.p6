#!/usr/local/bin/perl6
#
# yall -- yet another latex lexer
#
# https://docs.perl6.org/language/regexes
# https://docs.perl6.org/language/grammar_tutorial

use v6;
use JSON::Fast;

grammar Latex::Grammer {
    token name { <[ \w _ \- ]>+: }
    token val  { <-[ \, \} \] ]>*: }
    token line { <block> || <command> || <text> }
    token text { ( <-[\n]>+: ) }
    rule block {
        '\begin{' $<blockname>=[<name>] '}'
        [ <line> ]*
        '\end{' $<blockname> '}'
    }
    rule command {
        '\\' <name>
        [ '[' [ <option> ','?: ]*: ']' ]?:
        [ '{' $<val>=[ <-[ \} ]>*: ] '}' ]?:
    }
    rule option {
        <name> [ '=' <val> ]?
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
        make { text => $0.Str };
    }
    method command($/) {
        make {
            command => $<name>.Str,
            opts => $<option>».&{
                my $key =  $_.values[0].Str;
                my $val = ($_.values[1] ?? $_.values[1].Str !! "");
                { $key => $val }
            },
            args => ($<val> ?? $<val>.Str !! "")
        };
    }
    method block($/) {
        make {
            block => $<name>.Str,
            contents => $<line>».ast
        };
    }
}

sub MAIN($filename!, Bool :$pretty) {
    my $contents = $filename.IO.slurp;
    my $actions = Latex::Action;
    my $match = Latex::Grammer.parse($contents, :$actions);
    # say $match;

    my $json = $match.made;
    say to-json($json, :pretty($pretty));
}
