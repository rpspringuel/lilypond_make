\version "2.20.0"

\include "../symphonyDefs.ily"
\include "../Notes/clarinet.ily"

\score {
    \new Staff = "Staff_clarinet" \with {
        instrumentName = \markup { \concat { "Clarinet in B" \flat } }
    }

    % Declare that written Middle C in the music
    % to follow sounds a concert B flat, for
    % output using sounded pitches such as MIDI.
    %\transposition bes

    % Print music for a B-flat clarinet
    \transpose bes c' \clarinetMusic

    \layout { }
    \midi { }
}
