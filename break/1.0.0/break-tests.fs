\ Test BREAK and CONTINUE control structures

include ttester-simple.fs
include break.fs

: noloop   5 = IF 1 BREAK THEN 0 ;
t{ 3 noloop -> 0 }t
t{ 5 noloop -> 1 }t

: begin1 10 BEGIN dup 5 = IF BREAK THEN  dup 1 - AGAIN 99 ;
t{ begin1 -> 10 9 8 7 6 5 99 }t

: begin2 >r  10 BEGIN dup r@ - WHILE  dup 3 = IF BREAK THEN  dup 1 - REPEAT r> drop 99 ;
t{ 5 begin2 -> 10 9 8 7 6 5 99 }t
t{ 1 begin2 -> 10 9 8 7 6 5 4 3 99 }t

: begin3  10 BEGIN dup 3 = IF break THEN  dup 5 = IF BREAK THEN dup 1- AGAIN 99 ;
t{ begin3 -> 10 9 8 7 6 5 99 }t

: begin4  >r 10 BEGIN dup 3 = IF BREAK ELSE dup r@ = IF BREAK THEN THEN dup 1- AGAIN r> drop 99 ;
t{ 5 begin4 -> 10 9 8 7 6 5 99 }t
t{ 2 begin4 -> 10 9 8 7 6 5 4 3 99 }t

: begin5  10 BEGIN dup 1 and IF dup 5 = IF BREAK THEN 
                                dup 3 = IF BREAK THEN THEN 
               dup 1- dup 0=
             UNTIL 99 ;
t{ begin5 -> 10 9 8 7 6 5 99 }t


: continue1 ( -- ) 0
    BEGIN 1+ dup
          dup 5 = IF drop 55 swap CONTINUE 777 THEN  
          dup 7 =
    UNTIL drop 999 ;
t{ continue1 -> 1 2 3 4 55 6 7 999 }t

: collatz ( n -- i*x )
    BEGIN ( n )
       dup
       dup 1 - WHILE 
       dup 1 and IF 3 * 1+ CONTINUE THEN
       2/ 
    REPEAT drop ;

t{ 3 collatz -> 3 10 5 16 8 4 2 1 }t

: doloop1 ( -- ) 10 0 DO   I 5 = IF BREAK THEN   I LOOP ;
: doloop2 ( -- ) 10 0 DO   I 5 = IF BREAK THEN   I 3 = IF BREAK THEN   I LOOP ;
t{ doloop1 -> 0 1 2 3 4 }t
t{ doloop2 -> 0 1 2 }t

: doloop3 ( -- ) 10 0 DO   I 5 = IF CONTINUE THEN I LOOP 99 ;
t{ doloop3 -> 0 1 2 3 4 6 7 8 9 99 }t

: continue-+loop ( -- ) 
   10 0 DO  I 8 = IF BREAK THEN  
            I 4 = IF 2 CONTINUE THEN
            I
        2 +LOOP 99 ;
t{ continue-+loop -> 0 2 6 99 }t

: eaker0 ( -- ) 10 0 DO
    I
    2 over = IF drop  22 22 CONTINUE  ELSE
    3 over = IF drop  33 33 CONTINUE  ELSE
    4 over = IF drop  44              ELSE
    5 over = IF drop  55 BREAK        ELSE
    dup 
    drop THEN THEN THEN THEN
    88
   LOOP 99 ;

t{ eaker0 -> 0 88 1 88 22 22 33 33 44 88 55 99 }t

: eaker1 ( -- ) 10 0 DO
     I CASE
         2 OF  22 22 CONTINUE  ENDOF
         3 OF  33 33 CONTINUE  ENDOF
         4 OF  44              ENDOF
         5 OF  55 BREAK        ENDOF
         dup 
     ENDCASE
     88
   LOOP 99 ;

t{ eaker1 -> 0 88 1 88 22 22 33 33 44 88 55 99 }t




.( break tests done ) cr
