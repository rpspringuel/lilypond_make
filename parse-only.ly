%% Toplevel initialisation file.

\version "2.20.0"

#(if (guile-v2)
 (begin
  (use-modules (ice-9 curried-definitions))
  (setlocale LC_ALL "")
  (setlocale LC_NUMERIC "C")))

#(session-initialize
 (lambda ()
  ;; we can't use ly:parser-include-string here since that does not
  ;; actually do any parsing but merely switches inputs, so the
  ;; session saved by the session initializer after calling this
  ;; function has not actually started.  A parser clone, in contrast,
  ;; can run and complete synchronously and shares the module with
  ;; the current parser.
  (ly:parser-parse-string (ly:parser-clone)
   "\\include \"declarations-init.ly\"")))


#(define (do-nothing . x) #f)

#(define toplevel-book-handler do-nothing)
#(define toplevel-bookpart-handler do-nothing)
#(define toplevel-music-handler do-nothing)
#(define toplevel-score-handler do-nothing)
#(define toplevel-text-handler do-nothing)

#(define book-bookpart-handler do-nothing)
#(define book-music-handler do-nothing)
#(define book-score-handler do-nothing)
#(define book-text-handler do-nothing)

#(define bookpart-score-handler do-nothing)
#(define bookpart-text-handler do-nothing)
#(define bookpart-music-handler do-nothing)
#(define output-def-music-handler do-nothing)
%#(define context-mod-music-handler do-nothing)

#(note-names-language default-language)

#(define toplevel-scores (list))
#(define toplevel-bookparts (list))
#(define $defaultheader #f)
#(define $current-book #f)
#(define $current-bookpart #f)
#(define version-seen #f)
#(define expect-error #f)
#(define output-empty-score-list #f)
#(define output-suffix #f)

#(use-modules (scm clip-region))
#(use-modules (srfi srfi-1))
#(use-modules (ice-9 pretty-print))

\maininput

% Do not include this file (parse-only.ly) in the list of prerequisite files.
#(define prerequisite-files (cdr (ly:source-files)))

% Construct list of target extensions
% We look at which backend is being used and what formats have been requested to determine this list
% Since some backends cause the list of formats to be ignored, we check that first, only looking at the
% formats if the backend would allow that.
#(define target-extensions (cond ((equal? (ly:get-option 'backend) 'svg) (list "svg"))
                                 ((equal? (ly:get-option 'backend) 'scm) (list "scm"))
                                 ((equal? (ly:get-option 'backend) 'ps) (uniq-list (sort-list (ly:output-formats) string<?)))
                                 ((equal? (ly:get-option 'backend) 'eps) (map (lambda (str) (if (equal? str "ps") "eps" str)) (uniq-list (sort-list (ly:output-formats) string<?))))
                                 (else '())))

% add the "." to the beginning of each extension
#(define target-extensions (map (lambda (str) (string-append "." str)) target-extensions))

% For the eps backend, we have to add some additional files which are created if the aux-files option is true
#(if (and (equal? (ly:get-option 'backend) 'eps) (ly:get-option 'aux-files))
     (if (member "pdf" target-extensions)
         (append! target-extensions '("-systems.tex" "-systems.texi" "-systems.count" "-1.eps" "-1.pdf"))
         (append! target-extensions '("-systems.tex" "-systems.texi" "-systems.count" "-1.eps"))))

% Construct list of target files.
% First grab the target-basename: either the same as the basename of the input file, or from --output=FILE
% (or --output=DIR/FILE).
% Note: If you use --output=DIR (or --output=DIR/FILE) when calling lilypond, then this output directory information
%       is used to change the working directory and discarded.  As a result, the make rule output by parsing a
%       lilypond file with this file will not contain this information.
%       If you use -dno-strip-output-dir but not --output=..., then the directory information of the *input* file
%       will be part of target-basename.
%       If both -dno-strip-output-dir and --output=FILE (or --output=DIR/FILE) then the basename will be taken from
%       --output and all directory information will be lost.
#(define target-basename (ly:parser-output-name))
% The target list is then assembled by appending the target-extensions.
#(define target-files 
     (map 
      (lambda (extension) (string-append target-basename extension))
      target-extensions))

% Target list
#(format #t "~{~a~_~^~}:~_" target-files)
% Prerequisite list
#(format #t "~{~a~_~^~}~%" prerequisite-files)
