# bookdown-nostarch

Trying to get Bookdown and the No Starch template to play nicely together.
(See the bottom of this page for tool versions.)
To reproduce the problem:

1.  `make nostarch` to recompile the example provided by No Starch: works (after installing packages).
2.  `make bookdown` to recompile the R Markdown files using Bookdown: fails.
3.  Edit `index.Rmd`, remove the bibliographic citation `@Wick2019` on the last line, and `make bookdown`: it works.

The problem apears to be related to a file called `tikzlibrarytopaths.code.tex`, but that is present in TinyTex:

```
$ find ~/Library/TinyTex -name tikzlibrarytopaths.code.tex -print

/Users/gvwilson/Library/TinyTeX//texmf-dist/tex/generic/pgf/frontendlayer/tikz/libraries/tikzlibrarytopaths.code.tex
```

The full error output is:

```
$ make bookdown

rm -f tidynomicon.md
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"


processing file: index.Rmd
  |.................................................................| 100%
  ordinary text without R code


output file: index.knit.md

/anaconda3/bin/pandoc +RTS -K512m -RTS tidynomicon.utf8.md --to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash --output tidynomicon.tex --table-of-contents --toc-depth 2 --self-contained --number-sections --highlight-style tango --pdf-engine xelatex --natbib --include-in-header preamble.tex --wrap preserve --variable tables=yes --standalone 
tlmgr search --file --global '/tikzlibrarytopaths.code.tex'
Trying to automatically install missing LaTeX packages...
tlmgr install pgf
tlmgr: package repository http://mirror.its.dal.ca/ctan/systems/texlive/tlnet (not verified: gpg unavailable)
tlmgr install: package already present: pgf
tlmgr path add
tlmgr search --file --global '/tikzlibrarytopaths.code.tex'
! Undefined control sequence.
\MakeUppercase ...ppercaseUnsupportedInPdfStrings 

Error: Failed to compile tidynomicon.tex. See https://yihui.name/tinytex/r/#debugging for debugging tips. See tidynomicon.log for more info.
Please delete tidynomicon.md after you finish debugging the error.
Execution halted
make: *** [bookdown] Error 1
```

and the last few lines in `tidynomicon.log` are:

```
Package natbib Warning: Citation `Wick2019' on page 3 undefined on input line 8
4.

