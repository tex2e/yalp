#!/usr/bin/env perl6
#
# yall -- yet another latex lexer
#

use v6;

unit module Latex::YALP;

grammar Latex::Grammer {
    token name         { <[ \w _ ]>+ \*? }
    token exp          { <.comment> || <curlybrace> || <block> || <math> || <command> || <text> }
    token exp_in_opts  { <.comment> || <bracket>    || <block> || <math> || <command> || <text_in_opts> }
    token comment      { '%' ( <-[ \n ]>* ) }
    token text         { ( <-[ \\ \{ \} \% \$ ]>+ ) }
    token text_in_opts { ( <-[ \\ \[ \] \% \$ ]>+ ) }
    rule block {
        '\begin{' $<blockname>=[<name>] '}'
        [ <bracket> ]?
        [
            <curlybrace>
            [ <bracket> ]?
            [ <curlybrace> ]?
        ]?
        [ <exp> ]*?
        '\end{' $<blockname> '}'
    }
    token command {
        '\\' [ <name> || $<name>=[ <[ \x[20] .. \x[7e] ]> ] ] <.ws>
        [ <bracket> <.ws> ]?
        [
            <curlybrace> <.ws>
            [ <bracket> <.ws> ]?
            [ <curlybrace> <.ws> ]?
        ]?
    }
    rule math {
        '$' ( <-[ $ ]>+ ) '$'
        ||
        '$$' ( <-[ $ ]>+ ) '$$'
        ||
        '\(' ( [ <-[ \\ ]>+ || \\<-[ ) ]> ]+ ) '\)'
    }
    rule bracket {
        '[' <exp_in_opts>* ']'
    }
    rule curlybrace {
        '{' <exp>* '}'
    }

    token TOP {
        ^
        \n*
        [ <exp> ]*
        $
    }
}

class Latex::Action {
    method TOP($/) {
        make $<exp>».ast;
    }
    method exp($/) {
        make $/.values[0].ast;
    }
    method exp_in_opts($/) {
        make $/.values[0].ast;
    }
    method comment($/) {
        make { comment => $0.trim };
    }
    method math($/) {
        make { math => $0.trim }
    }
    method text($/) {
        make $0.Str.trim;
    }
    method text_in_opts($/) {
        make $0.Str.trim;
    }
    method command($/) {
        my @options   = $<bracket>.map({ $_<exp_in_opts> });
        my @arguments = $<curlybrace>.map({ $_<exp> });

        my %node = %{ command => $<name>.Str.trim };
        %node<opts> = @options».ast   if @options.elems > 0;
        %node<args> = @arguments».ast if @arguments.elems > 0;
        make %node;
    }
    method block($/) {
        my @options   = $<bracket>.map({ $_<exp_in_opts> });
        my @arguments = $<curlybrace>.map({ $_<exp> });

        my %node = %{ block => $<name>.Str.trim };
        %node<opts> = @options».ast   if @options.elems > 0;
        %node<args> = @arguments».ast if @arguments.elems > 0;
        %node<contents> = $<exp>».ast;
        make %node;
    }
    method bracket($/) {
        make { contents => $/.values.Array».ast };
    }
    method curlybrace($/) {
        make { contents => $/.values.Array».ast };
    }
}

class Latex::YALP {
    method parse($contents) {
        my $actions = Latex::Action;
        my $json = Latex::Grammer.parse($contents, :$actions);
        return ($json and $json.made);
    }
}
