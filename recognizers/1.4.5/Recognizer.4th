\
\ an alternative implementation of recognizers. It
\ uses a separate stack module, that can be used
\ to implement the search order words independently
\
\ Date: Oct 16, 2016
\ Author: Matthias Trute
\ License: Public Domain

s" tester.fs" INCLUDED
s" Stack.4th" INCLUDED

\ Allocate a recognizer stack
: RECOGNIZER ( size -- stack-id ) STACK ;

4 RECOGNIZER VALUE FORTH-RECOGNIZER

\ replace a recognizer stack
: SET-RECOGNIZERS ( rec-n .. rec-1 n recstack-id -- )
  SET-STACK
;

: GET-RECOGNIZERS ( recstack-id -- rec-n .. rec-1 n )
  GET-STACK
;

\ define a recognizer with three actions. Suggesting R:* names
: RECOGNIZER: ( XT-INTERPRET XT-COMPILE XT-POSTPONE "<spaces>name" -- )
  CREATE SWAP ROT , , , 
;

: R>POST ( R:TABLE -- XT-POSTPONE ) CELL+ CELL+ @ ;
: R>COMP ( R:TABLE -- XT-COMPILE  )       CELL+ @ ;
: R>INT  ( R:TABLE -- XT-INTERPRET)             @ ;

:NONAME -1 ABORT" :=(" ; DUP DUP RECOGNIZER: R:FAIL

: (do-recognizer) ( addr len XT -- addr len 0 | i*x r:table -1 )
   ROT ROT 2DUP 2>R ROT EXECUTE 2R> ROT
   DUP R:FAIL = ( -- i*x addr len r:table f )
   IF DROP 0 ELSE NIP NIP -1 THEN
;

: DO-RECOGNIZER ( addr len stack-id -- i*x r:table|r:fail )
    ['] (do-recognizer) SWAP map-stack ( -- i*x r:table -1 | addr len 0 )
    0= IF \ no recognizer did the job, remove addr/len
     2DROP R:FAIL 
    THEN
;

\ Now build the runtime environment needed to play with all of the above

s" rec-word.4th" INCLUDED
s" rec-num.4th" INCLUDED

' REC:NUM ' REC:WORD 2 FORTH-RECOGNIZER SET-RECOGNIZERS

VERBOSE ON

:noname 1 ; :noname 2 ; :noname 3 ; recognizer: r:test

T{ r:test r>int catch -> 1 0 }T
T{ r:test r>comp catch -> 2 0 }T
T{ r:test r>post catch -> 3 0 }T

T{ S" 1234"  FORTH-RECOGNIZER DO-RECOGNIZER -> 1234  R:NUM   }T
T{ S" 1234." FORTH-RECOGNIZER DO-RECOGNIZER -> 1234. R:DNUM  }T
T{ S" DUP"   FORTH-RECOGNIZER DO-RECOGNIZER -> ' DUP -1 R:WORD }T
T{ S" UNKOWN WORD" FORTH-RECOGNIZER DO-RECOGNIZER  -> R:FAIL }T
