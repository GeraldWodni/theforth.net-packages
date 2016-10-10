\
\ separate stacks for cell sized data
\
\ Date: Sep 18, 2016
\ Author: Matthias Trute
\ License: Public Domain
\ with ideas from Jenny Brien

\ allocate a stack region with at most 
\ size elements
: STACK ( size -- stack-id )
  1+ ( size ) CELLS HERE SWAP ALLOT
  0 OVER ! \ empty stack
;

\ replace the stack content with data from
\ the data stack.
: SET-STACK ( rec-n .. rec-1 n recstack-id -- )
  2DUP ! >R
  BEGIN
   DUP
  WHILE
   DUP CELLS R@ + 
   ROT SWAP ! 1-
  REPEAT R> 2DROP
;

\ read the whole stack to the data stack
: GET-STACK ( recstack-id -- rec-n .. rec-1 n )
  DUP @ DUP >R SWAP
  BEGIN
   CELL+ OVER 
  WHILE
   DUP @ ROT 1- ROT 
 REPEAT 2DROP R>
;

\ execute XT for earch element of the stack
\ leave the loop if the XT returns TRUE
: MAP-STACK ( i*x XT stack-id -- j*y )
     DUP CELL+ SWAP @ CELLS BOUNDS ?DO 
       ( -- i*x XT )
       I @ SWAP DUP >R EXECUTE
       ?DUP IF R> DROP UNLOOP EXIT THEN
       R>
     CELL +LOOP DROP 0
;

\ add an item as new top of the stack
: >FRONT ( x stack-id -- )
  2DUP 2>R GET-STACK 2R> ROT 1+ SWAP SET-STACK
;

\ add an item at the bottom of a stack
: >BACK ( x stack-id -- )
  DUP >R GET-STACK R> 1+ SET-STACK
;
