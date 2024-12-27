\ Screen 0 (zero)

[defined] ***empty*** [IF] ***empty*** [THEN]
marker ***empty***

\ This is a sample screen file, a file with screens separated
\ by formfeed characters. You can use LIST L N B INDEX QX to 
\ inspect its content screen by screen,
\ 
\ This file demonstrates also loading screens.
\ 
\   0 LOAD
\ 
\ will load this screen which will load screen 1.
\ Screen 1 then loads Screen 2 to defines COUNTUP that 
\ screen 1 uses after that.
\ 
\ It then defines a load word ----- that loads screen 5 whenever 
\ invoked. 
\ 
\ Nested loading from another file is achieved by the use of FROM
\ that specifies the file that will be used by the next LOAD or THRU.
\ Screen 1 uses FROM to load screen 1 and 3 from the 
\ file secondary_screenfile.fs

cr .( Beginning of screen 0 )

cr .( loading 1 )  1 load

cr .( End of screen 0 )

\ Screen 1 (one)

cr .( Beginning of screen 1 )

cr .( loading 2 )  2 load

cr .( Back on screen 2 )

cr 5 countup

5 loads -----

-----

from secondary_screenfile.fs  1 load

-----

from secondary_screenfile.fs  3 load

-----

3 4 thru

-----

from secondary_screenfile.fs 3 4 thru

-----

cr .( End of screen 1 )

\ Screen 2 (two)

cr .( Beginning of screen 2 )

: countup ( u -- )  0 ?DO I . LOOP ;

cr .( End of screen 2 )

\ Screen 3 (three)

cr .( screenfile.fs 3 )

\ Screen 4 (four)

cr .( screenfile.fs 4 )

\ Screen 5 (five)

cr .( ---------------------------------- )