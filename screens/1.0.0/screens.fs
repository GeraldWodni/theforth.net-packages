\ screen support     uho 2019-08-24 revicsed 2023-06-19

0 free [IF]
: free ( c-addr -- ior ) \ freeing 0 is ok 
    dup IF free THEN ;
[THEN]

[undefined] slurp-file [IF]
: slurp-file ( c-addr u -- )
  r/o bin open-file throw >r 
  r@ file-size throw Abort" file too large" 
  dup allocate throw swap 
  2dup r@ read-file throw over - Abort" could not read whole file"
  r> close-file throw ;
[THEN]


[undefined] save-mem [IF]
: save-mem ( c-addr1 u1 -- c-addr2 u2 )
   swap >r dup  allocate throw swap 2dup r> -rot move ;
[THEN]

[undefined] $/ [IF]
: $/ ( addr u char -- addr1 u1 addr2 u2 ) 
   >r 2dup r> scan dup >r dup IF  1 /string  ELSE nip 0  THEN 2swap r> - ; 
[THEN]

[undefined] parse-name [IF]

\ : parse-name ( <name> -- )
\    bl word count ;

: parse-name parse-word ;

[THEN]

10 Constant #linefeed
12 Constant #pagebreak

: (screen  ( addr1 u1 u -- addr2 u2 )
    0 max 0 ?DO   #pagebreak $/   2drop  LOOP  
    #pagebreak $/ 2swap 2drop ;

2Variable usefilename  0 0 usefilename 2! 
2Variable fromfilename 0 0 fromfilename 2!

2Variable usefile  0 0 usefile 2!

: file? ( -- ) ." Usefile: " usefilename 2@ type  ."   Fromfile: " fromfilename 2@ type ;

\ : slurp-file ( addr1 u1 -- addr2 u2 ) cr 2dup ." Slurping " type cr slurp-file ;

\ : free ( addr -- ior ) cr dup ." Freeing " u. cr free ;

: "use ( c-addr u -- )
   2dup slurp-file  
   usefile 2@ drop free >r  
   usefile 2!
   usefilename 2@ drop free >r
   fromfilename 2@ drop free >r
   2dup 
   save-mem usefilename 2!  
   save-mem fromfilename 2!
   r> throw r> throw r> throw ;

: use ( <filename> -- )
   parse-name 
   dup 0= IF  2drop  usefilename 2@ >r pad r@ move pad r> THEN 
   "use ;   

: from ( <filename> -- )
   parse-name  2dup  fromfilename 2@ compare 0=  \ same filename?
   IF 2drop EXIT THEN
   fromfilename 2@ drop free >r
   save-mem fromfilename 2!
   r> throw ;

: screen ( u -- )
   >r usefile 2@ r> (screen ;

: line ( addr1 u1 u2 -- addr3 u3 )
   0 max
   0 ?DO #linefeed $/ 2drop LOOP
   #linefeed $/ 2swap 2drop ;

Variable scr

: l ( -- )
     scr @ 0 max scr !  
     page ." Scr " scr @ . 
     scr @ screen 0
     BEGIN 
       >r 2dup r@ line over
     WHILE
       cr r@ 3 u.r space  type
       r> 1+
     REPEAT
     r> drop  2drop 2drop ;


: n ( -- )  1 scr +! l ;
: b ( -- )  -1 scr +! l ;

: list ( u -- ) scr ! l ;



use screenfile.fs


: (thru  ( from to -- )
   1+ swap ?DO
     I scr !  I screen ( c-addr u )
     BEGIN
        #linefeed $/ over 
     WHILE ( c-addr1 u1 c-addr2 u2 )
        2swap >r >r evaluate r> r>
     REPEAT
     2drop 2drop
   LOOP ;


: thru ( from to -- )
     usefilename 2@  fromfilename 2@ compare IF \ new file
        usefile 2@ >r >r usefilename 2@ >r >r         
        fromfilename 2@  slurp-file  usefile 2!
        fromfilename 2@  save-mem usefilename 2!
        scr @ >r
        ['] (thru catch  
        r> scr !
        usefilename 2@ drop free 
        usefile 2@ drop free
        fromfilename 2@ drop free
        r> r> 2dup usefilename 2! save-mem fromfilename 2!
        r> r> usefile 2!
        throw throw throw throw
     ELSE \ same file
        scr @ >r
        ['] (thru catch
        r> scr ! throw
     THEN ;
    
: load ( u -- ) dup thru ;

: +load ( u -- )  scr @ + load ;

: +thru ( +from +to )
   scr @ +  swap scr @ + thru ; 

: ld ( -- )  scr @ load ;

\ : \  10 parse 2drop ; immediate


: index ( from to -- )
     1+ swap ?DO
       cr  I 3 .R   space I screen  0 line   type
     LOOP ;

: qx ( -- )
    scr @  30 / 30 * dup 30 + index ;


: utility ( u <name> -- ) Constant ;

: loads ( u <name> -- ) Create , Does> @ load ;
: by ( u <name> -- )  Create , Does> @ load ;

0 by hi
