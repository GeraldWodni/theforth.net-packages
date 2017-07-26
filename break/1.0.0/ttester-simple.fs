\ This file contains the code for ttester, a utility for testing Forth words,
\ as developed by several authors (see below), together with some explanations
\ of its use.

\ ttester is based on the original tester suite by Hayes:
\ From: John Hayes S1I
\ Subject: tester.fr
\ Date: Mon, 27 Nov 95 13:10:09 PST  
\ (C) 1995 JOHNS HOPKINS UNIVERSITY / APPLIED PHYSICS LABORATORY
\ MAY BE DISTRIBUTED FREELY AS LONG AS THIS COPYRIGHT NOTICE REMAINS.
\ VERSION 1.1

\ This is a vastly simplified version stripped down to the basics.

: empty-stack ( i*x -- )
   BEGIN depth ?dup WHILE
      0< IF 0 ELSE drop THEN
   REPEAT ;

: error ( c-addr u -- ) cr type  source type cr empty-stack ;

Variable context-depth
Variable actual-depth

base @ hex
  20 Constant #stack
base !

Create actual-results #stack cells allot
: >actual-results ( i -- addr  )  cells actual-results + ;
: %depth ( -- u )  depth context-depth @ - ;

: t{  ( -- )
   depth context-depth ! ;

: -> ( i*x -- ) \ record depth and stack content
   %depth dup actual-depth !
   dup #stack > Abort" Test-Stack size exceeded - increase #stack"
   ?dup 0= IF exit THEN
   0 DO  I >actual-results ! LOOP ;

: }t     ( i*x -- ) \ compare stack (expected) contents with saved actual content
   %depth actual-depth @ =
   IF %depth ?dup
      IF  0 DO  I >actual-results @ -
                IF S" *** Incorrect result: " error LEAVE THEN
            LOOP
      THEN
   ELSE
      S" *** Wrong number of results: " error
   THEN ;

Variable verbose  1 verbose !

: testing ( -- )
   source  verbose @  IF dup >r cr type  r> >in !
                      ELSE >in !  drop THEN ;


