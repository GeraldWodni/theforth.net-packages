\ C like BREAK and CONTINUE statements on top of ANS Forth control structures    uh 2017-07-20

: cs--roll ( orig_u|dest_u ... orig_0|dest_0 u -- orig_0|dest_0 orig_u|dest_u ... orig_1|dest_1 ) 
   dup 0 ?DO dup >r cs-roll r> LOOP drop ;

\ loopID:  0 not in loop, 1 begin, 2 do-loop

: BREAK ( u1 v loopID -- u2 v loopID ) ( C: dest -- orig dest | -- )
   dup 0=  IF POSTPONE exit   EXIT THEN  \ not in loop
   dup 2 = IF POSTPONE leave  EXIT THEN  \ DO LOOP
   >r >r >r   POSTPONE ahead   1 cs-roll  r> 1+ r> r> \ begin loop
; immediate

: CONTINUE ( u1 v loopID -- u2 v loopID )  ( C: dest -- dest | -- orig | -- )
   dup 0=  IF POSTPONE exit   EXIT THEN \ not in loop
   dup 2 = IF  >r >r >r  POSTPONE ahead  r> 1+ r> r> EXIT THEN  \ do-loop
   >r >r >r 0 cs-pick  POSTPONE again r> r> r> ; immediate

: >>resolve ( orig_1 ... orig_u u -- )   0 ?DO  POSTPONE then  LOOP ;

: BEGIN ( -- u v loopID ) ( C: -- dest )
   POSTPONE begin  1 0 1 ; immediate

: UNTIL ( u v loopID -- ) ( C: orig_1 ... orig_u dest -- )
   2drop >r  POSTPONE until   r> 1-  >>resolve ; immediate

: AGAIN ( u v loopID -- ) ( C: orig_1 ... orig_u dest -- )
   2drop >r  POSTPONE again   r> 1- >>resolve ; immediate

: WHILE ( u v loopID -- u v loopID ) ( C: orig_1 ... orig_u dest -- orig orig_1 ... orig_u dest )
   >r >r >r   POSTPONE if   r@ cs--roll   r> r> r> ; immediate

: REPEAT ( u v loopID ) ( C: orig orig_1 ... orig_u dest -- )
   POSTPONE again  POSTPONE then ; immediate

: DO ( -- u v loopID ) ( C: -- do-sys )
   POSTPONE do  0 0 2 ; immediate

: LOOP ( u v loopID -- ) ( C: do-do-sys orig_1 ... orig_u -- )
   2drop >>resolve  POSTPONE loop ; immediate

: +LOOP ( u v loopID -- ) ( C: do-sys orig_1 ... orig_u -- )
   2drop >>resolve  POSTPONE +loop ; immediate

: IF ( u v loopID --  u v loopID ) ( C: orig_1 ... orig_u|dest -- orig orig_1 orig_u|dest )
   >r >r >r  POSTPONE if  r@ cs--roll   r> r> r> ; immediate

: ELSE ( u v loopID --  u v loopID ) ( C: orig orig_1 ... orig_u|dest -- orig' orig_1 ... orig_u|dest )
   >r >r >r   r@ cs-roll  POSTPONE else  r@ cs--roll   r> r> r> ; immediate

: THEN ( u v loopID -- u v loopID ) ( C: orig orig_1 ... orig_u|dest -- orig_1 ... orig_u|dest )
   >r >r >r   r@ cs-roll  POSTPONE then  r> r> r> ; immediate


: : ( -- u v loopID ) ( C: -- colon-sys )
   :  0 0 0 ;

: ; ( u v loopID -- ) ( C: colon-sys -- )
   drop 2drop POSTPONE ;
   [ drop 2drop ]  \ remove loopID u v for old ;
; immediate 

: :noname ( -- u v loopID )  ( C: -- colon-sys )
   :noname 0 0 0 ;

: does> ( u1 v1 loopID1 -- u2 v2 loopID2 ) ( C: colon-sys  -- colon-sys )
   drop 2drop POSTPONE does> 0 0 0 ; immediate

\ CORE EXT words might not be present.
\ uncomment at will if your system doesn't provide conditional compilation

: have ( <name> -- f ) bl word find nip 0<> ; immediate

have AHEAD [IF]

: AHEAD ( u v loopID --  u v loopID ) ( orig_1 ... orig_u|dest -- orig orig_1 orig_u|dest )
   >r >r >r  POSTPONE ahead  r@ cs--roll   r> r> r> ; immediate

[THEN]

have ?DO [IF]

: ?DO ( -- u v loopID ) ( C: -- do-sys )
   POSTPONE ?do  0 0 2 ; immediate

[THEN]

have CASE [IF]

: CASE ( u v loopID -- u 0 loopID ) 
   nip 0 swap  ;  immediate

: OF ( u v loopID -- u v loopID )  ( C: orig_1 ... orig_u|dest -- orig orig_1 orig_u|dest )
   POSTPONE over  POSTPONE =  POSTPONE if  POSTPONE drop ; immediate

: ENDOF ( u v1 loopID -- u v2 loopID ) ( C: orig orig_1 ... orig_u|dest -- orig' orig_1 ... orig_u|dest )
   POSTPONE else  swap 1+ swap ; immediate

: ENDCASE ( u v loopID --  u v loopID ) ( C: orig'_1 ... orig'_v orig_1 ... orig_u|dest -- orig_1 ... orig_u|dest )
   POSTPONE drop   over 0 ?DO  POSTPONE then  LOOP ; immediate

[THEN]

cr .( break control structure ) cr
