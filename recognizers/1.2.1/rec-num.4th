\ check for single cell number input

\ TBD: sign, base prefixes

S" ./Recognizer-gforth.4th" INCLUDED
\ S" ./Recognizer-vfx.4th" INCLUDED

: rec:num ( addr len -- n r:num | rfail )
    2>r 0 0 2r> >number ( -- d addr' len' )
    \ a number and only a number?
    nip if 2drop r:fail exit then ( -- d )
    \ a single cell number?
    0= if r:num else drop r:fail then
;

VERBOSE ON

decimal

T{ S" 1234"  rec:num -> 1234 r:num }T
\ T{ S" -1234" rec:num -> -1234 r:num }T
\ T{ S" $1234" rec:num -> $1234 r:num }T
T{ S" 1234."   rec:num -> r:fail }T
T{ S" ABCXYZ" rec:num -> r:fail }T
