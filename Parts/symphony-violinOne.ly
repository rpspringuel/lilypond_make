\version "2.24.0"

\include "../symphonyDefs.ily"
\include "../Notes/violinOne.ily"

\score {
    \new Staff = "Staff_violinI" \with { instrumentName = "Violin I" }
    \violinIMusic

    \layout { }
    \midi { }
}
