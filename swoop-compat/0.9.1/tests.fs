class point
  variable x
  variable y
  : .point ( -- )
    ." (" x @ 0 .r ." , " y @ 0 .r ." ) " ;

  ( -- )
  : right  1 x +! ;
  : up    -1 y +! ;
  : down   1 y +! ;
  : left  -1 x +! ;
  : zero   0 x !  0 y ! ;
end-class

point builds p
p zero
cr p .point
p right
p right
p right
p down
cr p .point

point subclass actor
  256 buffer: name
  : name!  ( c-addr u -- ) name place ;
  : .actor ( -- )  name count type ." @" .point ;
end-class

: stands ( x y "shortname" "name" -- )
  actor new dup constant >r
  r@ USING actor y !
  r@ USING actor x !
  0 parse r> USING actor name! ;

0 0 stands bob Bob the Protagonist
5 5 stands gob Gobby the Goblin

cr bob USING actor .actor
bob USING actor right
bob USING actor right
bob USING actor right
cr bob USING actor .actor

gob cr USING actor .actor


: | ( "..." -- ) 0 parse cr type ;
cr cr
| -- Expected output: --
| (0, 0) 
| (3, 1) 
| Bob the Protagonist@(0, 0) 
| Bob the Protagonist@(3, 0) 
| Gobby the Goblin@(5, 5) 
