# bookdown-nostarch

Trying to get Bookdown and the No Starch template to play nicely together.
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
