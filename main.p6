#!/usr/bin/env perl6
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
        (<name>) [ '=' (<val>) ]?
    }
    rule argument {
        $<name>=( <-[ , \} \= ]>+: ) [ '=' (<val>) ]?
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
        make $0.Str;
    }
    method command($/) {
        my %options = %{};
        for $<option> {
            my $key =  .values[0].Str;
            my $val = (.values[1] ?? .values[1].Str !! "");
            %options.push: ( $key => $val );
        }
        my %args = %{};
        for $<argument> {
            my $key =  .values[0].Str;
            my $val = (.values[1] ?? .values[1].Str !! "");
            %args.push: ( $key => $val );
        }
        make {
            command => $<name>.Str,
            opts => %options,
            args => %args
        };
    }
    method block($/) {
        my %options = %{};
        for $<option> {
            my $key =  .values[0].Str;
            my $val = (.values[1] ?? .values[1].Str !! "");
            %options.push: ( $key => $val );
        }
        make {
            block => $<name>.Str,
            opts => %options,
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
