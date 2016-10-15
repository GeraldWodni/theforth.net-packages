\
\ separate stacks for cell sized data
\
\ Date: Oct 15, 2016
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
  2DUP ! CELL+ SWAP CELLS BOUNDS 
  ?DO I ! CELL +LOOP
;

\ read the whole stack to the data stack
: GET-STACK ( recstack-id -- rec-n .. rec-1 n )
  2DUP @ >R CELL+ SWAP CELLS BOUNDS SWAP 
  ?DO I @ CELL NEGATE +LOOP R>
;

\ execute XT for earch element of the stack
\ leave the loop if the XT returns TRUE
: MAP-STACK ( i*x XT stack-id -- j*y )
   DUP CELL+ SWAP @ CELLS BOUNDS ?DO 
     ( -- i*x XT )
     I @ SWAP DUP >R EXECUTE
     ?DUP IF R> DROP UNLOOP EXIT THEN
     R> CELL +LOOP 
   DROP 0
;

\ add an item as new top of the stack
: >FRONT ( x stack-id -- )
  2DUP 2>R GET-STACK 2R> ROT 1+ SWAP SET-STACK
;

\ add an item at the bottom of a stack
: >BACK ( x stack-id -- )
  DUP >R GET-STACK R> 1+ SET-STACK
;

\ -------------------- Test Cases ------------

T{ -> }T
