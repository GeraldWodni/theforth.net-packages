\ matrix multiplication

\ The program uses the following words
\ from CORE :
\  Constant : bl word ; immediate 0= execute drop depth >r r> - = dup and 
\  over swap LOOP rshift 2drop * j i + 
\ from CORE-EXT :
\  nip 0<> :noname C" ?DO erase 
\ from BLOCK-EXT :
\  \ 
\ from FILE :
\  ( 
\ from FLOAT :
\  d>f fdrop fdup f@ f* f+ f! float+ floats 
\ from SEARCH :
\  find 
\ from TOOLS-EXT :
\  [IF] [THEN] 

:noname c" [defined]" ; execute find 0= [if]
    include extensions/defined.fs
[then]
drop
[undefined] {: [if]
    [undefined] parse-name [if]
	include extensions/parse-name.fs
    [then]
    include extensions/locals.fs
[then]

:noname depth >r 0 0 d>f depth r> - >r fdrop r> ; execute
constant FPCELLWIDTH

[undefined] faxpy-nostride-variant [if]
   
    [defined] faxpy [if]
	1 constant faxpy-nostride-variant
    [else]
	FPCELLWIDTH 0= 3 + constant faxpy-nostride-variant \ 2=Forth-2012, 3=Forth-94
    [then]
[then]
	    
faxpy-nostride-variant 1 = [if]
[defined] matmul-verbose [if] cr .( use Gforth's primitive FAXPY) cr [then]     
: faxpy-nostride ( ra f_x f_y ucount -- )
    1 floats -rot 1 floats swap faxpy ;
[then]

faxpy-nostride-variant 4 = [if]
[defined] matmul-verbose [if] cr .( Forth-2012, no unrolling) cr [then]     
    FPCELLWIDTH [if]
        cr .( Forth-2012 code does not work on combined-stack systems) bye
    [then]
\ Forth-2012 version by Anton Ertl
: faxpy-nostride ( ra f_x f_y ucount -- )
    \ vy=ra*vx+vy
    0 ?do
	fdup over f@ f* dup f@ f+ dup f! 
	float+ swap float+ swap
    loop
    2drop fdrop ;
[then]

faxpy-nostride-variant 5 = [if]
\ Forth-94 version based on work by
\ by Joel Rees <60f085e8-a418-4670-9e53-310b23a28f3f@googlegroups.com>
[defined] matmul-verbose [if] cr .( Forth-94 by Rees/Ertl, no unrolling) cr [then]
fvariable faxpy-ra
: faxpy-nostride ( ra f_x f_y ucount -- )
    \ vy=ra*vx+vy
    >r 2>r faxpy-ra f! 2r> r>
    0 ?DO ( f_x1 f_y1 )
        over f@ faxpy-ra f@ f*
        FPCELLWIDTH pick f@ f+ 
        FPCELLWIDTH pick f!
        float+ swap float+ swap
  LOOP
  2drop ;
[then]

\ unrolled variants of the above
faxpy-nostride-variant 2 = [if]
[defined] matmul-verbose [if] cr .( Forth-2012 with unrolling) cr [then]
    FPCELLWIDTH [if]
        cr .( Forth-2012 code does not work on combined-stack systems) bye
    [then]
\ Forth-2012 version by Anton Ertl
: faxpy-nostride ( ra f_x f_y ucount -- )
    \ vy=ra*vx+vy
    dup >r 3 and 0 ?do
	fdup over f@ f* dup f@ f+ dup f! 
	float+ swap float+ swap
    loop
    r> 2 rshift 0 ?do
	fdup over f@ f* dup f@ f+ dup f! 
	float+ swap float+ swap
	fdup over f@ f* dup f@ f+ dup f! 
	float+ swap float+ swap
	fdup over f@ f* dup f@ f+ dup f! 
	float+ swap float+ swap
	fdup over f@ f* dup f@ f+ dup f! 
	float+ swap float+ swap
    loop
    2drop fdrop ;
[then]

faxpy-nostride-variant 3 = [if]
\ Forth-94 version based on work by
\ by Joel Rees <60f085e8-a418-4670-9e53-310b23a28f3f@googlegroups.com>
[defined] matmul-verbose [if] cr .( Forth-94 by Rees/Ertl with unrolling) cr [then]
fvariable faxpy-ra
: faxpy-nostride ( ra f_x f_y ucount -- )
    \ vy=ra*vx+vy
    >r 2>r faxpy-ra f! 2r>
    r@ 3 and 0 ?DO ( f_x1 f_y1 )
	over f@ faxpy-ra f@ f*
        FPCELLWIDTH pick f@ f+ 
	FPCELLWIDTH pick f!
        float+ swap float+ swap
    LOOP
    r> 2 rshift 0 ?do
	over f@ faxpy-ra f@ f*
	FPCELLWIDTH pick f@ f+ 
        FPCELLWIDTH pick f!
        float+ swap float+ swap
        over f@ faxpy-ra f@ f*
        FPCELLWIDTH pick f@ f+ 
        FPCELLWIDTH pick f!
        float+ swap float+ swap
        over f@ faxpy-ra f@ f*
        FPCELLWIDTH pick f@ f+ 
        FPCELLWIDTH pick f!
        float+ swap float+ swap
        over f@ faxpy-ra f@ f*
        FPCELLWIDTH pick f@ f+ 
        FPCELLWIDTH pick f!
	float+ swap float+ swap
    LOOP
    2drop ;
[then]

faxpy-nostride-variant 15 = [if]
\ in Forth-94 by pahihu <047bed2a-b743-40dc-b978-aa592d3797f9@googlegroups.com>
[defined] matmul-verbose [if] cr .( Forth-94 by pahihu, no unrolling) cr [then]
fvariable faxpy-ra \ should be a user variable
: faxpy-nostride ( ra f_x f_y ucount -- )
    \ vy=ra*vx+vy
    >r 2>r faxpy-ra f! 2r> r>
    0 ?DO ( f_x1 f_y1 )
        >R
        dup float+ swap f@
        faxpy-ra f@ f*
        R@ f@ f+ R@ f!
        R> float+
  LOOP
  2drop ;
[then]

faxpy-nostride-variant 13 = [if]
\ in Forth-94 by pahihu <047bed2a-b743-40dc-b978-aa592d3797f9@googlegroups.com>
[defined] matmul-verbose [if] cr .( Forth-94 by pahihu with unrolling) cr [then]
fvariable faxpy-ra \ should be a user variable
: faxpy-nostride ( ra f_x f_y ucount -- )
    \ vy=ra*vx+vy
    >r 2>r faxpy-ra f! 2r>
    r@ 3 and 0 ?do ( f_x1 f_y1 )
        >R
        dup float+ swap f@
        faxpy-ra f@ f*
        R@ f@ f+ R@ f!
        R> float+
    loop
    r> 2 rshift 0 ?do
        >R
        dup float+ swap f@
        faxpy-ra f@ f*
        R@ f@ f+ R@ f!
        R> float+
        >R
        dup float+ swap f@
        faxpy-ra f@ f*
        R@ f@ f+ R@ f!
        R> float+
        >R
        dup float+ swap f@
        faxpy-ra f@ f*
        R@ f@ f+ R@ f!
        R> float+
        >R
        dup float+ swap f@
        faxpy-ra f@ f*
        R@ f@ f+ R@ f!
        R> float+
    loop
    2drop ;
[then]

: matmulr {: a b c n1 n2 n3 -- :}
    \ C = A x B, where A has n1 rows and n2 columns,
    \ B has n2 rows and n3 columns, and C has n1 rows and n3 columns
    c n1 n3 * floats erase
    n1 0 ?do
	n2 0 ?do
	    a j n2 * i + floats + f@
	    b i n3 * floats +
	    c j n3 * floats +
	    n3 faxpy-nostride
	loop
    loop ;

[defined] want-matmul [if]
: matmul ( a b c ncols nrows -- )
    \ C = A x B for quadratic C, where A has nrows rows and ncols cols
    \ (reversed for B), C has nrows rows and columns
    tuck matmulr ;
[then]
