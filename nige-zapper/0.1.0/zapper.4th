\ Zapper - an interactive game for the N.I.G.E.
\ (c)copyright by Gerald Wodni
\ GPLv3 
warm
marker warm

rows 1+ cols * 2* constant screen-size
screen-size buffer: buffer1
screen-size buffer: buffer2

cols constant enemy-size
enemy-size cells buffer: enemies
1 cells constant cell

variable buffer
buffer1 buffer !

\ set text cursor
' csr-x 7 + constant t-x
' csr-y 7 + constant t-y
: t-xy! ( x y -- ) t-y ! t-x ! ;

\ openGL-like double buffering ;)
: swap-buffers ( -- )
	buffer @ screenplace vwait !
 	buffer1 buffer2 + buffer @ - buffer ! ;

\ restore graphics
: exit-game ( -- )
	screenbase screenplace ! ;

\ define colorful chars
: col-char ( col char -- ) create swap 256 * + , does> @ ;
4 250 col-char enemy
3 159 col-char player
7 char : col-char bullet

\ keys
\ system software: put thi in keyboard.f
4 constant up-key
6 constant left-key
7 constant right-key
27 constant esc-key
rows 5 - constant player-y

260132 constant syscount

\ game vars
variable player-x
cols 2 / player-x !

variable level-y 10 level-y !
variable level-counter 0 level-counter !

variable shot-x
cols 2 / shot-x !

variable kills 0 kills !
variable alive -1 alive !

: bounds over swap + ;

\ screen buffer access
: xy ( x y -- addr ) cols * + 2* buffer @ + ;
: xy! ( col-char x y -- ) xy w! ;

: cls-buffer ( -- )
	buffer @ screen-size 0 fill ;

: flush-keys ( -- )
	begin key? while key drop repeat ;

\ update world
: update ( -- )
	\ move foes
	level-counter @ 0 = if
		level-y @ level-counter !
		enemy-size 0 do
			enemies i cells + >r
			1 r@ +!
			r@ @ rows > if
				0 alive !
			then	
			r> drop
		loop
	else
		-1 level-counter +!
	then

	\ check if we hit something
	shot-x @ -1 <> if
		player-x @
		player-y 0 do
			bullet over i xy!
		loop drop
		
		\ perform kill
		enemies shot-x @ cells + >r
		r@ @ 0 > if
			syscount @ 511 and negate r@ !
			1 kills +!
	 	then
		r> drop

		-1 shot-x !
	then ;

: draw ( -- )
	enemy-size 0 do
		enemies i cells + @ 0 > if
			enemy i enemies i cells + @ xy!
		then
	loop

	player player-x @ player-y xy!

	0 0 t-xy!
	." Kills:" kills @ .
	;

: game ( -- )
	\ init-game
	enemy-size 0 do
		syscount @ 511 and negate enemies i cells + !
	loop
	begin
		cls-buffer
		update
		draw
		swap-buffers
		50 ms
		\ handle keys
		key? if		
			key case
				up-key of player-x @ shot-x ! endof
				left-key of player-x @ 1- 0 max player-x ! endof
				right-key of player-x @ 1+ cols 1- min player-x ! endof
				esc-key of 0 alive ! endof
			endcase
		then
		flush-keys
		alive @ 0=
	until
	exit-game
	cls
	." You killed " kills @ . ." foes, congrats commander!" cr ;

game
