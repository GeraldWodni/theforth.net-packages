: \\ ( -- ) -1 PARSE 2DROP ;

: GET-CURRENT ( -- wid )  CURRENT @ ;
: SET-CURRENT ( -- wid )  CURRENT ! ;

\ ">IN" WANTED will result in a read-only >IN
\ PP is actually usually what's wanted
' PP ALIAS >IN

: WORDLIST: ( "name" -- wid )
  >IN @ VOCABULARY LATEST >WID SWAP >IN ! DUP CONSTANT ;

[UNDEFINED] N>R [IF]
  : N>R ( ... n -- ) ( -- R: ... n )
    POSTPONE dup POSTPONE begin POSTPONE dup POSTPONE while
      POSTPONE rot POSTPONE >r POSTPONE 1-
    POSTPONE repeat POSTPONE drop POSTPONE >r ;
  IMMEDIATE
[THEN]

: (ORDER-FLOOR) ( -- a )  \ address of the bottom of the order stack
  CONTEXT BEGIN $@ [ 'ONLY >WID ] LITERAL = UNTIL [ 2 CELLS ] LITERAL - ;

: GET-ORDER ( -- wid ... wid n )
  0 CONTEXT (ORDER-FLOOR) DO 1+ I @ SWAP [ 1 CELLS NEGATE ] LITERAL +LOOP ;

: SET-ORDER ( wid ... wid n -- )
  context swap 0 ?do tuck ! cell+ loop 'ONLY >wid swap ! ;

: -ORDER ( wid -- ) LOCAL wid
  get-order n>r r> dup begin dup while 1-
    r@ wid = if rdrop swap 1- swap else r> -rot then
  repeat drop set-order ;

: +ORDER ( wid -- )
   DUP -ORDER  >R GET-ORDER R> SWAP 1+ SET-ORDER ;

\\

: \\ ( -- )
  cease to interpret the remainder of the current input source ;

: -order ( wid -- )
  ensure that WID does not appear anywhere in the search order ;

: +order ( wid -- )
  ensure that WID appears once in the search order ;
