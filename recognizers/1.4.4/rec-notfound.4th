\
\ Purpose: Provide the not-found system hook
\
\ Author: Matthias Trute
\ Date:   Oct 12, 2016
\ License: Public Domain
\
\ Add the rec:notfound as the last recognizer and
\ it will call a hook that must not return. The
\ default action just prints the name of the word
\ and throws an exception.

\ the general system hook
defer not-found

\ and its default action 
:noname ( addr len -- ) 
  ." not-found: " type -13 throw ; is not-found

' not-found dup dup recognizer: r:notfound

: rec:notfound ( addr len -- r:notfound )
  r:notfound
;
