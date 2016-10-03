(* ====================================================================
  sfp.f

  Software floating point package SwiftForth
  Copyright (c) Dr. Heinrich Hohl, Munich, Germany

  Originally written using LMI PC/FORTH 3.2 (Fall 1992)

  Rewritten for SwiftForth 3.5.6 (December 2014)

  Adapted to VFX Forth 4.72 (September 2016)

  --------------------------------------------------------------------

  The floating point numbers used in this package are represented
  by a composite single length number. 24 bits are used for the
  significand, and the top 8 bits for the exponent.

  Significand: 24 bits (800000 ... FFFFFF 000000 000001 ... 7FFFFF)
               Decimal range: -8,388,608 ... +8,388,607

  Exponent:    8 bits (80 ... FF 00 01 ... 7F)
               Decimal range -128 ... +127

  The significand must be normalized in order to obtain a valid
  floating point number. It contains an implied decimal point
  five digits from the right. Valid significands are:

  Negative: -9.99999 ... -1.00000
  Zero:      0.00000
  Positive: +1.00000 ... +9.99999

  This means that floating point numbers have a resolution of
  6 decimal digits in total. Zero is always given by 0-sig 0-exp.

  Floating point numbers are handled like single length numbers
  with respect to stack operations, storage etc.

  Floating point conversion is appended to the standard number
  conversion routine.

  Decimal base is mandatory for input and output of fp numbers.
  Any base may be used for input and output of integers.
  However, this may cause confusion if numbers contain an "E".
  Decimal base: 4.38E2 --> fp number (4.38 x 10^2)
  Hex base:     4.38E2 -->  d number (438E2 0)
  ==================================================================== *)

FORTH DEFINITIONS  DECIMAL

MODULE PRIVATE-SFP

(* --------------------------------------------------------------------
  Basic data structures
  -------------------------------------------------------------------- *)

  SYNONYM FLOATS CELLS
  SYNONYM FLOAT+ CELL+
\ size of a floating point number is 32 bits = 4 bytes

  SYNONYM FLITERAL LITERAL ( f -- ) IMMEDIATE

  SYNONYM FCONSTANT CONSTANT ( f -- )

  SYNONYM FVARIABLE VARIABLE ( -- )
  SYNONYM F@ @ ( addr -- f )
  SYNONYM F! ! ( f addr -- )

(* --------------------------------------------------------------------
  Supportive variables
  -------------------------------------------------------------------- *)

  VARIABLE fpdpl
\ for temporary storage of significand's decimal point location

  VARIABLE fpexp
\ for temporary storage of an exponent

  VARIABLE fpsign
\ for temporary storage of a sign (significand or exponent)

  2VARIABLE fpstring
\ for temporary storage of original string (addr len)

(* --------------------------------------------------------------------
  Pack and unpack floting point numbers
  -------------------------------------------------------------------- *)

HEX

