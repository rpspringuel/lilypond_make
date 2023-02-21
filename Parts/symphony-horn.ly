\version "2.24.0"

\include "../symphonyDefs.ily"
\include "../Notes/horn.ily"

\score {
    \new Staff = "Staff_hornI" \with { instrumentName = "Horn in F" }
    % \transposition f
    \transpose f c' \hornMusic

    \layout { }
    \midi { }
}
