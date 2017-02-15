
# yalp

yalp, Yet Another Latex Parser, is a parser for latex.


## Prerequisites

  - perl6 (perl <= 5 cannot do this)


## Goal

This project aims to parse Latex file and generate format string like JSON,
and we finally use it to test for checking documentation quality written in Latex.

### Input

sample.tex

~~~
\documentclass[a4j = true, titlepage, 10pt]{jsarticle}

hello latex!

\begin{foo}
  \begin{bar}
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
% perl main.pl --pretty sample.tex
[
  {
    "command": "documentclass",
    "args": "jsarticle",
    "opts": {
      "titlepage": "",
      "a4j": "true",
      "10pt": ""
    }
  },
  {
    "text": "hello latex!"
  },
  {
    "block": "foo",
    "contents": [
      {
        "block": "bar",
        "contents": [
          {
            "text": "nested block test"
          }
        ]
      },
      {
        "command": "lstinputlisting",
        "args": "../src/kadai2-3.c",
        "opts": {
          "label": "code:kadai2-3",
          "caption": "Listing Caption"
        }
      },
      {
        "command": "clearpage",
        "args": "",
        "opts": {

        }
      }
    ]
  }
]
~~~
