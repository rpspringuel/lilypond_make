# the name stem of the output files
piece = symphony
# The command to run lilypond
LILY_CMD = lilypond -ddelete-intermediate-files \
                    -dno-point-and-click

# The suffixes used in this Makefile.
.SUFFIXES: .ly .ily .pdf .midi

.DEFAULT_GOAL = score

# Input and output files are searched in the directories listed in
# the VPATH variable.  All of them are subdirectories of the current
# directory (given by the GNU make variable `CURDIR').
VPATH = \
  $(CURDIR)/Scores \
  $(CURDIR)/PDF \
  $(CURDIR)/Parts \
  $(CURDIR)/Notes

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

notes = \
  cello.ily \
  horn.ily \
  clarinet.ily \
  viola.ily \
  violinOne.ily \
  violinTwo.ily

# The dependencies of the movements.
$(piece)I.pdf: $(piece)I.ly $(notes)
$(piece)II.pdf: $(piece)II.ly $(notes)
$(piece)III.pdf: $(piece)III.ly $(notes)
$(piece)IV.pdf: $(piece)IV.ly $(notes)

# The dependencies of the full score.
$(piece).pdf: $(piece).ly $(notes)

# The dependencies of the parts.
$(piece)-cello.pdf: $(piece)-cello.ly cello.ily
$(piece)-horn.pdf: $(piece)-horn.ly horn.ily
$(piece)-clarinet.pdf: $(piece)-clarinet.ly clarinet.ily
$(piece)-viola.pdf: $(piece)-viola.ly viola.ily
$(piece)-violinOne.pdf: $(piece)-violinOne.ly violinOne.ily
$(piece)-violinTwo.pdf: $(piece)-violinTwo.ly violinTwo.ily

# Type `make score' to generate the full score of all four
# movements as one file.
.PHONY: score
score: $(piece).pdf

# Type `make parts' to generate all parts.
# Type `make symphony-foo.pdf' to generate the part for instrument `foo'.
# Example: `make symphony-cello.pdf'.
.PHONY: parts
parts: $(piece)-cello.pdf \
       $(piece)-violinOne.pdf \
       $(piece)-violinTwo.pdf \
       $(piece)-viola.pdf \
       $(piece)-clarinet.pdf \
       $(piece)-horn.pdf

# Type `make movements' to generate files for the
# four movements separately.
.PHONY: movements
movements: $(piece)I.pdf \
           $(piece)II.pdf \
           $(piece)III.pdf \
           $(piece)IV.pdf

all: score parts movements
