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
  2DUP ! CELL+ SWAP CELLS BOUNDS 
  ?DO I ! CELL +LOOP
;

\ read the whole stack to the data stack
: GET-STACK ( recstack-id -- rec-n .. rec-1 n )
  DUP @ >R CELL+ R@ 1- CELLS BOUNDS SWAP 
  ?DO I @ CELL NEGATE +LOOP R>
;

\ execute XT for earch element of the stack
\ leave the loop if the XT returns TRUE
: MAP-STACK ( i*x XT stack-id -- j*y f )
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

\ ------------- Test Cases ------------

42 STACK value test

: s1 1 0 ;
: s2 2 0 ;
: s3 3 0 ;
: s4 4 -1 ;

T{ ' s1 ' s2 ' s3 3 test SET-STACK -> }T
T{ test GET-STACK -> ' s1 ' s2 ' s3 3 }T
T{ ' EXECUTE test MAP-STACK -> 3 2 1 0 }T

T{ ' s1 ' s2 ' s4 3 test SET-STACK -> }T
T{ ' EXECUTE test MAP-STACK -> 4 -1 }T
