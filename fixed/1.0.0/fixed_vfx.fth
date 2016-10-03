(* ====================================================================
  fixed.fth

  Fixed point number package for VFX Forth
  Copyright (c) Dr. Heinrich Hohl, Munich, Germany

  Originally written using LMI PC/FORTH 3.2 (April 1992)
  Published in: Forth-Magazin 'Vierte Dimension' Nr. 2/1992, p.7

  Rewritten for SwiftForth 3.5.6 (December 2014)

  Adapted to VFX Forth 4.72 (September 2016)

  --------------------------------------------------------------------

  A fixed point number (f) is a single length number
  with an implied decimal point at a specified position.

  PLACES is used to specify the position of the implied
  decimal point.

  FIXED can be used immediately after a numeric conversion
  to generate a fixed point number (based on DPL).

  This package is for 32-bit systems. In this case, a fixed
  point number is represented by a single-length number.

  Use standard operators (+, -, *, /, @, !, etc.) with
  fixed point numbers.
  ==================================================================== *)

FORTH DEFINITIONS  DECIMAL

MODULE PRIVATE-FIXED

(* --------------------------------------------------------------------
  Implied decimal point
  -------------------------------------------------------------------- *)

  VARIABLE f#places
\ number of digits to the right of the implied decimal point

: PLACES ( n -- )  0 MAX  f#places ! ;
\ specify the number of digits behind the decimal point

  5 PLACES
\ default setting gives a total resolution of 6 digits

(* --------------------------------------------------------------------
  Number conversion
  -------------------------------------------------------------------- *)

: SHIFT ( n1 n -- n2)
  DUP 0<
  IF    NEGATE
        0  DO  10 /  LOOP
  ELSE  0 ?DO  10 *  LOOP  THEN ;
\ perform decimal right shift (n<0) or left shift (n>0)

: FIXED ( n|d -- f)
  DPL @  1+ 0>  IF D>S THEN
  f#places @  DPL @ 0 MAX  -  SHIFT ;
\ convert single or double length number to fixed point number

(* --------------------------------------------------------------------
  Numeric output words
  -------------------------------------------------------------------- *)

: (F.) ( f -- addr len)
  DUP  ABS 0
  <#  f#places @ 0 ?DO # LOOP  [CHAR] . HOLD  #S  ROT SIGN  #> ;
\ convert a fixed point number to a formatted string

: F. ( f -- )  (F.) TYPE  SPACE ;
\ display a fixed point number

: F.R ( f width -- )  >R  (F.)  R> OVER - SPACES  TYPE ;
\ display a fixed point number right justified in a field of specified width

(* ==================================================================== *)

  EXPORT PLACES
  EXPORT FIXED
  EXPORT (F.)
  EXPORT F.
  EXPORT F.R

END-MODULE
