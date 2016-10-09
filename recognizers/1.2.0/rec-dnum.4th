\ check for double number input
\ strictly following Forth 2012 spec
\ only trailing dots are allowed

\ TBD: base prefixes

S" ./Recognizer-gforth.4th" INCLUDED
\ S" ./Recognizer-vfx.4th" INCLUDED

: rec:dnum ( addr len -- d r:dnum | rfail )
    2dup + 1- c@ [char] . = if 
      2>r 0 0 2r> >number 
      if drop r:dnum else drop 2drop r:fail then
    else 
      2drop r:fail 
    then 
;

T{ S" 1234." rec:dnum -> 1234. r:dnum }T
\ T{ S" -1234." rec:dnum -> -1234. r:dnum }T
\ T{ S" $1234." rec:dnum -> $1234. r:dnum }T
T{ S" 1234"  rec:dnum -> r:fail }T
T{ S" ABC"   rec:dnum -> r:fail }T

