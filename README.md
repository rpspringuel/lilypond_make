# lilypond_make
A working repository which demonstrates how to use makefiles with LilyPond


## Sources

We're following the structure and layout provided by [the LilyPond Documentation on using make and makefiles with Lilypond](http://lilypond.org/doc/v2.20/Documentation/usage/make-and-makefiles)
The text of the Makefile is modified from what is provided there because of system specific features of that Makefile:

 * The CPU_CORES variable (and the associated job-count flag in the LilyPond command) is dropped.  Querying for the number of cores like this is specific to Linux distributions and doesn't port to macOS.  Further, make will not actually pass multiple files to LilyPond with a single command so LilyPond itself cannot take advantage of multiple cores to run multiple jobs at once.  Instead, parallelization should be invoked by using the `-j` flag for make.
 * Targets for the PDF and MIDI folders have been added and they are set as order-only prerequisites to the pattern target used to create scores.  This is so that these folders are created if they don't exist (which would be the default case for a fresh clone of this repository), but their last modified date is not used to determine if any score targets are out-of-date.
 * The recipe for the %.pdf %.midi pattern targets has been modified.  The original recipe was a single logical line shell script  which created the pdf and midi files and moved them into the destination folders.  This required the recipe to check for the existence of the pdf and midi files before moving them as an error in the LilyPond run (which would lead to these files not being created) would not stop the recipe and produce more errors if we tried to move non-existant files.  Instead, we use a multiple-line recipe and rely on make to halt recipe execution when it detects and error in any recipe step.
 * The archive target has been removed as it pointed to a directory outside the repository.

Since the above linked page doesn't provide content for the various music files, we borrow that from [the documentation for the Orchestra Choir and Piano template](http://lilypond.org/doc/v2.20/Documentation/snippets/staff-notation#staff-notation-orchestra-choir-and-piano-template).  Since this template is presented as a single file template and does not contain an identical list of parts, we've had to modify it in the following ways:

 * We drop the parts present in the template but not in the Makefile example. The one deviation from this is the oboe (present in the Makefile example but not the template), which has been replaced by the clarinet (which is in the template, but not in the Makefile example).
 * The contents of the template have been split into multiple files according the the scheme in the Makefile example: musical content into various files in the notes folder, the global staff-size and paper definitions to symphonyDefs.ily, and the creation of individual scores for each part and several pseudo-movements (which are simply duplications of the whole score).
 * A \midi block has been added to the all the score and part files so that the example creates the MIDI files expected by the Makefile.
