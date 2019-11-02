# bookdown-nostarch

Trying to get Bookdown and the No Starch template to play nicely together.

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

-   `packages.txt`: list of packages needed by No Starch example file.

## Packages

Follow the instructions on <https://yihui.name/tinytex/> to install TinyTex on the command line,
then use <code>tlmgr install <em>package</em></code> to install packages.
The full list is in `packages.txt`; `make packages` will try to install the lot.
(You can also use <code>tlmgr search --global --file <em>package</em></code> to locate packages.)
