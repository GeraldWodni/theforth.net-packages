\ check for the 'c' syntax for single
\ characters. Assumes 1 char = 1

S" ./Recognizer-gforth.4th" INCLUDED

\ S" ./Recognizer-vfx.4th" INCLUDED


: rec:char ( addr len -- n r:num | r:fail )
  3 = if \ a three character string
    dup c@ [char] ' = if \ starts with a '
      dup 2 + c@ [char] ' = if \ and ends with a '
        1+ c@ r:num exit
      then
    then
  then
  drop r:fail
;

VERBOSE ON
T{ S" 'z'"  rec:char -> char z r:num }T
T{ S" 'z '" rec:char -> r:fail }T
