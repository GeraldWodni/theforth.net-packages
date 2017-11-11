: \*	['] \  execute ; immediate
: \**	['] \  execute ; immediate

\** callec.fs    Call with Escape-Continuation.
\**
\**      Author: Ouatu Bogdan Ionut. ("humptydumpty")
\**      Published under Public Domain License.
\**
\**      Based on assumption:  Inside a colon-definition,
\**      the address pointed by return-stack pointer contains
\**      continuation of current colon-definition.
\**
\**	 It is a light-weight approach, when CATCH THROW would be
\**      to heavy to use.
\**      
\**      Also, is easier to test in isolation words that accepts
\**	 an XT on top of stack (a-la "Continuation Passing Style"),
\**	 than words that directly drops continuations from return-stack.
\**
\**		USES Gforth specific words:
\**
\**		RP@  ( -- a)  ;fetch return stack pointer
\**		RP!  ( a --)  ;store return stack pointer
\**
\**		For other Forth implementation, please use
\**		their equivalents.
\**
\**		PROVIDES word:
\**
\**             CALL/EC:     \* "name" --     ;at interpret-time
\**                          \* xt-client --  ;at run-time
\**
\**                     create an 'escape to continuation' for 'xt-client'
\**			'xt-client' has stack effect ( ? xt-escape -- ?? )
\**                     'xt-escape' restore continuation of 'NAME'
\**                                 inside a colon definition.
\**		USE like:
\**                     : client ( .. xt -- ... ) .... ;
\**                                 CALL/EC: ESCC
\**                     : word .. ['] client ESCC ... ;
\**
\**                     continuation point could be reused, but beware
\**			case of nested call/ec with different points
\**			of continuations.
\*

         VARIABLE RP_BACKUP
	 
: (restore/ec)  \*  -- xt
  	 ALIGN HERE RP_BACKUP !
	 0 ,  :noname  RP_BACKUP @  ]] LITERAL @ RP! ; [[
;
: CALL/EC:	\*  "name" --  ; new call/ec point
         (restore/ec)
         CREATE	, RP_BACKUP @ ,
	 DOES>  \*  xt-client a --
	 	RP@ over cell+ @ !
		@ swap execute
;

0 [IF]
\ Examples

\*
\* Sam Falvo II DItI pattern: 
\*
\* <quote https://sam-falvo.github.io/2010/02/27/declarative-imperative-then-inquisitive>
\* Examples
\*
\* To help illustrate this pattern, we consider the relatively simple task
\* of tracking a text input cursor on the screen. Consider a 640x480 pixel
\* display, with an 8-pixel fixed-width, 8-pixel tall font. This yields a
\* character matrix 80 columns wide, 60 rows tall on the screen.
\* </quote>

	VARIABLE cx
	VARIABLE cy
	
: scrolledUp ;

\*
\* Original code
\* 
\* : b-edge?   cy @ 59 = ;
\* : -scroll   b-edge? if scrolledUp r> r> 2drop then ;
\* : r-edge?   cx @ 79 = ;
\* : -wrap     r-edge? if 0 cx !  -scroll 1 cy +!  r> drop then ;
\* : bumped    -wrap   1 cx +! ;
\*
\* Would became using CALL/EC:
\* ( To make only minor modifications to original,
\*   I'll  drop 'xt-esc' only when returning to continuation. )
\*

: b-edge?   cy @ 59 = ;
: -scroll   b-edge? if scrolledUp dup execute then ;
: r-edge?   cx @ 79 = ;
: -wrap     r-edge? if 0 cx !  -scroll 1 cy +! dup execute then ;
: bumped    -wrap   1 cx +! ;

        CALL/EC: WITH
	
: with-cursor
            WITH     ( ..xt-esc  ;what happens if executed, not dropped? {:-)
	       drop  ( and so ... )
;
' bumped with-cursor

\* Testing words in isolation:

:noname ."  : "cx ? cy ? cr ;  constant INS ( PECT)

cr ." Inspect '-scroll'"
cr ." -->"  0 cx !  0 cy !  INS -scroll execute clearstack
cr ." -->"  0 cx ! 59 cy !  INS -scroll execute clearstack

cr ." Inspect '-wrap'"
cr ." -->"  0 cx !  0 cy !  INS -wrap execute clearstack
cr ." -->"  0 cx ! 59 cy !  INS -wrap execute clearstack
cr ." -->" 79 cx ! 59 cy !  INS -wrap execute clearstack
cr ." -->" 79 cx !  0 cy !  INS -wrap execute clearstack


\* Little more entangled example  :)

: restore-xt-esc              \* xt-cc -- xt-esc
               >BODY  dup @   \ a xt
	       CREATE swap , ,
	       DOES>  2@ !
;
	CALL/EC: LC  ' LC restore-xt-esc LC-rescue

: YX	 \*  xt0 xt1 -- xt2
	 >R >R :noname R> compile, R> ]] LITERAL ; [[
;
: gradually      \* xt-cli -- f
          LC     \* f
          dup
          IF  LC-rescue
	  ELSE
	      ['] LC >BODY ['] noop 
	      over @ YX swap !       \ overwrite xt-esc!
	  THEN
;
: zzzz   \* xt-resc -- f
     0 swap
     1 . execute
     2 . execute
     3 . execute
     4 . 2drop -1
;
:noname BEGIN cr ['] zzzz gradually .s UNTIL ;
    EXECUTE cr .s cr

[THEN]
