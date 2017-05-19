: init-matrix {: m ncols nrows nstart -- :}
    \ initialize m with floats nstart, nstart+1, ...
    nstart nrows 0 ?do
	ncols 0 ?do
	    dup 0 d>f m j ncols * i + floats + f! 1+
	loop
    loop
    drop ;

6 floats allocate throw constant a a 2 3 1 init-matrix
6 floats allocate throw constant b b 3 2 7 init-matrix
falign here 9 floats allot constant c

[undefined] f.rdp [if]
    : f.rdp ( r nr nd np -- )
        2drop drop ;
[then]

: mat. {: m ncols nrows -- :}
    nrows 0 ?do
	cr ncols 0 ?do
	    m j ncols * i + floats + f@ 7 0 1 f.rdp space
	loop
    loop ;

\ a 2 3 mat. cr
\ b 3 2 mat. cr
\ a b c 2 3 matmul c 3 3 mat. cr bye
a b c 2 3 matmul

: g, ( n -- )
    s>d d>f f, ;

create d
27 g,  30 g,  33 g,
61 g,  68 g,  75 g,
95 g, 106 g, 117 g,

c 9 floats d 9 floats compare [if]
    cr .( result wrong ) abort
[else]
    [defined] matmul-verbose [if]
	cr .( result correct ) cr
[then]
