\
\ an alternative implementation of recognizers. It
\ uses a separate stack module, that can be used
\ to implement the search order words independently
\
\ Date: Jan 28, 2017
\ Author: Matthias Trute
\ License: Public Domain

s" tester.fs" INCLUDED
s" Stack.4th" INCLUDED

\ Allocate a recognizer stack
: REC-STACK ( size -- stack-id ) STACK ;

4 REC-STACK VALUE FORTH-RECOGNIZER

\ replace a recognizer stack
: SET-RECOGNIZERS ( rec-n .. rec-1 n recstack-id -- )
  SET-STACK
;

: GET-RECOGNIZERS ( recstack-id -- rec-n .. rec-1 n )
  GET-STACK
;

\ define a recognizer with three actions. Suggesting DT:* names
: DT-TOKEN: ( XT-INTERPRET XT-COMPILE XT-POSTPONE "<spaces>name" -- )
  CREATE SWAP ROT , , , 
;

: DT>POST ( DT:TOKEN -- XT-POSTPONE ) CELL+ CELL+ @ ;
: DT>COMP ( DT:TOKEN -- XT-COMPILE  )       CELL+ @ ;
: DT>INT  ( DT:TOKEN -- XT-INTERPRET)             @ ;

:NONAME -1 ABORT" :=(" ; DUP DUP DT-TOKEN: DT:NULL

: (recognize) ( addr len XT -- addr len 0 | i*x DT:TOKEN -1 )
   ROT ROT 2DUP 2>R ROT EXECUTE 2R> ROT
   DUP DT:NULL = ( -- i*x addr len dt:token f )
   IF DROP 0 ELSE NIP NIP -1 THEN
;

: RECOGNIZE ( addr len stack-id -- i*x dt:token | dt:null )
    ['] (recognize) SWAP map-stack ( -- i*x dt:token -1 | addr len 0 )
    0= IF \ no recognizer did the job, remove addr/len
     2DROP DT:NULL
    THEN
;

\ Now build the runtime environment needed to play with all of the above

s" rec-find.4th" INCLUDED
s" rec-num.4th" INCLUDED

' REC:NUM ' REC:FIND 2 FORTH-RECOGNIZER SET-RECOGNIZERS

VERBOSE ON

:noname 1 ; :noname 2 ; :noname 3 ; dt-token: dt:test

T{ dt:test dt>int catch -> 1 0 }T
T{ dt:test dt>comp catch -> 2 0 }T
T{ dt:test dt>post catch -> 3 0 }T

T{ S" 1234"  FORTH-RECOGNIZER RECOGNIZE -> 1234  DT:NUM   }T
T{ S" 1234." FORTH-RECOGNIZER RECOGNIZE -> 1234. DT:DNUM  }T
T{ S" DUP"   FORTH-RECOGNIZER RECOGNIZE -> ' DUP -1 DT:XT }T
T{ S" UNKOWN WORD" FORTH-RECOGNIZER RECOGNIZE  -> DT:NULL }T
