\
\ Purpose: Number recognizers based on Forth CORE (only?)
\
\ Author: Matthias Trute
\ Date: Oct 10, 2016
\ License: Public Domain
\
\ not really smart but portable code, tested with old gforth's and vfxlin's
\

decimal

' noop :NONAME POSTPONE LITERAL ; DUP  recognizer: r:num
' noop :NONAME POSTPONE 2LITERAL ; DUP recognizer: r:dnum

\
\ check for the 'c' syntax for single
\ characters.
\
: rec:char ( addr len -- n r:num | r:fail )
  3 = if                       \ a three character string
    dup c@ [char] ' = if       \ that starts with a ' (tick)
      dup 2 + c@ [char] ' = if \ and ends with a ' (tick)
        1+ c@ r:num exit
      then
    then
  then
  drop r:fail
;


\
\ helper words for number recognizers
\
\ set BASE according the the character at addr
\ return string is stripped of it if found.
\ #: 10, $: 16, %: 2, &: 10 (again)
create num-bases 10 , 16 , 2 , 10 ,
: set-base ( addr len -- addr' len' )
   over c@ 35 - dup 0 4 within if 
    cells num-bases + @ base ! 1 /string 
  else 
    drop
  then 
;

\ check for a character. return string is 
\ without it if found. f is true if found.
: skip-char? ( addr len c -- addr' len' f)
  >r over c@ r> = dup >r
  if 1 /string then r> 
;

: -sign? ( addr len -- addr' len' f )
   [char] - skip-char?
;

: +sign  ( addr len -- addr' len' )
   [char] + skip-char? drop
;

\ allows $- and -$ combinations. skip +
\ f is true is - sign is found (and stripped off)
: base-and-sign? ( addr len -- addr' len' f)
  set-base +sign -sign? >r set-base r>
;

\ a factor the recognizers below.
: (rec:number) ( addr len -- d addr' len' f )
   base @ >r           \ save BASE
   base-and-sign? >r   \ handle prefix and sign characters
   2>r 0 0 2r> >number \ do the actual conversion
   r> r> base !        \ restore BASE and sign information
;

\
\ check for double number input
\
: rec:dnum ( addr len -- d r:dnum | r:fail )
    \ simple syntax check: last character in addr/len is a dot . ?
    2dup + 1- c@ [char] . = if
      1-              \ strip trailing dot
      (rec:number) >r \ do the dirty work
      \ a number and only a number?
      nip if
        2drop r> drop r:fail 
      else 
        r> if dnegate then r:dnum 
      then
    else 
      2drop r:fail  \ no, it cannot be a double cell number.
    then 
;

\
\ check for single cell number input
\
: rec:snum ( addr len -- n r:num | rfail )
    (rec:number) >r
    nip if 
      2drop r> drop r:fail 
    else
      \ a "d" with a non-empty upper cell cannot be an "n"
      if    r> drop r:fail
      else  r> if negate then r:num 
      then
    then
;

\ combine them
3 RECOGNIZER VALUE recstack:numbers

' rec:char ' rec:dnum ' rec:snum 3 recstack:numbers SET-RECOGNIZERS

: REC:NUM ( addr len -- n R:NUM | d R:DNUM | R:FAIL )
  recstack:numbers DO-RECOGNIZER 
;

\
\ ------------- Unit tests for all of the above ----------
\

VERBOSE ON

T{ S" 'z'"  rec:char -> char z r:num }T
T{ S" 'z '" rec:char -> r:fail }T

T{ S" 1234."  rec:dnum -> 1234. r:dnum }T
T{ S" -1234." rec:dnum -> -1234. r:dnum }T
T{ S" +1234." rec:dnum -> 1234. r:dnum }T

T{ S" $1234." rec:dnum -> $1234. r:dnum }T
T{ S" $-1234." rec:dnum -> $-1234. r:dnum }T
T{ S" +$1234." rec:dnum -> $1234. r:dnum }T
T{ S" -$1234." rec:dnum -> $-1234. r:dnum }T

T{ S" 1234"   rec:dnum -> r:fail }T
T{ S" ABCXYZ" rec:dnum -> r:fail }T

T{ S" 1234"   rec:snum ->  1234  r:num }T
T{ S" -1234"  rec:snum -> -1234  r:num }T
T{ S" $1234"  rec:snum -> $1234  r:num }T
T{ S" $-1234" rec:snum -> $-1234 r:num }T
T{ S" #1234"  rec:snum ->  1234  r:num }T
T{ S" %1110"  rec:snum -> %1110  r:num }T

T{ S" #123a"  rec:snum -> r:fail }T
T{ S" 1234."  rec:snum -> r:fail }T
T{ S" ABCXYZ" rec:snum -> r:fail }T

T{ S" 1234"   REC:NUM -> 1234 R:NUM }T
T{ S" 1234."  REC:NUM -> 1234. R:DNUM }T
T{ S" 'Z'"    REC:NUM -> char Z R:NUM }T
T{ S" ABCXYZ" REC:NUM -> R:FAIL }T