(./tidynomicon.bbl [3] [4


]
! Undefined control sequence.
\MakeUppercase ...ppercaseUnsupportedInPdfStrings 
                                                  
l.1 \begin{thebibliography}{1}
                               
Here is how much of TeX's memory you used:
 41364 strings out of 494468
 787350 string characters out of 6170403
 1009302 words of memory out of 5000000
 45197 multiletter control sequences out of 15000+600000
 536861 words of font info for 67 fonts, out of 8000000 for 9000
 14 hyphenation exceptions out of 8191
 81i,5n,115p,863b,429s stack positions out of 5000i,500n,10000p,200000b,80000s

Output written on tidynomicon.pdf (4 pages).
```

`\MakeUppercase` is used in `nostarch.cls`,
and according to https://texfaq.org/FAQ-casechange,
this command should be defined in the standard LaTeX packages.

## Attempts

-   Adding `\usepackage{textcase}` to `preamble.tex` doesn't work.
    (Inspired by http://joshua.smcvt.edu/latex2e/Upper-and-lower-case.html.)

-   Changing `\MakeUppercase` to `\uppercase` in `nostarch.tex` and `nostarch.cls` works
    (see https://github.com/gvwilson/bookdown-nostarch/issues/1),
    but the publisher probably won't let me change their style files.

-   It appears to be bibliography-related:
    1.  Try to build with `make all`: fails.
    2.  `xelatex tidynomicon` to build the generated LaTeX by hand: succeeds.
    3.  Run `bibtex tidynomicon` to resolve citations.
    4.  Run `xelatex tidynomicon` again: fails with the error shown below.

```
(./tidynomicon.bbl [3] [4]
! Undefined control sequence.
\MakeUppercase ...ppercaseUnsupportedInPdfStrings 
                                                  
l.1 \begin{thebibliography}{1}
```

The bibliography file `tidynomicon.bbl` generated in step 3 above is:

```
\begin{thebibliography}{1}
\providecommand{\natexlab}[1]{#1}
\providecommand{\url}[1]{\texttt{#1}}
\expandafter\ifx\csname urlstyle\endcsname\relax
  \providecommand{\doi}[1]{doi: #1}\else
  \providecommand{\doi}{doi: \begingroup \urlstyle{rm}\Url}\fi

\bibitem[Wickham(2019)]{Wick2019}
Hadley Wickham.
\newblock \emph{Advanced R}.
\newblock Chapman and Hall/CRC, 2nd edition, 2019.
\newblock ISBN 978-0815384571.
\newblock A deep dive into the details of R.

\end{thebibliography}
```

## Files

-   `README.md`: this file.
-   `Makefile`: commands to rebuild things.
    -   `make bookdown`: try to create a PDF using Bookdown.
    -   `make nostarch`: recompile the No Starch example.
    -   `make clean`: clean up shrapnel.
    -   `make packages`: install TinyTex packages (see below).

-   `nostarch.cls`: No Starch's LaTeX template file.
-   `nshyper.sty`: Another No Starch style file.
-   `fonts/*`: fonts required by No Starch example.
-   image files used by No Starch example
    -   `nsp_logo_black_big.jpg`
    -   `100euroie.png`
    -   `100euroit.png`
    -   `1eurogr.jpg`
    -   `recycled.png`
    -   `vitruvian.jpg`

-   `_bookdown.yml`: configuration file used by Bookdown.
-   `_output.yml`: another configuration file used by Bookdown.
-   `preamble.tex`: Bookdown's LaTeX preamble file.
-   `index.Rmd`: Bookdown source file.
-   `book.bib`: bibliography source file (contains one entry because Bookdown expects it).
-   `common.R`: shared R definitions for RMarkdown files.

-   `packages.txt`: list of packages needed by No Starch example file.

## Packages

Follow the instructions on <https://yihui.name/tinytex/> to install TinyTex on the command line,
then use <code>tlmgr install <em>package</em></code> to install packages.
The full list is in `packages.txt`; `make packages` will try to install the lot.
(You can also use <code>tlmgr search --global --file <em>package</em></code> to locate packages.)

## Versions

### R

```
> library(bookdown)
> sessionInfo()
R version 3.6.0 (2019-04-26)
Platform: x86_64-apple-darwin15.6.0 (64-bit)
Running under: macOS High Sierra 10.13.6

Matrix products: default
BLAS:   /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRblas.0.dylib
LAPACK: /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRlapack.dylib

locale:
[1] en_CA.UTF-8/en_CA.UTF-8/en_CA.UTF-8/C/en_CA.UTF-8/en_CA.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] bookdown_0.11

loaded via a namespace (and not attached):
[1] compiler_3.6.0 tools_3.6.0    knitr_1.24     xfun_0.8      
```

### xelatex

```
$ xelatex --version

XeTeX 3.14159265-2.6-0.999991 (TeX Live 2019)
kpathsea version 6.3.1
Copyright 2019 SIL International, Jonathan Kew and Khaled Hosny.
There is NO warranty.  Redistribution of this software is
covered by the terms of both the XeTeX copyright and
the Lesser GNU General Public License.
For more information about these matters, see the file
named COPYING and the XeTeX source.
Primary author of XeTeX: Jonathan Kew.
Compiled with ICU version 63.1; using 63.1
Compiled with zlib version 1.2.11; using 1.2.11
Compiled with FreeType2 version 2.9.1; using 2.9.1
Compiled with Graphite2 version 1.3.13; using 1.3.13
Compiled with HarfBuzz version 2.3.1; using 2.3.1
Compiled with libpng version 1.6.36; using 1.6.36
Compiled with poppler version 0.68.0
Using Mac OS X Core Text and Cocoa frameworks
```

### bibtex

```
$ bibtex --version

BibTeX 0.99d (TeX Live 2019)
kpathsea version 6.3.1
Copyright 2019 Oren Patashnik.
There is NO warranty.  Redistribution of this software is
covered by the terms of both the BibTeX copyright and
the Lesser GNU General Public License.
For more information about these matters, see the file
named COPYING and the BibTeX source.
Primary author of BibTeX: Oren Patashnik.
```
