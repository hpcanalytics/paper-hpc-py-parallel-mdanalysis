PDF := main.pdf
MAIN  := main.tex
PARTS := preamble.tex commands.tex abstract.tex introduction.tex background.tex \
         applications.tex system.tex methods.tex experiments.tex clusters.tex \
         guideline.tex conclusion.tex additional_data.tex chainreader.tex

%.pdf : %.tex
	pdflatex $<
	-bibtex $(basename $<)
	pdflatex $<
	pdflatex $<

.phony: all see clean

all: $(PDF)

$(PDF): $(MAIN) $(PARTS)

see: $(PDF)
	open $<

clean:
	-rm $(PDF)
	-rm *.aux *.bbl *.blg *.log *.out
