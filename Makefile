# the name stem of the output files
piece := symphony
# The command to run lilypond
LILY_CMD := lilypond -ddelete-intermediate-files \
                    -dno-point-and-click --init with-deps.ly

# The suffixes used in this Makefile.
.SUFFIXES: .ly .ily .dly .pdf .midi

DEPDIR := deps

.DEFAULT_GOAL := score

# Input and output files are searched in the directories listed in
# the VPATH variable.  All of them are subdirectories of the current
# directory (given by the GNU make variable `CURDIR').
VPATH := \
  $(CURDIR)/Scores \
  $(CURDIR)/PDF \
  $(CURDIR)/Parts \
  $(CURDIR)/Notes \
  $(CURDIR)/$(DEPDIR)

LY_parts = $(wildcard Parts/*.ly)
LY_scores = $(wildcard Scores/*.ly)

LY_all = $(LY_parts) $(LY_scores)

DEPFILES := $(addsuffix .dly,$(notdir $(basename $(LY_all))))
$(DEPFILES):
include $(wildcard $(addprefix $(DEPDIR)/,$(DEPFILES)))

# The pattern rule to create PDF and MIDI files from a LY input file.
# The .pdf output files are put into the `PDF' subdirectory, and the
# .midi files go into the `MIDI' subdirectory.
# This rule also updates the list of prerequisites for these two files
# so that the next run of make can accurately determine if the target
# is out of date.  These prerequisites are saved in a dly file which
# is placed in the `deps' subdirectory.
%.pdf %.midi &: %.ly %.dly | PDF MIDI $(DEPDIR)
	$(LILY_CMD) $<
	sed -i.temp '1s,^,$(*F).midi ,' $(*F).dly
	rm $(*F).dly.temp
	mv "$(*F).dly" $(DEPDIR)/
	mv "$(*F).pdf" PDF/
	mv "$(*F).midi" MIDI/
	touch PDF/$(*F).pdf MIDI/$(*F).midi

PDF :
	mkdir PDF

MIDI :
	mkdir MIDI

$(DEPDIR) :
	mkdir $(DEPDIR)	

# Type `make score' to generate the full score of all four
# movements as one file.
.PHONY: score
score: $(piece).pdf

# Type `make parts' to generate all parts.
# Type `make symphony-foo.pdf' to generate the part for instrument `foo'.
# Example: `make symphony-cello.pdf'.
.PHONY: parts
parts: $(notdir $(LY_parts:.ly=.pdf))

# Type `make movements' to generate files for the
# four movements separately.
.PHONY: movements
movements: $(piece)I.pdf \
           $(piece)II.pdf \
           $(piece)III.pdf \
           $(piece)IV.pdf

all: score parts movements

.PHONY: test
test:
	@echo $(DEPFILES)
