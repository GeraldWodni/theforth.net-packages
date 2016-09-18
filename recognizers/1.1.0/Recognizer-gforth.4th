\ Date: Sep 18, 2016
\ Author: Matthias Trute
\ License: Public Domain

\ for gforth 0.7.3 and earlier (!)
\ tested with ubuntu LTS

s" test/tester.fs" INCLUDED 
s" Recognizer.4th" INCLUDED

: BUFFER: create allot ;

\ find-word is close to FIND but takes addr/len as input
256 BUFFER: find-word-buf
: find-word ( addr len -- xt +/-1 | 0 )
  find-word-buf place find-word-buf 
  FIND DUP 0= IF NIP THEN ;

: immediate? ( flags -- true|false ) 0> ;
:NONAME ( i*x XT flags -- j*y )  \ INTERPRET
  DROP EXECUTE ;
:NONAME ( XT flags -- )          \ COMPILE
  immediate? IF COMPILE, ELSE EXECUTE THEN ; 
:NONAME POSTPONE 2LITERAL ; ( XT flag -- )
  RECOGNIZER: R:WORD

: REC:WORD ( addr len -- XT flags R:WORD | R:FAIL )
  find-word ( addr len -- XT flags | 0 )
  ?DUP IF R:WORD ELSE R:FAIL THEN 
;

' noop :NONAME POSTPONE LITERAL ; DUP  recognizer: r:num
' noop :NONAME POSTPONE 2LITERAL ; DUP recognizer: r:dnum

\ not really smart code but great for testing nested
\ recognizer stacks

\ a single cell number?
: rec:snum ( addr u -- n r:num | r:fail )
  snumber?  dup
  IF 0> IF  2drop r:fail   ELSE  r:num  THEN  EXIT THEN
  drop r:fail ;
\ a double cell number?
: rec:dnum ( addr u -- d r:dnum | r:fail )
  snumber?  dup
  IF 0> IF  r:dnum   ELSE  drop r:fail THEN  EXIT THEN
  drop r:fail ;

\ combine them, just for testing purposes
2 RECOGNIZER VALUE recstack:numbers

' REC:DNUM ' REC:SNUM 2 recstack:numbers SET-RECOGNIZERS

: rec:num ( addr len -- n R:NUM | d R:DNUM | R:FAIL )
  recstack:numbers DO-RECOGNIZER 
;

' rec:word ' rec:num 2 FORTH-RECOGNIZER SET-RECOGNIZERS

\ vfxlin uses { instead of T{, change accordingly
VERBOSE ON

T{ : S-1234 S" 1234" ; -> }T
T{ : D-1234 S" 1234." ; -> }T
T{ : S-UNKNOWN S" unknown word" ; -> }T
T{ : S-DUP  S" DUP" ; -> }T

T{ S-DUP REC:WORD -> ' DUP -1 R:WORD }T
T{ S-UNKNOWN REC:WORD -> R:FAIL }T
T{ S-1234 REC:WORD -> R:FAIL }T

\ not part of RFD, but useful if available
T{ S-1234 REC:SNUM  -> 1234  R:NUM   }T
T{ S-1234 REC:DNUM -> R:FAIL }T
T{ D-1234 REC:SNUM -> R:FAIL }T
T{ D-1234 REC:DNUM -> 1234. R:DNUM }T

T{ S-1234 REC:NUM -> 1234 R:NUM }T
T{ D-1234 REC:NUM -> 1234. R:DNUM }T
T{ S-UNKNOWN REC:NUM -> R:FAIL }T
T{ S-DUP REC:NUM -> R:FAIL }T

T{ S-1234 FORTH-RECOGNIZER DO-RECOGNIZER -> 1234  R:NUM   }T
T{ D-1234 FORTH-RECOGNIZER DO-RECOGNIZER -> 1234. R:DNUM  }T
T{ S-DUP  FORTH-RECOGNIZER DO-RECOGNIZER -> ' DUP -1 R:WORD }T
T{ S-UNKNOWN FORTH-RECOGNIZER DO-RECOGNIZER  -> R:FAIL }T

