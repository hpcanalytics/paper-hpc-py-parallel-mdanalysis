PDF := main.pdf

%.pdf : %.tex
	pdflatex $<
	-bibtex $(basename $<)
	pdflatex $<
	pdflatex $<

.phony: all see clean

all: $(PDF)

see: $(PDF)
	open $<

clean:
	-rm $(PDF)
	-rm *.aux *.bbl *.blg *.log *.out
