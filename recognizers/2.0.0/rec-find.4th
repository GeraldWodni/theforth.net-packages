\
\ Purpose: Dictionary lookup recognizer based on Forth CORE (only?)
\
\ Author: Matthias Trute
\ Date: Jan 28, 2017
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
  DT-TOKEN: DT:XT

: REC:FIND ( addr len -- XT flags DT:XT | DT:NULL )
  find-word ( addr len -- XT flags | 0 )
  ?DUP IF DT:XT ELSE DT:NULL THEN 
;

T{ S" DUP" REC:FIND  -> ' DUP -1 DT:XT }T
T{ S" UNKOWN WORD" REC:FIND -> DT:NULL }T
