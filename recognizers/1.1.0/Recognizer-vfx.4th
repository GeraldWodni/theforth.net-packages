\ Date: Sep 18, 2016
\ Author: Matthias Trute
\ License: Public Domain

\ For vfxlin vfxlin 4.62 [build 0531] 

s" tester.fth" INCLUDED
s" Recognizer.4th" INCLUDED

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
  find-word-buf place find-word-buf number?
  dup 1 = IF DROP r:num  ELSE 2 = IF 2DROP THEN R:FAIL THEN
;
\ a double cell number?
: rec:dnum ( addr u -- d r:dnum | r:fail )
  find-word-buf place find-word-buf number?
  dup 2 = IF DROP r:dnum  ELSE 1 = IF DROP THEN R:FAIL THEN
;

\ combine them, just for testing purposes
2 RECOGNIZER VALUE recstack:numbers

' REC:DNUM ' REC:SNUM 2 recstack:numbers SET-RECOGNIZERS

: rec:num ( addr len -- n R:NUM | d R:DNUM | R:FAIL )
  recstack:numbers DO-RECOGNIZER 
;

' rec:word ' rec:num 2 FORTH-RECOGNIZER SET-RECOGNIZERS

VERBOSE ON

{ : S-1234 S" 1234" ; -> }
{ : D-1234 S" 1234." ; -> }
{ : S-UNKNOWN S" unknown word" ; -> }
{ : S-DUP  S" DUP" ; -> }

{ S-DUP REC:WORD -> ' DUP -1 R:WORD }
{ S-UNKNOWN REC:WORD -> R:FAIL }
{ S-1234 REC:WORD -> R:FAIL }

\ not part of RFD, but useful if available
{ S-1234 REC:SNUM  -> 1234  R:NUM   }
{ S-1234 REC:DNUM -> R:FAIL }
{ D-1234 REC:SNUM -> R:FAIL }
{ D-1234 REC:DNUM -> 1234. R:DNUM }

{ S-1234 REC:NUM -> 1234 R:NUM }
{ D-1234 REC:NUM -> 1234. R:DNUM }
{ S-UNKNOWN REC:NUM -> R:FAIL }
{ S-DUP REC:NUM -> R:FAIL }

{ S-1234 FORTH-RECOGNIZER DO-RECOGNIZER -> 1234  R:NUM   }
{ D-1234 FORTH-RECOGNIZER DO-RECOGNIZER -> 1234. R:DNUM  }
{ S-DUP  FORTH-RECOGNIZER DO-RECOGNIZER -> ' DUP -1 R:WORD }
{ S-UNKNOWN FORTH-RECOGNIZER DO-RECOGNIZER  -> R:FAIL }

