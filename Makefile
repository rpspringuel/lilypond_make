# the name stem of the output files
piece = symphony
# The command to run lilypond
LILY_CMD = lilypond -ddelete-intermediate-files \
                    -dno-point-and-click -dno-strip-output-dir

# The suffixes used in this Makefile.
.SUFFIXES: .ly .ily .dly .pdf .midi

# Input and output files are searched in the directories listed in
# the VPATH variable.  All of them are subdirectories of the current
# directory (given by the GNU make variable `CURDIR').
VPATH = \
  $(CURDIR)/Scores \
  $(CURDIR)/PDF \
  $(CURDIR)/Parts \
  $(CURDIR)/Notes

LY_parts = $(wildcard Parts/*.ly)
LY_scores = $(wildcard Scores/*.ly)

LY_all = $(LY_parts) $(LY_scores)

include $(LY_all:.ly=.dly)

%.dly: %.ly parse-only.ly
	@set -e; rm -f $@; \
	$(LILY_CMD) --init parse-only.ly $< > $@.$$$$; \
	sed '1s,^,$@ ,' < $@.$$$$ > $@; \
	rm -f $@.$$$$

# The pattern rule to create PDF and MIDI files from a LY input file.
# The .pdf output files are put into the `PDF' subdirectory, and the
# .midi files go into the `MIDI' subdirectory.
%.pdf %.midi &: %.ly | PDF MIDI
	$(LILY_CMD) $<
	mv "$*.pdf" PDF/
	mv "$*.midi" MIDI/

PDF :
	mkdir PDF

MIDI :
	mkdir MIDI

# Type `make score' to generate the full score of all four
# movements as one file.
.PHONY: score
score: $(piece).pdf

# Type `make parts' to generate all parts.
# Type `make symphony-foo.pdf' to generate the part for instrument `foo'.
# Example: `make symphony-cello.pdf'.
.PHONY: parts
parts: $(LY_parts:.ly=.pdf)

# Type `make movements' to generate files for the
# four movements separately.
.PHONY: movements
movements: $(piece)I.pdf \
           $(piece)II.pdf \
           $(piece)III.pdf \
           $(piece)IV.pdf

all: score parts movements
