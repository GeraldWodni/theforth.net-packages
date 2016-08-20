: \\ ( -- )  source-id if begin refill 0= until then ;

: -order {: wid -- :}
  get-order n>r r> dup begin dup while 1-
    r@ wid = if rdrop -1 under+ else r> -rot then
  repeat drop set-order ;

: +order ( wid -- )  dup -order >order ;

\\

: \\ ( -- )
  cease to interpret the remainder of the current input source ;

: -order ( wid -- )
  ensure that WID does not appear anywhere in the search order ;

: +order ( wid -- )
  ensure that WID appears once in the search order ;
