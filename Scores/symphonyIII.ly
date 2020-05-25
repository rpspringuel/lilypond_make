\include "../symphonyDefs.ily"
\include "../Notes/cello.ily"
\include "../Notes/horn.ily"
\include "../Notes/oboe.ily"
\include "../Notes/viola.ily"
\include "../Notes/violinOne.ily"
\include "../Notes/violinTwo.ily"

\score {
  <<
    \new StaffGroup = "StaffGroup_woodwinds" <<
      \new Staff = "Staff_clarinet" \with {
        instrumentName = \markup { \concat { "Clarinet in B" \flat } }
      }

      % Declare that written Middle C in the music
      % to follow sounds a concert B flat, for
      % output using sounded pitches such as MIDI.
      %\transposition bes

      % Print music for a B-flat clarinet
      \transpose bes c' \clarinetMusic
    >>

    \new StaffGroup = "StaffGroup_brass" <<
      \new Staff = "Staff_hornI" \with { instrumentName = "Horn in F" }
       % \transposition f
        \transpose f c' \hornMusic

    >>
    \new StaffGroup = "StaffGroup_strings" <<
      \new GrandStaff = "GrandStaff_violins" <<
        \new Staff = "Staff_violinI" \with { instrumentName = "Violin I" }
        \violinIMusic

        \new Staff = "Staff_violinII" \with { instrumentName = "Violin II" }
        \violinIIMusic
      >>

      \new Staff = "Staff_viola" \with { instrumentName = "Viola" }
      \violaMusic

      \new Staff = "Staff_cello" \with { instrumentName = "Cello" }
      \celloMusic

    >>
  >>
  \layout { }
  \midi { }
}
