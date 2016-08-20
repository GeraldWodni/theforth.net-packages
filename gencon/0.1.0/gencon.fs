variable includes
variable constants
variable codes

: link ( a "x" -- )  align here over @ , swap ! ;

: each[ ( a -- )
  POSTPONE @ POSTPONE >r POSTPONE begin POSTPONE r@ POSTPONE while
  POSTPONE r@ POSTPONE cell+ POSTPONE count ;
immediate
  \ ( c-addr u -- )
: ]each ( -- )
  POSTPONE r> POSTPONE @ POSTPONE >r POSTPONE repeat
  POSTPONE r> POSTPONE drop ;
immediate

: #include ( "<foo>" -- )  includes link  parse-word string, ;
: c ( "CON" -- )  constants link  parse-word string, ;
: code: ( "..." -- )  codes link  0 parse string, ;

: | ( "..." -- )
  0 parse POSTPONE sliteral  POSTPONE type  POSTPONE cr
; immediate

: generate ( -- )
  includes each[ ." #include " type cr ]each
  | #include <stdio.h>
  | #include <stdlib.h>
  cr
  | #define _con(c,f) printf("%6d CONSTANT " f "\n", c)
  | #define con(c,f) _con(c,#f)
  | #define c(k) _con(k,#k)
  cr
  | int main (void) {
  codes each[ 2 spaces type cr ]each
  constants each[ ."   c(" type ." );" cr ]each
  |   return 0;
  | }
;
