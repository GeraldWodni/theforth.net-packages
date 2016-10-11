\
\ Purpose: dictionary lookup recognizer using Name Tokens
\          It does not use the search order, only the
\          forth-wordlist is searched 
\
\ Requires: Forth 2012 TRAVERSE-WORDLIST and Quotations.
\
\ Author: Matthias Trute
\ Date:   Oct 10, 2016
\ License: Public Domain
\

:NONAME NAME>INTERPRET EXECUTE ; ( nt -- ) \ interpret
:NONAME NAME>COMPILE EXECUTE ;   ( nt -- ) \ compile
:NONAME POSTPONE LITERAL     ;   ( nt -- ) \ postpone
  RECOGNIZER: R:NAME

\ the analogon to search-wordlist
: search-name ( addr len wid -- nt | 0 )
     >R 0 \ used as flag inside the following quotation 
     [: ( addr len flag nt -- addr len false true | nt false )
       >R DROP 2DUP R@ NAME>STRING COMPARE 
       IF R> DROP 0 -1 ELSE 2DROP R> 0 THEN
     ;] R> TRAVERSE-WORDLIST ( -- addr len false | nt )
     DUP 0= IF NIP NIP THEN
;

\ a single wordlist is checked
   : (rec:name)    ( addr len wid -- nt R:NAME | R:FAIL )
     search-name
     ?DUP IF R:NAME ELSE R:FAIL THEN
   ;

   \ checks only the standard word-list
   : rec:name ( addr len -- nt R:NAME | R:FAIL )
     FORTH-WORDLIST (rec:name)
   ;
