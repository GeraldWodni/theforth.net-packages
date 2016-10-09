\
\ separate stacks for cell sized data
\
\ Date: Sep 18, 2016
\ Author: Matthias Trute
\ License: Public Domain

: STACK ( size -- stack-id )
  1+ ( size ) CELLS HERE SWAP ALLOT
  0 OVER ! \ empty stack
;

: SET-STACK ( rec-n .. rec-1 n recstack-id -- )
  2DUP ! >R
  BEGIN
   DUP
  WHILE
   DUP CELLS R@ + 
   ROT SWAP ! 1-
  REPEAT R> 2DROP
;

: GET-STACK ( recstack-id -- rec-n .. rec-1 n )
  DUP @ DUP >R SWAP
  BEGIN
   CELL+ OVER 
  WHILE
   DUP @ ROT 1- ROT 
 REPEAT 2DROP R>
;

: MAP-STACK ( i*x XT stack-id -- j*y )
     DUP CELL+ SWAP @ CELLS BOUNDS ?DO 
       ( -- i*x XT )
       I @ SWAP DUP >R EXECUTE
       ?DUP IF R> DROP UNLOOP EXIT THEN
       R>
     CELL +LOOP DROP 0
;

\ Following Jenny Brien
: >FRONT ( x stack-id -- )
  2DUP 2>R GET-STACK 2R> ROT 1+ SWAP SET-STACK
;

: >BACK ( x stack-id -- )
  DUP >R GET-STACK R> 1+ SET-STACK
;