: 8>32 ( n -- n')
  DUP 00000080 AND
  IF  FFFFFF00 OR  THEN ;
\ sign-extend an 8 bit number to a 32 bit number

: 24>32 ( n -- n')
  DUP 00800000 AND
  IF  FF000000 OR  THEN ;
\ sign-extend a 24 bit number to a 32 bit number

: PACK ( n-sig n-exp -- f)
  0018 LSHIFT                \ shift exponent 24 bits to the left  [ee00|0000]
  SWAP 00FFFFFF AND          \ clear top 8 bits of significand     [00ss|ssss]
  OR ;                       \ combine both numbers to [eess|ssss]
\ pack significand and exponent to a floating point number

: UNPACK ( f -- n-sig n-exp)
  DUP 00FFFFFF AND           \ remove exponent from fp number      [00ss|ssss]
  24>32                      \ sign-extend significand
  SWAP 0018 RSHIFT           \ shift exponent 24 bits to the right [0000|00ee]
  8>32 ;                     \ sign-extend exponent
\ unpack floating point number to significand and exponent

DECIMAL

(* --------------------------------------------------------------------
  Decimal multiplication and division
  -------------------------------------------------------------------- *)

: D10* ( d1 -- d2)  2DUP D2* D2* D+ D2* ;
\ multiply double length number by 10

: D10/ ( d1 -- d2)  1 10 M*/ ;
\ divide double length number by 10

(* --------------------------------------------------------------------
  Numeric input words
  -------------------------------------------------------------------- *)

: DEFLATE ( ud -- ud')
  BEGIN  9.99999 2OVER D<  WHILE  D10/  1 fpexp +!  REPEAT ;
\ deflate significand greater than 9.99999 and adjust exponent

: INFLATE ( u -- u')
  BEGIN  DUP 100000 <  WHILE  10 *  -1 fpexp +!  REPEAT ;
\ inflate significand smaller than 1.00000 and adjust exponent

: NORMALIZE ( d-sig n-exp -- n-sig' n-exp')
  fpexp !                    \ store original exponent
  2DUP D0=                   \ check significand
  IF                         \ d-sig zero: return 0 0
  ELSE                       \ d-sig nonzero: normalize
    DUP 0<  >R               \ save sign of significand
    DABS                     \ prepare for unsigned routines
    DEFLATE                  \ deflate significand if necessary
    D>S                      \ single length is now sufficient
    INFLATE                  \ inflate significand if necessary
    R> IF NEGATE THEN        \ restore sign of significand
    fpexp @                  \ fetch adjusted exponent
  THEN ;
\ normalize significand and adjust exponent accordingly

(* -------------------------------------------------------------------- *)

: D>F ( d -- f)  5 NORMALIZE PACK ;
\ convert double length number to float (ignoring DPL)

: S>F ( n -- f)  S>D D>F ;
\ convert single length number to float

(* -------------------------------------------------------------------- *)

: <SIGN> ( addr len -- addr' len')
  OVER C@
  DUP  [CHAR] - =  DUP fpsign !
  SWAP [CHAR] + =
  OR
  IF  1 /STRING  THEN ;
\ handle leading plus or minus character

: <.DIGITS>  ( ud addr len -- ud' addr' len')
  OVER C@
  [CHAR] . =
  IF  1 /STRING
      DUP >R  >NUMBER  R> OVER -  fpdpl !
  THEN ;
\ handle decimal point and following digits

: APPLY-SIGN ( ud addr len -- d addr len)
  fpsign @
  IF  2SWAP DNEGATE 2SWAP  THEN ;
\ apply sign to converted number

: <SIGNIFICAND> ( 0. addr len -- d addr' len')
  -1 fpdpl !
  DUP 0= IF EXIT THEN
  <SIGN> >NUMBER  DUP IF <.DIGITS> THEN  APPLY-SIGN ;
\ convert significand and return remaining string

: <EXPONENT> ( 0. addr len -- d addr' len')
  DUP 0= IF EXIT THEN
  OVER C@
  [CHAR] E =
  IF  1 /STRING
      DUP IF  <SIGN> >NUMBER APPLY-SIGN  THEN
  THEN ;
\ convert exponent and return remaining string

: <EXPONENT2> ( 0. addr len -- d addr' len')
  DUP 0= IF EXIT THEN
  OVER C@  UPC
  DUP  [CHAR] D =
  SWAP [CHAR] E =
  OR
  IF  1 /STRING  THEN
  DUP IF  <SIGN> >NUMBER APPLY-SIGN  THEN ;
\ same as above, but accept (*D, d, E, e, +, -*) before exponent

: FLOAT ( d-sig n-exp -- f)
  5 +  DPL @  0 MAX  -  NORMALIZE PACK ;
\ convert to float considering significand's DPL

(* -------------------------------------------------------------------- *)

: FCONVERT ( addr len -- 0 | f -1)
  0. 2SWAP <SIGNIFICAND>               \ d-sig addr' len'
  0. 2SWAP <EXPONENT>                  \ d-sig d-exp addr" len"
  NIP                                  \ d-sig d-exp len"
  IF                                   \ d-sig d-exp; conversion failed
    2DROP 2DROP 0                      \ return 0
  ELSE                                 \ d-sig d-exp; conversion successful
    D>S                                \ d-sig n-exp
    fpdpl @ DPL !                      \ restore significand's DPL
    FLOAT -1                           \ return f -1
  THEN ;
\ convert string to floating point number
\ DPL is based on significand conversion (-1 if no decimal point)

: FNUMBER? ( ^str -- 0 | n 1 | d 2 | f -1)
  DUP fpstring !                       \ ^str
  INTEGER?                             \ 0 | n 1 | d 2
  ?DUP IF EXIT THEN                    \ n 1 | d 2; integer conversion successful
  BASE @
  10 <>  IF 0 EXIT THEN                \ 0; fp conversion requires decimal base
  fpstring @  COUNT FCONVERT ;         \ 0 | f -1
\ convert counted string to number
\ attempts fp conversion if VFX's integer conversion has failed

  ASSIGN FNUMBER? TO-DO NUMBER?
\ patch fp number conversion routine into the system

(* -------------------------------------------------------------------- *)

: #FLITERAL ( f1 ... fn n -- )  ABS #LITERAL ;

  ASSIGN #FLITERAL TO-DO C#FLITERAL
\ patch fp literal routine into the system

(* -------------------------------------------------------------------- *)

: >FLOAT ( addr len -- 0 | f -1)
  -TRAILING
  0. 2SWAP <SIGNIFICAND>               \ d-sig addr' len'
  0. 2SWAP <EXPONENT2>                 \ d-sig d-exp addr" len"
  NIP                                  \ d-sig d-exp len"
  IF                                   \ d-sig d-exp; conversion failed
    2DROP 2DROP 0                      \ return 0
  ELSE                                 \ d-sig d-exp; conversion successful
    D>S                                \ d-sig n-exp
    fpdpl @ DPL !                      \ restore significand's DPL
    FLOAT -1                           \ return f -1
  THEN ;
\ convert string to floating point number
\ special case: blank string returns fp zero
\ DPL is based on significand conversion (-1 if no decimal point)

(* --------------------------------------------------------------------
  Numeric output words
  -------------------------------------------------------------------- *)

: DSHIFT ( d n -- d')
  DUP 0<
  IF    NEGATE
        0  DO  D10/  LOOP
  ELSE  0 ?DO  D10*  LOOP  THEN ;
\ perform decimal right shift (n<0) or left shift (n>0)

: F>D ( f -- d)  UNPACK  SWAP S>D  ROT 5 -  DSHIFT ;
\ convert floating point number to double length number

: F>S ( f -- n)  F>D D>S ;
\ convert floating point number to single length number

(* -------------------------------------------------------------------- *)

  VARIABLE f#places
\ number of digits to show behind the decimal point

: (FD.) ( fd -- addr len)
  SWAP OVER DABS
  <#  f#places @ 0 ?DO # LOOP  [CHAR] . HOLD  #S  ROT SIGN  #> ;
\ convert fixed point double length number to formatted string

: ?DECIMAL ( -- )
  BASE @  10 <>  ABORT" base must be decimal" ;

(* -------------------------------------------------------------------- *)

: PLACES ( n -- )  0 MAX  f#places ! ;
\ specify the number of digits behind the decimal point

  5 PLACES
\ default setting based on significand's number range

(* -------------------------------------------------------------------- *)

: (F.) ( f -- addr len)
  ?DECIMAL
  UNPACK  fpexp !
  S>D
  f#places @  5 -  fpexp @  +  DSHIFT  (FD.) ;
\ convert f to a formatted string using fixed-point notation

: F. ( f -- )  (F.) TYPE  SPACE ;
\ display f in fixed format

: F.R ( f width -- )  >R (F.) R>  OVER - SPACES  TYPE ;
\ display f right justified in a field of specified width

(* -------------------------------------------------------------------- *)

: (FS.) ( f -- addr len)
  ?DECIMAL
  UNPACK  fpexp !
  S>D
  f#places @  5 -  DSHIFT  (FD.)
  PAD PLACE   S" E" PAD APPEND   fpexp @ (.) PAD APPEND
  PAD COUNT ;
\ convert f to a formatted string using scientific notation

: FS. ( f -- )  (FS.) TYPE  SPACE ;
\ display f in scientific format

: FS.R ( f width -- )  >R (FS.) R>  OVER - SPACES  TYPE ;
\ display f right justified in a field of specified width

(* --------------------------------------------------------------------
  Basic stack operators
  -------------------------------------------------------------------- *)

  SYNONYM FDROP DROP ( f1 f2 -- f1)
  SYNONYM FDUP  DUP  ( f -- f f )
  SYNONYM FOVER OVER ( f1 f2 -- f1 f2 f3)
  SYNONYM FSWAP SWAP ( f1 f2 -- f2 f1)
  SYNONYM FROT  ROT  ( f1 f2 f3 -- f2 f3 f1)

  SYNONYM F2DROP 2DROP
  SYNONYM F2DUP  2DUP
  SYNONYM F2OVER 2OVER
  SYNONYM F2SWAP 2SWAP

(* --------------------------------------------------------------------
  Comparison /1/
  -------------------------------------------------------------------- *)

  SYNONYM F0=  0=  ( f -- ?)
  SYNONYM F0<> 0<> ( f -- ?)
  SYNONYM F=   =   ( f1 f2 -- ?)

: F0< ( f -- ?)  UNPACK DROP  0< ;
: F0> ( f -- ?)  UNPACK DROP  0> ;

(* --------------------------------------------------------------------
  Basic arithmetic
  -------------------------------------------------------------------- *)

: FABS ( f -- f')
  UNPACK  SWAP ABS SWAP  PACK ;
\ absolute value of floating point number

: FNEGATE ( f -- f')
  UNPACK  SWAP NEGATE SWAP  PACK ;
\ negate floating point number

(* -------------------------------------------------------------------- *)

: F+ ( f1 f2 -- f3)
  FDUP F0= IF FDROP EXIT THEN     \ special case: f2=0
  FSWAP
  FDUP F0= IF FDROP EXIT THEN     \ special case: f1=0
  UNPACK >R
  SWAP
  UNPACK R>                       \ s1 s2 e2 e1
  2DUP MAX fpexp !                \ store greater exponent
  -                               \ s1 s2 (e2-e1)
  DUP 0>                          \ e2 greater exponent?
  IF  >R SWAP R>  THEN            \ yes: s2 s1 (e2-e1)
                                  \ no:  s1 s2 (e2-e1)
  ABS                             \ number of shifts
  DUP 5 >                         \ shifts would exceed significand's range?
  IF
    2DROP fpexp @                 \ return fp number that has greater exponent
  ELSE
    0 ?DO 10 / LOOP               \ perform up to five right shifts
    +                             \ add aligned significands
    S>D  fpexp @
    NORMALIZE
  THEN
  PACK ;
\ add floating point numbers
\ adjust significands according to greater exponent, add,
\ and combine resulting significand with greater exponent

: F- ( f1 f2 -- f3)  FNEGATE F+ ;
\ subtract floating point numbers

(* -------------------------------------------------------------------- *)

: F* ( f1 f2 -- f3)
  UNPACK >R
  SWAP
  UNPACK >R                  \ S: s2 s1  R: e1 e2
  M*                         \ multiply significands
  100000 M/                  \ scale product (10^5)
  S>D
  R> R> +                    \ add exponents
  NORMALIZE PACK ;
\ multiply floating point numbers
\ multiply significands, add exponents

: F/ ( f1 f2 -- f3)
  UNPACK >R
  SWAP
  UNPACK >R                  \ S: s2 s1  R: e1 e2
  1000000 M*                 \ inflate numerator (10^6)
  ROT M/                     \ divide significands
  S>D
  R> R> - 1-                 \ subtract exponents and adjust
  NORMALIZE PACK ;
\ divide floating point numbers
\ divide significands, subtract exponents

(* -------------------------------------------------------------------- *)

: F10* ( f -- f')
  FDUP F0<>  IF  UNPACK 1+ PACK  THEN ;
\ increase exponent by one (unless f=0)

: F10/ ( f -- f')
  FDUP F0<>  IF  UNPACK 1- PACK  THEN ;
\ decrease exponent by one (unless f=0)

(* --------------------------------------------------------------------
  Comparison /2/
  -------------------------------------------------------------------- *)

: F< ( f1 f2 -- ?)  F- F0< ;
: F> ( f1 f2 -- ?)  F- F0> ;
\ compare floating point numbers

: FMAX ( f1 f2 -- f3)
  F2DUP F<  IF FSWAP THEN  FDROP ;
\ return greater number (more positive number)

: FMIN ( f1 f2 -- f3)
  F2DUP F>  IF FSWAP THEN  FDROP ;
\ return smaller number (more negative number)

(* --------------------------------------------------------------------
  Square root
  -------------------------------------------------------------------- *)

  2VARIABLE arg
\ for storage of the argument value

: SQRT ( ud -- u)
  arg 2!
  999999                     \ x_0 starting value
  BEGIN                      \ x
    DUP                      \ x x
    arg 2@  ROT              \ x a. x
    UM/MOD  NIP              \ x (a/x)
    2DUP U>                  \ values not yet final?
  WHILE  + 2/  REPEAT        \ x_new
  D>S ;
\ Newton iteration: x_new = (x + a/x) / 2 for a <= 999999²
\ starting with x_0, x decreases steadily and a/x increases
\ movement stops when x = a/x, i.e. x = sqrt(a)

: FSQRT ( f -- f')
  FDUP F0=  IF EXIT THEN
  UNPACK
  S>D 2 FM/MOD               \ divide exponent by 2 (floored!)
  >R                         \ save new exponent
  IF  1000000                \ mod = 1, exponent was odd:  10^6
  ELSE 100000 THEN           \ mod = 0, exponent was even: 10^5
  UM*                        \ inflate significand
  SQRT                       \ calc new significand (already normalized)
  R>                         \ return new exponent
  PACK ;
\ square root of floating point number
\ scaling factors (10^5 or 10^6) ensure that SQRT returns values
\ in range 100000 ... 999999, i.e. normalized significands

(* --------------------------------------------------------------------
  Decadic logarithm (by table interpolation)
  -------------------------------------------------------------------- *)

CREATE logtable

(  1.0) 0000000 , 0010723 , 0021189 , 0031408 ,
(  1.1) 0041392 , 0051152 , 0060697 , 0070037 ,
(  1.2) 0079181 , 0088136 , 0096910 , 0105510 ,
(  1.3) 0113943 , 0122215 , 0130333 , 0138302 ,
(  1.4) 0146128 , 0153814 , 0161368 , 0168792 ,
(  1.5) 0176091 , 0183269 , 0190331 , 0197280 ,
(  1.6) 0204119 , 0210853 , 0217483 , 0224014 ,
(  1.7) 0230448 , 0236789 , 0243038 , 0249198 ,
(  1.8) 0255272 , 0261262 , 0267171 , 0273001 ,
(  1.9) 0278753 , 0284430 , 0290034 , 0295567 ,

(  2.0) 0301029 , 0306425 , 0311753 , 0317018 ,
(  2.1) 0322219 , 0327358 , 0332438 , 0337459 ,
(  2.2) 0342422 , 0347330 , 0352182 , 0356981 ,
(  2.3) 0361727 , 0366422 , 0371067 , 0375663 ,
(  2.4) 0380211 , 0384711 , 0389166 , 0393575 ,
(  2.5) 0397940 , 0402261 , 0406540 , 0410777 ,
(  2.6) 0414973 , 0419129 , 0423245 , 0427323 ,
(  2.7) 0431363 , 0435366 , 0439332 , 0443262 ,
(  2.8) 0447158 , 0451018 , 0454844 , 0458637 ,
(  2.9) 0462397 , 0466125 , 0469822 , 0473486 ,

(  3.0) 0477121 , 0480725 , 0484299 , 0487845 ,
(  3.1) 0491361 , 0494850 , 0498310 , 0501743 ,
(  3.2) 0505149 , 0508529 , 0511883 , 0515211 ,
(  3.3) 0518513 , 0521791 , 0525044 , 0528273 ,
(  3.4) 0531478 , 0534660 , 0537819 , 0540954 ,
(  3.5) 0544068 , 0547159 , 0550228 , 0553276 ,
(  3.6) 0556302 , 0559308 , 0562292 , 0565257 ,
(  3.7) 0568201 , 0571126 , 0574031 , 0576916 ,
(  3.8) 0579783 , 0582631 , 0585460 , 0588271 ,
(  3.9) 0591064 , 0593839 , 0596597 , 0599337 ,

(  4.0) 0602059 , 0604765 , 0607455 , 0610127 ,
(  4.1) 0612783 , 0615423 , 0618048 , 0620656 ,
(  4.2) 0623249 , 0625826 , 0628388 , 0630936 ,
(  4.3) 0633468 , 0635986 , 0638489 , 0640978 ,
(  4.4) 0643452 , 0645913 , 0648360 , 0650793 ,
(  4.5) 0653212 , 0655618 , 0658011 , 0660391 ,
(  4.6) 0662757 , 0665111 , 0667452 , 0669781 ,
(  4.7) 0672097 , 0674401 , 0676693 , 0678973 ,
(  4.8) 0681241 , 0683497 , 0685741 , 0687974 ,
(  4.9) 0690196 , 0692406 , 0694605 , 0696793 ,

(  5.0) 0698970 , 0701136 , 0703291 , 0705436 ,
(  5.1) 0707570 , 0709693 , 0711807 , 0713910 ,
(  5.2) 0716003 , 0718086 , 0720159 , 0722222 ,
(  5.3) 0724275 , 0726319 , 0728353 , 0730378 ,
(  5.4) 0732393 , 0734399 , 0736396 , 0738384 ,
(  5.5) 0740362 , 0742332 , 0744292 , 0746244 ,
(  5.6) 0748188 , 0750122 , 0752048 , 0753965 ,
(  5.7) 0755874 , 0757775 , 0759667 , 0761551 ,
(  5.8) 0763427 , 0765295 , 0767155 , 0769007 ,
(  5.9) 0770852 , 0772688 , 0774516 , 0776337 ,

(  6.0) 0778151 , 0779957 , 0781755 , 0783546 ,
(  6.1) 0785329 , 0787106 , 0788875 , 0790636 ,
(  6.2) 0792391 , 0794139 , 0795880 , 0797613 ,
(  6.3) 0799340 , 0801060 , 0802773 , 0804480 ,
(  6.4) 0806179 , 0807873 , 0809559 , 0811239 ,
(  6.5) 0812913 , 0814580 , 0816241 , 0817895 ,
(  6.6) 0819543 , 0821185 , 0822821 , 0824451 ,
(  6.7) 0826074 , 0827692 , 0829303 , 0830909 ,
(  6.8) 0832508 , 0834102 , 0835690 , 0837272 ,
(  6.9) 0838849 , 0840419 , 0841984 , 0843544 ,

(  7.0) 0845098 , 0846646 , 0848189 , 0849726 ,
(  7.1) 0851258 , 0852784 , 0854306 , 0855821 ,
(  7.2) 0857332 , 0858837 , 0860338 , 0861832 ,
(  7.3) 0863322 , 0864807 , 0866287 , 0867762 ,
(  7.4) 0869231 , 0870696 , 0872156 , 0873611 ,
(  7.5) 0875061 , 0876506 , 0877946 , 0879382 ,
(  7.6) 0880813 , 0882239 , 0883661 , 0885078 ,
(  7.7) 0886490 , 0887898 , 0889301 , 0890700 ,
(  7.8) 0892094 , 0893484 , 0894869 , 0896250 ,
(  7.9) 0897627 , 0898999 , 0900367 , 0901730 ,

(  8.0) 0903089 , 0904445 , 0905795 , 0907142 ,
(  8.1) 0908485 , 0909823 , 0911157 , 0912487 ,
(  8.2) 0913813 , 0915135 , 0916453 , 0917768 ,
(  8.3) 0919078 , 0920384 , 0921686 , 0922984 ,
(  8.4) 0924279 , 0925569 , 0926856 , 0928139 ,
(  8.5) 0929418 , 0930694 , 0931966 , 0933234 ,
(  8.6) 0934498 , 0935759 , 0937016 , 0938269 ,
(  8.7) 0939519 , 0940765 , 0942008 , 0943247 ,
(  8.8) 0944482 , 0945714 , 0946943 , 0948168 ,
(  8.9) 0949390 , 0950608 , 0951823 , 0953034 ,

(  9.0) 0954242 , 0955447 , 0956648 , 0957846 ,
(  9.1) 0959041 , 0960232 , 0961421 , 0962606 ,
(  9.2) 0963787 , 0964966 , 0966141 , 0967313 ,
(  9.3) 0968482 , 0969648 , 0970811 , 0971971 ,
(  9.4) 0973127 , 0974281 , 0975431 , 0976579 ,
(  9.5) 0977723 , 0978864 , 0980003 , 0981138 ,
(  9.6) 0982271 , 0983400 , 0984527 , 0985650 ,
(  9.7) 0986771 , 0987889 , 0989004 , 0990116 ,
(  9.8) 0991226 , 0992332 , 0993436 , 0994537 ,
(  9.9) 0995635 , 0996730 , 0997823 , 0998912 ,

( 10.0) 1000000 ,

: LOG ( ud -- u)
  2500 UM/MOD                \ mod quot
  40 -                       \ offset to start of table
  CELLS  logtable +          \ addr of left neighbor
  2@                         \ mod y2 y1
  DUP >R
  -                          \ mod y2-y1
  2500 */                    \ dy
  R> + ;                     \ y1+dy
\ interpolate logtable for 1.00000 <= ud <= 9.99999

\ table is given in steps of (x2-x1) = 0.02500 = 2500
\ offset is necessary because table starts at 1.0 (not 0.0)
\ interpolation: if x = x1+dx, y = y1+dy
\ then dy = dx * (y2-y1) / (x2-x1) where dx = mod

: FLOG ( f -- f')
  UNPACK                     \ s e
  1000000 *                  \ s e000000; 6 digits behind decimal point
  SWAP                       \ e000000 s
  S>D LOG                    \ e000000 0ssssss
  + S>D                      \ essssss; new significand
  -1                         \ new exponent; back to 5 digits behind decimal point
  NORMALIZE PACK ;
\ decadic logarithm of floating point number
\ log(s*10^e) = e + log(s)

(* --------------------------------------------------------------------
  Decadic exponential function (by table interpolation)
  -------------------------------------------------------------------- *)

CREATE alogtable

( 0.00)  100000 , 100577 , 101157 , 101741 ,
( 0.01)  102329 , 102920 , 103514 , 104111 ,
( 0.02)  104712 , 105317 , 105925 , 106536 ,
( 0.03)  107151 , 107770 , 108392 , 109018 ,
( 0.04)  109647 , 110280 , 110917 , 111557 ,
( 0.05)  112201 , 112849 , 113501 , 114156 ,
( 0.06)  114815 , 115478 , 116144 , 116815 ,
( 0.07)  117489 , 118168 , 118850 , 119536 ,
( 0.08)  120226 , 120920 , 121618 , 122320 ,
( 0.09)  123026 , 123737 , 124451 , 125169 ,

( 0.10)  125892 , 126619 , 127350 , 128085 ,
( 0.11)  128824 , 129568 , 130316 , 131069 ,
( 0.12)  131825 , 132586 , 133352 , 134121 ,
( 0.13)  134896 , 135675 , 136458 , 137246 ,
( 0.14)  138038 , 138835 , 139636 , 140442 ,
( 0.15)  141253 , 142069 , 142889 , 143714 ,
( 0.16)  144543 , 145378 , 146217 , 147061 ,
( 0.17)  147910 , 148764 , 149623 , 150487 ,
( 0.18)  151356 , 152229 , 153108 , 153992 ,
( 0.19)  154881 , 155775 , 156675 , 157579 ,

( 0.20)  158489 , 159404 , 160324 , 161250 ,
( 0.21)  162181 , 163117 , 164058 , 165006 ,
( 0.22)  165958 , 166916 , 167880 , 168849 ,
( 0.23)  169824 , 170804 , 171790 , 172782 ,
( 0.24)  173780 , 174783 , 175792 , 176807 ,
( 0.25)  177827 , 178854 , 179887 , 180925 ,
( 0.26)  181970 , 183020 , 184077 , 185139 ,
( 0.27)  186208 , 187283 , 188364 , 189452 ,
( 0.28)  190546 , 191646 , 192752 , 193865 ,
( 0.29)  194984 , 196110 , 197242 , 198380 ,

( 0.30)  199526 , 200678 , 201836 , 203001 ,
( 0.31)  204173 , 205352 , 206538 , 207730 ,
( 0.32)  208929 , 210135 , 211348 , 212569 ,
( 0.33)  213796 , 215030 , 216271 , 217520 ,
( 0.34)  218776 , 220039 , 221309 , 222587 ,
( 0.35)  223872 , 225164 , 226464 , 227771 ,
( 0.36)  229086 , 230409 , 231739 , 233077 ,
( 0.37)  234422 , 235776 , 237137 , 238506 ,
( 0.38)  239883 , 241268 , 242661 , 244061 ,
( 0.39)  245470 , 246888 , 248313 , 249746 ,

( 0.40)  251188 , 252638 , 254097 , 255564 ,
( 0.41)  257039 , 258523 , 260015 , 261517 ,
( 0.42)  263026 , 264545 , 266072 , 267608 ,
( 0.43)  269153 , 270707 , 272270 , 273841 ,
( 0.44)  275422 , 277012 , 278612 , 280220 ,
( 0.45)  281838 , 283465 , 285101 , 286747 ,
( 0.46)  288403 , 290068 , 291742 , 293426 ,
( 0.47)  295120 , 296824 , 298538 , 300261 ,
( 0.48)  301995 , 303738 , 305492 , 307255 ,
( 0.49)  309029 , 310813 , 312607 , 314412 ,

( 0.50)  316227 , 318053 , 319889 , 321736 ,
( 0.51)  323593 , 325461 , 327340 , 329230 ,
( 0.52)  331131 , 333042 , 334965 , 336899 ,
( 0.53)  338844 , 340800 , 342767 , 344746 ,
( 0.54)  346736 , 348738 , 350751 , 352776 ,
( 0.55)  354813 , 356861 , 358921 , 360994 ,
( 0.56)  363078 , 365174 , 367282 , 369402 ,
( 0.57)  371535 , 373680 , 375837 , 378007 ,
( 0.58)  380189 , 382384 , 384591 , 386812 ,
( 0.59)  389045 , 391291 , 393550 , 395822 ,

( 0.60)  398107 , 400405 , 402717 , 405041 ,
( 0.61)  407380 , 409732 , 412097 , 414476 ,
( 0.62)  416869 , 419275 , 421696 , 424130 ,
( 0.63)  426579 , 429042 , 431519 , 434010 ,
( 0.64)  436515 , 439035 , 441570 , 444119 ,
( 0.65)  446683 , 449262 , 451855 , 454464 ,
( 0.66)  457088 , 459726 , 462381 , 465050 ,
( 0.67)  467735 , 470435 , 473151 , 475882 ,
( 0.68)  478630 , 481393 , 484172 , 486967 ,
( 0.69)  489778 , 492606 , 495450 , 498310 ,

( 0.70)  501187 , 504080 , 506990 , 509917 ,
( 0.71)  512861 , 515822 , 518800 , 521795 ,
( 0.72)  524807 , 527837 , 530884 , 533949 ,
( 0.73)  537031 , 540132 , 543250 , 546386 ,
( 0.74)  549540 , 552713 , 555904 , 559113 ,
( 0.75)  562341 , 565587 , 568852 , 572136 ,
( 0.76)  575439 , 578761 , 582103 , 585463 ,
( 0.77)  588843 , 592243 , 595662 , 599100 ,
( 0.78)  602559 , 606038 , 609536 , 613055 ,
( 0.79)  616595 , 620154 , 623734 , 627335 ,

( 0.80)  630957 , 634599 , 638263 , 641948 ,
( 0.81)  645654 , 649381 , 653130 , 656901 ,
( 0.82)  660693 , 664507 , 668343 , 672202 ,
( 0.83)  676082 , 679986 , 683911 , 687859 ,
( 0.84)  691830 , 695824 , 699841 , 703882 ,
( 0.85)  707945 , 712032 , 716143 , 720277 ,
( 0.86)  724435 , 728618 , 732824 , 737055 ,
( 0.87)  741310 , 745589 , 749894 , 754223 ,
( 0.88)  758577 , 762956 , 767361 , 771791 ,
( 0.89)  776247 , 780728 , 785235 , 789768 ,

( 0.90)  794328 , 798913 , 803526 , 808164 ,
( 0.91)  812830 , 817523 , 822242 , 826989 ,
( 0.92)  831763 , 836565 , 841395 , 846252 ,
( 0.93)  851138 , 856051 , 860993 , 865964 ,
( 0.94)  870963 , 875991 , 881048 , 886135 ,
( 0.95)  891250 , 896396 , 901571 , 906775 ,
( 0.96)  912010 , 917275 , 922571 , 927897 ,
( 0.97)  933254 , 938642 , 944060 , 949510 ,
( 0.98)  954992 , 960505 , 966050 , 971627 ,
( 0.99)  977237 , 982878 , 988553 , 994260 ,

( 1.00) 1000000 ,

: ALOG ( u -- u')
  250 /MOD                   \ mod quot
  CELLS  alogtable +         \ addr of left neighbor
  2@                         \ mod y2 y1
  DUP >R
  -                          \ mod y2-y1
  250 */                     \ dy
  R> + ;                     \ y1+dy
\ interpolate alogtable for 0.00000 <= ud <= 0.99999

\ table is given in steps of (x2-x1) = 0.00250 = 250
\ interpolation: if x = x1+dx, y = y1+dy
\ then dy = dx * (y2-y1) / (x2-x1) where dx = mod

: FALOG ( f -- f')
  UNPACK                     \ s e
  SWAP S>D ROT               \ d-sig n-exp
  DSHIFT                     \ fd (fixed point double length number)
  100000 FM/MOD              \ mod quot
  SWAP ALOG                  \ calc new significand (already normalized)
  SWAP                       \ return new exponent
  PACK ;
\ decadic exponential function of floating point number
\ 10^(a.bbbbb) = 10^(a+0.bbbbb) = 10^(0.bbbbb)*10^a

\ 100000 FM/MOD SWAP splits up the fixed point number
\  6.12345 is split into  6 and 0.12345
\ -6.12345 is split into -7 and 0.87655
\ floored division is required for negative f numbers

(* ==================================================================== *)

  EXPORT FLOATS
  EXPORT FLOAT+
  EXPORT FLITERAL
  EXPORT FCONSTANT
  EXPORT FVARIABLE
  EXPORT F@
  EXPORT F!

  EXPORT D>F
  EXPORT S>F

  EXPORT >FLOAT

  EXPORT F>D
  EXPORT F>S

  EXPORT (F.)
  EXPORT F.
  EXPORT F.R
  EXPORT (FS.)
  EXPORT FS.
  EXPORT FS.R

  EXPORT FDROP
  EXPORT FDUP
  EXPORT FOVER
  EXPORT FSWAP
  EXPORT FROT
  EXPORT F2DROP
  EXPORT F2DUP
  EXPORT F2OVER
  EXPORT F2SWAP

  EXPORT F0=
  EXPORT F0<>
  EXPORT F=
  EXPORT F0<
  EXPORT F0>

  EXPORT FABS
  EXPORT FNEGATE

  EXPORT F+
  EXPORT F-
  EXPORT F*
  EXPORT F/

  EXPORT F10*
  EXPORT F10/

  EXPORT F<
  EXPORT F>
  EXPORT FMAX
  EXPORT FMIN

  EXPORT FSQRT

  EXPORT FLOG
  EXPORT FALOG

END-MODULE