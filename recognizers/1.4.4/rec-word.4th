\
\ Purpose: Dictionary lookup recognizer based on Forth CORE (only?)
\
\ Author: Matthias Trute
\ Date: Oct 10, 2016
\ License: Public Domain

\ find-word is close to FIND but takes addr/len as input
: BUFFER: CREATE ALLOT ;
256 BUFFER: find-word-buf
: find-word ( addr len -- xt +/-1 | 0 )
  find-word-buf place find-word-buf 
  FIND DUP 0= IF NIP THEN ;

:NONAME ( i*x XT flags -- j*y )  \ INTERPRET
  DROP EXECUTE ;
:NONAME ( XT flags -- )          \ COMPILE
  0> IF COMPILE, ELSE EXECUTE THEN ; 
:NONAME POSTPONE 2LITERAL ; ( XT flag -- )
  RECOGNIZER: R:WORD

: REC:WORD ( addr len -- XT flags R:WORD | R:FAIL )
  find-word ( addr len -- XT flags | 0 )
  ?DUP IF R:WORD ELSE R:FAIL THEN 
;

T{ S" DUP" REC:WORD  -> ' DUP -1 R:WORD }T
T{ S" UNKOWN WORD" REC:WORD -> R:FAIL }T
