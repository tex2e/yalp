
# yalp

[![Build Status](https://travis-ci.org/tex2e/yalp.svg?branch=master)](https://travis-ci.org/tex2e/yalp)


yalp, Yet Another Latex Parser, is a parser for latex.

This project aims to parse Latex file and generate format string like JSON,
and we finally use it to test for checking documentation quality written in Latex.


## Prerequisites

  - perl6 (perl <= 5 cannot do this)


## Grammer

`\ { }`, these characters have special meaning.

~~~
ROOT         ::= <exp>*
<exp>        ::= <comment> | <curlybrace> | <block> | <command> | <math> | <text>
<comment>    ::= % [^\n]*
<curlybrace> ::= { <exp>* }
<block>      ::= \\begin{ <blockname> } [ <opts> ] <curlybrace>
                 <exp>*
                 \\end{ $<blockname> }
<command>    ::= \\ <name> \*? ( [ <opts> ] <curlybrace> )*
<name>       ::= [\w_]+ \*?
<opts>       ::= ( <key> ( = <val> )? , )+
<math>       ::= $ [^$]+ $
               | $$ [^$]+ $$
               | \( ~ \)
               | \begin{math} ~ \end{math}
<text>       ::= [^\\{}$]+
~~~


### Input

sample.tex

~~~
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
~~~

### Output

~~~
% perl main.p6 --pretty sample.tex
[
  {
    "command": "documentclass",
    "args": {
      "jsarticle": ""
    },
    "opts": {
      "titlepage": "",
      "a4j": "",
      "10pt": ""
    }
  },
  {
    "command": "lstset",
    "args": {
      "language": "c",
      "numbers": "left"
    }
  },
  {
    "block": "foo",
    "contents": [
      {
        "block": "bar",
        "opts": {
          "htbp": ""
        },
        "contents": [
          "nested block test"
        ]
      },
      {
        "command": "lstinputlisting",
        "args": {
          "../src/kadai2-3.c": ""
        },
        "opts": {
          "label": "code:kadai2-3",
          "caption": "Listing Caption"
        }
      },
      {
        "command": "clearpage"
      }
    ]
  }
]
~~~
