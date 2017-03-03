\
\ Purpose: Number recognizers based on Forth CORE (only?)
\
\ Author: Matthias Trute
\ Date: Jan 28, 2017
\ License: Public Domain
\
\ not really smart but portable code, tested with old gforth's and vfxlin's
\

decimal

' noop :NONAME POSTPONE LITERAL ; DUP  DT-TOKEN: DT:NUM
' noop :NONAME POSTPONE 2LITERAL ; DUP DT-TOKEN: DT:DNUM

\
\ check for the 'c' syntax for single
\ characters.
\
: rec:char ( addr len -- n dt:num | dt:null )
  3 = if                       \ a three character string
    dup c@ [char] ' = if       \ that starts with a ' (tick)
      dup 2 + c@ [char] ' = if \ and ends with a ' (tick)
        1+ c@ dt:num exit
      then
    then
  then
  drop dt:null
;


\
\ helper words for number recognizers
\
\ set BASE according the the character at addr
\ return string is stripped of it if found.
\ #: 10, $: 16, %: 2, &: 10 (again)
create num-bases 10 , 16 , 2 , 10 ,
: set-base ( addr len -- addr' len' )
   over c@ [CHAR] # - dup 0 4 within if 
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
: rec:dnum ( addr len -- d dt:dnum | dt:null )
    \ simple syntax check: last character in addr/len is a dot . ?
    2dup + 1- c@ [char] . = if
      1-              \ strip trailing dot
      (rec:number) >r \ do the dirty work
      \ a number and only a number?
      nip if
        2drop r> drop dt:null
      else 
        r> if dnegate then dt:dnum 
      then
    else 
      2drop dt:null  \ no, it cannot be a double cell number.
    then 
;

\
\ check for single cell number input
\
: rec:snum ( addr len -- n dt:num | dt:null )
    (rec:number) >r
    nip if 
      2drop r> drop dt:null
    else
      \ a "d" with a non-empty upper cell cannot be an "n"
      if    r> drop dt:null
      else  r> if negate then dt:num 
      then
    then
;

\ combine them
3 REC-STACK VALUE recstack:numbers

' rec:char ' rec:dnum ' rec:snum 3 recstack:numbers SET-RECOGNIZERS

: REC:NUM ( addr len -- n DT:NUM | d DT:DNUM | DT:NULL )
  recstack:numbers RECOGNIZE
;

\
\ ------------- Unit tests for all of the above ----------
\

VERBOSE ON

VARIABLE OLD-BASE BASE @ OLD-BASE !

T{ S" 'z'"  rec:char -> char z dt:num }T
T{ S" 'z '" rec:char -> dt:null }T

T{ S" 1234."  rec:dnum -> 1234.  dt:dnum }T
T{ S" -1234." rec:dnum -> -1234. dt:dnum }T
T{ S" +1234." rec:dnum -> 1234.  dt:dnum }T

T{ S" $1234." rec:dnum -> $1234.   dt:dnum }T
T{ S" $-1234." rec:dnum -> $-1234. dt:dnum }T
T{ S" +$1234." rec:dnum -> $1234.  dt:dnum }T
T{ S" -$1234." rec:dnum -> $-1234. dt:dnum }T
T{ S" %-10010110." rec:dnum -> -150. dt:dnum }T
T{ S" %10010110."  rec:dnum ->  150. dt:dnum }T

T{ S" 1234"   rec:dnum -> dt:null }T
T{ S" ABCXYZ" rec:dnum -> dt:null }T

T{ S" 1234"   rec:snum ->  1234  dt:num }T
T{ S" -1234"  rec:snum -> -1234  dt:num }T
T{ S" $1234"  rec:snum -> $1234  dt:num }T
T{ S" $-1234" rec:snum -> $-1234 dt:num }T
T{ S" #1234"  rec:snum ->  1234  dt:num }T
T{ S" %-10010110" rec:snum -> -150 dt:num }T
T{ S" %10010110"  rec:snum ->  150 dt:num }T

T{ S" #123a"  rec:snum -> dt:null }T
T{ S" 1234."  rec:snum -> dt:null }T
T{ S" ABCXYZ" rec:snum -> dt:null }T

T{ S" 1234"   REC:NUM -> 1234 dt:NUM }T
T{ S" 1234."  REC:NUM -> 1234. dt:DNUM }T
T{ S" %-10010110" rec:num -> -150 dt:num }T
T{ S" %10010110"  rec:num ->  150 dt:num }T
T{ S" 'Z'"    REC:NUM -> char Z dt:NUM }T
T{ S" ABCXYZ" REC:NUM -> dt:null }T

\ check whether BASE is unchanged
T{ BASE @ OLD-BASE @ = -> -1 }T
