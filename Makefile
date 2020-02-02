PDF := main.pdf
MAIN  := main.tex
PARTS := preamble.tex commands.tex abstract.tex introduction.tex background.tex \
         applications.tex system.tex methods.tex experiments.tex clusters.tex \
         guideline.tex conclusion.tex additional_data.tex chainreader.tex \
         shiftload.tex xworkload.tex tcomm.tex \
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

.phony: all see clean arxiv ccpe

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

# CCPE submission system workarounds
# - max 50 files per tar.gz file
# - do not include bbl or sty

CCPE_LATEX_SOURCES_TAR := latex_sources.tar.gz
CCPE_FIGURES_TAR := figures_sources.tar.gz

$(CCPE_LATEX_SOURCES_TAR): $(MAIN) $(PARTS)
	tar -zcf $@ $^

$(CCPE_FIGURES_TAR): $(FIGURES)
	tar -zcf $@ $^

ccpe: $(CCPE_LATEX_SOURCES_TAR) $(CCPE_FIGURES_TAR)
	@echo "CCPE Submission files are ready:"
	@echo "- $(CCPE_LATEX_SOURCES_TAR)"
	@echo "- $(CCPE_FIGURES_TAR)"
