all :
	rm -f tidynomicon.md
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"

clean :
	rm -rf docs tidynomicon.log tidynomicon.md tidynomicon.rds tidynomicon.tex *~
