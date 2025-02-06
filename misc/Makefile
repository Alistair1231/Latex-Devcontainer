# https://gist.github.com/alexjohnj/35fa1617ed6a21fe11f126fb906d6001
# This is a generic Makefile that can be used to compile somewhat complicated
# LaTeX documents. It assumes a directory structure like this
#        .
#        ├── figures/*.{pdf,tex}
#        ├── MAIN.tex
#        ├── Makefile
#        ├── frontmatter.tex
#        ├── sections/*.tex
#        └── latex.out/
# and that you want to use a LaTeX runner such as latexrun or latexmk. The
# Makefile's configured for latexrun but it should be easy to switch to
# something else by customising the variables $(LATEXRUN) and $(LATEXRUN_OPTS).
#
MAIN = main
PREAMBLE = frontmatter.tex
# No references? Just assign this to nothing.
BIB_FILE = sources.bib

TMP_DIR = latex.out
FIGURE_DIR = figures
SECTIONS_DIR = sections

FIGURES = $(wildcard $(FIGURE_DIR)/*.tex $(FIGURE_DIR)/*.pdf)
SECTIONS = $(wildcard $(SECTIONS_DIR)/*.tex)
# Define any other files (e.g., BibLaTeX configuration files) here.
OTHER_FILES = $(wildcard macros/*.sty) glossary.tex

LATEXRUN = latexrun
# latexrun --latex-cmd lualatex --bibtex-cmd biber --latex-args="-shell-escape -synctex=1" --verbose-cmds main.tex 

$(MAIN).pdf: $(MAIN).tex $(FIGURES) $(SECTIONS) $(BIB_FILE) $(OTHER_FILES)
	clear
	$(LATEXRUN) $(MAIN).tex

.PHONY: clean
clean:
	$(LATEXRUN) --clean-all
	
.PHONY: all
all: $(MAIN).pdf 

.PHONY: watch
watch:
	while inotifywait -e close_write $(MAIN).tex $(FIGURES) $(SECTIONS) $(BIB_FILE) $(OTHER_FILES); do \
		make --silent; \
	done

# make for subfiles; 
# use like this `make sub MAIN=diagram WHERE=./figures/diagram`
# for `./figures/diagram/diagram.tex -> ./figures/diagram/diagram.pdf` 
.PHONY: sub
sub:
	@if [ -z "$(MAIN)" ] || [ -z "$(WHERE)" ]; then \
		echo "Error: MAIN and WHERE must be specified. Usage: make sub MAIN=<diagram> WHERE=<directory>"; \
		exit 1; \
	fi
	$(LATEXRUN) "$(WHERE)/$(MAIN)" -O "$(WHERE)/latex.out" -o "$(WHERE)/$(MAIN).pdf"