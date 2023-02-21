\version "2.24.0"

\include "../symphonyDefs.ily"
\include "../Notes/cello.ily"

\score {
    \new Staff = "Staff_cello" \with { instrumentName = "Cello" }
    \celloMusic

    \layout { }
    \midi { }
}
