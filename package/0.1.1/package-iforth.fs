\ -- compat ----------------------------------------------------
: \\ ( -- )  source-id if begin refill 0= until then ;

: >order ( wid -- )  >r get-order r> swap 1+ set-order ;

: -order ( wid -- )  LOCALS| wid |
  get-order dup begin dup while 1- rot >r repeat drop dup ( n n )
  begin dup while 1-
    r@ wid = if r> drop -1 under+ else r> -rot then
  repeat drop set-order ;

\ remove just the topmost instance of wid
: 1-order ( wid -- )  LOCALS| wid |
  get-order dup begin dup while 1- rot >r repeat drop dup ( n n )
  begin dup while 1-
    r@ wid = if r> drop drop 1- set-order exit
    else r> -rot then
  repeat drop set-order ;

: +order ( wid -- )  dup -order >order ;

\ this is convoluted, but permits packages to have names
\ that show up in the prompt, ORDER, etc.
: wordlist: ( "name" -- wid )
  >in @ vocabulary dup >in ! also ' execute
  get-order swap >r 1- set-order r>
  swap >in ! dup constant ;

\ -- package wordlist ------------------------------------------
get-current  wordlist: (package) dup +order set-current

: end-package ( parent package -- )
  -order set-current  (package) 1-order ;

( parent package -- parent package )
: public  over set-current ;
: private dup  set-current ;

set-current  (package) 1-order


\ --------------------------------------------------------------
: package ( "name" -- parent package )
  get-current >in @ bl word find if
    nip execute
  else
    drop >in !  wordlist:
  then
  (package) >order
  dup set-current  dup +order ;
