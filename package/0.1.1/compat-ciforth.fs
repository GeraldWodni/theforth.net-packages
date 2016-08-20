: \\ ( -- ) -1 PARSE 2DROP ;

: GET-CURRENT ( -- wid )  CURRENT @ ;
: SET-CURRENT ( -- wid )  CURRENT ! ;

\ ">IN" WANTED will result in a read-only >IN
\ PP is actually usually what's wanted
' PP ALIAS >IN

: WORDLIST: ( "name" -- wid )
  >IN @ VOCABULARY LATEST >WID SWAP >IN ! DUP CONSTANT ;

: GET-ORDER ( -- wid ... wid n )
  0 context begin $@ dup [ 'ONLY >wid ] literal <> while
    -rot  swap 1+ swap
  repeat 2drop ;

: SET-ORDER ( wid ... wid n -- )
  context swap 0 ?do tuck ! cell+ loop 'ONLY >wid swap ! ;

: -ORDER ( wid -- ) >R
  context context begin
    dup @ [ 'ONLY >wid ] literal =
    if drop [ 'ONLY >wid ] literal swap ! rdrop exit then
    dup @ r@ = if cell+
    else 2dup @ swap !  cell+ swap cell+ swap then
  again ;

: +ORDER ( wid -- )
   DUP -ORDER  >R GET-ORDER R> SWAP 1+ SET-ORDER ;

\\

: \\ ( -- )
  cease to interpret the remainder of the current input source ;

: -order ( wid -- )
  ensure that WID does not appear anywhere in the search order ;

: +order ( wid -- )
  ensure that WID appears once in the search order ;
