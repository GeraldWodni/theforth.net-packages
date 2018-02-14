\ tail-jump.fs	by Ouatu Bogdan Ionut <hum9> ouatubi@gmail.com, under New BSD License
\ 	Provides:
\	';;'       ,
\	':;'	for tail-jump; by default, jumps to current definition beginning;
\
\	'::'	defines a label to beginning of latest compiled definition.
\
\		A label should be paired with ';;' or ':;' , as in example:
\			': word ... ;      :: :word \ label for word'
\				and inside a definition, use tail-call optimization:
\			':word ;;'  for  'word ;'    sequence,
\			':word :;'  for  'word EXIT' sequence.
\   
\	OBS.:	redefines ':' , wich have effect only for tail-jumping words
\
\ Happy factoring!

\ Stack words 
: !+  tuck ! 1 cells + ;
: @-         1 cells - dup @ swap ;

	VARIABLE CS
:noname [ depth negate CS  ! ]
	BEGIN [ depth  CS +! ] AGAIN
; DROP

	\ Compile Stack Storage
	CREATE CS^ CS @ cells allot

: CS!  	CS^  [ CS @ ] LITERAL 0 ?DO !+ LOOP CS ! ; IMMEDIATE
: CS@  	CS @ [ CS @ ] LITERAL 0 ?DO @- LOOP drop
	     [ CS^ CS @ cells + ] LITERAL   CS ! ; IMMEDIATE

: ::    \ Defines a label for a non-local tail-jump
	CREATE HERE [ CS @ cells ] LITERAL allot
	CS^    swap [ CS @ cells ] LITERAL move
	IMMEDIATE
DOES>
	[ CS @ cells ] LITERAL + CS ! ; 

: : : postpone BEGIN postpone CS! ;
: ;;  postpone CS@ postpone AGAIN postpone ; ; IMMEDIATE
: :;  postpone CS@ postpone AGAIN            ; IMMEDIATE

0 [IF]
: bused  dup rot - . ." bytes used" cr ;

: hello ." Hello world!" ; see hello cr

here
: tjump0 dup IF 1- :; THEN ;         see tjump0 here bused 
: tjump1 dup 0= IF EXIT THEN 1- ;;   see tjump1 here bused drop

: tj0 ."  non-local jumped into tj0 beginning." ;   :: :tj0
: tj1 ." From tj1," :tj0 ;;
: tj2 ." From tj2," :tj0 :; ." SUPERFLUOUS!" ;

see :: see :tj0 see tj0 see tj1 see tj2
cr ." tj1 running: " tj1
cr ." tj2 running: " tj2 
cr .s cr BYE
[THEN]
