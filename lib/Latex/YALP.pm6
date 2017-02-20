#!/usr/bin/env perl6
#
# yall -- yet another latex lexer
#

use v6;

unit module Latex::YALP;

grammar Latex::Grammer {
    token name { <[ \w _ \- ]>+ }
    token val  { <-[ \, \} \] ]>* }
    token line { <block> || <special_command> || <command> || <text> }
    token text { ( <-[ \n \\ \{ \} ]>+ || <[ \{ \} ]> ) }
    rule block {
        '\begin{' $<blockname>=[<name>] '}'
        [ '[' <option>* %% ',' ']' ]?
        [ '{' <argument>* %% ',' '}' ]?
        [ <line> \n* ]*?
        '\end{' $<blockname> '}'
    }
    token special_command {
        '\\' $<name>=[ 'text' <[ a .. z ]> ** 2 ] <|w>
        [ '{' [ <line> \n* ]*? '}' ]?
    }
    rule command {
        '\\' [ <name> || $<name>=[ <[ \x[20] .. \x[7e] ]> ] ]
        [ '[' <option>* %% [ ',' \s* ] ']' ]?
        [
            '{' <argument>* %% [ ',' \s* ] '}'
            [ $<option2>=[ <.bracket> ] ]?
            [ $<argument2>=[ <.curlybrace> ] ]?
        ]?
    }
    rule option {
        $<name>=[ <[ \w _ \- 0..9 . ]>+ ] [ '=' <val> ]?
    }
    rule argument {
        $<name>=[ <-[ , \} \= ]>+ ] [ '=' <val> ]?
    }
    rule bracket {
        '[' [ <-[ \[ \] ]>+ || <.bracket> ]+ ']'
    }
    rule curlybrace {
        '{' [ <-[ \{ \} ]>+ || <.curlybrace> ]+ '}'
    }

    token TOP {
        ^
        \n*
        [ <line> \n* ]*
        $
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
    method special_command($/) {
        my %node = %{ command => $<name>.Str.trim };
        %node<contents> = $<line>».ast;
        make %node;
    }
    method command($/) {
        my %options  = self!convert_kvpair_to_hash($<option>.list);
        my %args     = self!convert_kvpair_to_hash($<argument>.list);

        my %node = %{ command => $<name>.Str.trim };
        %node<opts>  = %options if %options.elems > 0;
        %node<args>  = %args    if %args.elems > 0;
        %node<opts2> = $<option2>.trim.substr(1, *-1)   if $<option2>:exists;
        %node<args2> = $<argument2>.trim.substr(1, *-1) if $<argument2>:exists;
        make %node;
    }
    method block($/) {
        my %options = self!convert_kvpair_to_hash($<option>.list);
        my %args    = self!convert_kvpair_to_hash($<argument>.list);

        my %node = %{ block => $<name>.Str.trim };
        %node<opts> = %options if %options.elems > 0;
        %node<args> = %args    if %args.elems > 0;
        %node<contents> = $<line>».ast;
        make %node;
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
