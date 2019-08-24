PDF := main.pdf
MAIN  := main.tex
PARTS := preamble.tex commands.tex abstract.tex introduction.tex background.tex \
         applications.tex system.tex methods.tex experiments.tex clusters.tex \
         guideline.tex conclusion.tex additional_data.tex chainreader.tex tcomm.tex \
         main.bib
AUX   := WileyNJD-v2.cls NJDnatbib.sty WileyNJD-CCPE.bst 

TARFILE := arxiv.tar.gz
BBL     := main.bbl
FIGDIR  := ./figures
FIGURES := $(wildcard $(FIGDIR)/*.pdf)


%.pdf : %.tex
	pdflatex $<
	-bibtex $(basename $<)
	pdflatex $<
	pdflatex $<

.phony: all see clean arxiv

all: $(PDF)

arxiv: $(TARFILE)

$(PDF): $(MAIN) $(PARTS)

$(BBL): $(PDF)

see: $(PDF)
	open $<

clean:
	-rm $(PDF)
	-rm *.aux *.bbl *.blg *.log *.out
	-rm $(TARFILE)

$(TARFILE): $(MAIN) $(PARTS) $(BBL) $(FIGURES) $(AUX)
	tar -zcvf $@ $^
