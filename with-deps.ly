%% Toplevel initialisation file.

\version "2.20.0"

\include "init.ly"


% Do not include this file (with-deps.ly) or init.ly in the list of prerequisite files.
#(define prerequisite-files (cdr (cdr (ly:source-files))))


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

dlyport = #(open-file (string-append (ly:parser-output-name) ".dly") "w")

% Target list
#(format dlyport "~{~a~_~^~}:~_" target-files)
% Prerequisite list
#(format dlyport "~{~a~_~^~}~%" prerequisite-files)

#(close-output-port dlyport)
