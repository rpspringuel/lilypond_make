\version "2.20.0"

\include "../symphonyDefs.ily"
\include "../Notes/viola.ily"

\score {
    \new Staff = "Staff_viola" \with { instrumentName = "Viola" }
    \violaMusic

    \layout { }
    \midi { }
}
