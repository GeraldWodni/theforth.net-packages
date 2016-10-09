\
\ an alternative implementation of recognizers. It
\ uses a separate stack module, that can be used
\ to implement the search order words independently
\
\ Date: Sep 18, 2016
\ Author: Matthias Trute
\ License: Public Domain
\
s" Stack.4th" INCLUDED

: RECOGNIZER ( size -- stack-id ) STACK ;

4 RECOGNIZER VALUE FORTH-RECOGNIZER

: SET-RECOGNIZERS ( rec-n .. rec-1 n recstack-id -- )
  SET-STACK
;

: GET-RECOGNIZERS ( recstack-id -- rec-n .. rec-1 n )
  GET-STACK
;

: RECOGNIZER: ( XT-INTERPRET XT-COMPILE XT-POSTPONE "<spaces>name" -- )
  CREATE SWAP ROT , , , 
;

: R>POST ( R:TABLE -- XT-POSTPONE ) CELL+ CELL+ @ ;
: R>COMP ( R:TABLE -- XT-COMPILE  )       CELL+ @ ;
: R>INT  ( R:TABLE -- XT-INTERPRET)             @ ;

:NONAME -13 THROW ; DUP DUP RECOGNIZER: R:FAIL

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



: r-POSTPONE ( "name" -- )
     PARSE-NAME FORTH-RECOGNIZER DO-RECOGNIZER DUP >R
     R>POST EXECUTE R> R>COMP COMPILE, ;

: r-INTERPRET
     ." REC:> "
     BEGIN
         PARSE-NAME DUP
     WHILE
         FORTH-RECOGNIZER DO-RECOGNIZER 
         STATE @ IF R>COMP ELSE R>INT THEN \ get the right XT from R:*
         EXECUTE \ do the action.
         ?STACK  \ simple housekeeping
     REPEAT 2DROP
;
