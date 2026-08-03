TARGET := main.pdf
TEX := main.tex
DEP := .deps.mk

-include $(DEP)

default: $(TARGET)

# Rule to compile .tex files to .pdf
$(TARGET): $(TEX)
	latexmk -pdf -recorder $<
	@latexmk -deps -deps-out=$(DEP) -pdf $(TEX)

clean:
	git clean -fdX

.PHONY: default clean
