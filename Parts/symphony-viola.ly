\version "2.24.0"

\include "../symphonyDefs.ily"
\include "../Notes/viola.ily"

\score {
    \new Staff = "Staff_viola" \with { instrumentName = "Viola" }
    \violaMusic

    \layout { }
    \midi { }
}
