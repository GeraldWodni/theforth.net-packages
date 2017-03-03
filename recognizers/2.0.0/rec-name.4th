\
\ Purpose: dictionary lookup recognizer using Name Tokens
\          It does not use the search order, only the
\          forth-wordlist is searched 
\
\ Requires: Forth 2012 TRAVERSE-WORDLIST and Quotations.
\
\ Author: Matthias Trute
\ Date:   Jan 28, 2017
\ License: Public Domain
\

:NONAME NAME>INTERPRET EXECUTE ; ( nt -- ) \ interpret
:NONAME NAME>COMPILE EXECUTE ;   ( nt -- ) \ compile
:NONAME POSTPONE LITERAL     ;   ( nt -- ) \ postpone
  DT-TOKEN: DT:NT

\ the analogon to search-wordlist
: search-name ( addr len wid -- nt | 0 )
     >R 0 \ dummy for the following quotation loop
     [: ( addr len dummy nt -- addr len 0 -1 | nt 0 )
       >R DROP 2DUP R@ NAME>STRING COMPARE 
       IF R> DROP 0 -1 ELSE 2DROP R> 0 THEN
     ;] R> TRAVERSE-WORDLIST ( -- addr len 0 | nt )
     DUP 0= IF NIP NIP THEN
;

\ a single wordlist is checked
: (rec:name)    ( addr len wid -- nt DT:NT | DT:NULL )
   search-name ?DUP IF DT:NT ELSE DT:NULL THEN
;

\ checks only the standard word-list
: rec:name ( addr len -- nt DT:NT| DT:NULL )
   FORTH-WORDLIST (rec:name)
;
