\
\ Purpose: Use two " characters as the delimiters 
\          of a string.
\
\ Author: Matthias Trute
\ Date:   Oct 12, 2016
\ License: Public Domain
\
\ This is an example for a recognizer that depends
\ on >IN (and thus SOURCE) for input. So, no test
\ cases.
\

' noop 
:noname postpone sliteral ;
:noname -48 throw ; recognizer: r:string

: rec:string ( addr len -- addr' len' r:string | r:fail )
  over c@ [char] " <> if 2drop r:fail exit then
  negate 1+ >in +! drop  \ adjust the  parse area in SOURCE
  [char] " parse         \ eat the trailing delimiter
  -1 /string
  r:string
;
