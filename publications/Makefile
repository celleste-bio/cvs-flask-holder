PAPER = paper.md
OUTPUT = paper.pdf
BIB = references.bib
FLAGS = --pdf-engine=pdflatex --citeproc

all: $(OUTPUT)

$(OUTPUT): $(PAPER) $(BIB)
	pandoc $(PAPER) -o $(OUTPUT) $(FLAGS)

clean:
	rm -f $(OUTPUT)
