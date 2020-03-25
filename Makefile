NAME  := main
PDF   := $(NAME).pdf
MAIN  := $(NAME).tex
PARTS := preamble.tex commands.tex abstract.tex introduction.tex background.tex \
         applications.tex system.tex methods.tex experiments.tex clusters.tex \
         guideline.tex conclusion.tex additional_data.tex chainreader.tex \
         shiftload.tex xworkload.tex tcomm.tex \
         $(NAME).bib
AUX   := WileyNJD-v2.cls NJDnatbib.sty WileyNJD-CCPE.bst 

TARFILE := arxiv.tar.gz
BBL     := $(NAME).bbl
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
CCPE_STYLE_TAR := styles_sources.tar.gz

README := README.txt

$(README): $(MAKE)
	@(echo "To create the PDF file $(PDF) from the sources:"; \
	echo " "; \
	echo "1. unpack the contents of $(CCPE_LATEX_SOURCES_TAR), $(CCPE_FIGURES_TAR), and $(CCPE_STYLE_TAR) in a directory"; \
	echo "2. run pdflatex and bibtex:";\
	echo "";\
	echo "    pdflatex $(NAME)"; \
	echo "    bibtex $(NAME)"; \
	echo "    pdflatex $(NAME)"; \
	echo "    pdflatex $(NAME)"; \
	echo ""; \
	echo "to produce $(PDF).") > $@

$(CCPE_LATEX_SOURCES_TAR): $(MAIN) $(PARTS)
	tar -zcf $@ $^

$(CCPE_FIGURES_TAR): $(FIGURES)
	tar -zcf $@ $^

$(CCPE_STYLE_TAR): $(AUX) $(README)
	tar -zcf $@ $^

ccpe: $(CCPE_LATEX_SOURCES_TAR) $(CCPE_FIGURES_TAR) $(CCPE_STYLE_TAR) $(PDF) $(README)
	@echo "CCPE Submission files are ready:"
	@echo "- $(CCPE_LATEX_SOURCES_TAR)"
	@echo "- $(CCPE_FIGURES_TAR)"
	@echo "- $(CCPE_STYLE_TAR)"
	@echo "- $(PDF)"
	@echo "- $(README)"
	@echo ""
	@echo "# cp $^ XXX"
