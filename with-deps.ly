%% Toplevel initialisation file.

\version "2.24.0"

\include "init.ly"


% Do not include this file (with-deps.ly) or init.ly in the list of prerequisite files.
#(define prerequisite-files (cdr (cdr (ly:source-files))))


% Starting with 2.23.5 LilyPond no longer has easy access to the target files, so those have to be added by
% a SED script in the make recipe rather than here.
#(define target-files (list ""))

dlyport = #(open-file (string-append (ly:parser-output-name) ".dly") "w")

% Target list
#(format dlyport "~{~a~_~^~}:~_" target-files)
% Prerequisite list
#(format dlyport "~{~a~_~^~}~%" prerequisite-files)

#(close-output-port dlyport)
