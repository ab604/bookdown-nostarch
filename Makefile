all :
	rm -f tidynomicon.md
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"

clean :
	rm -rf $$(cat .gitignore)

packages :
	tlmgr install $$(cat packages.txt)

nostarch :
	xelatex nostarch
	bibtex nostarch
	xelatex nostarch
	xelatex nostarch
