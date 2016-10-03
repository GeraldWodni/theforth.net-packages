# Glossary

## Basic data structures

	FLOATS
	FLOAT+
	size of a floating point number is 32 bits = 4 bytes

	FLITERAL ( f -- ) IMMEDIATE
	FCONSTANT ( f -- )
	FVARIABLE ( -- )

	F@ ( addr -- f )
	F! ( f addr -- )

## Number conversion

	D>F ( d -- f)
	convert double length number to float (ignoring DPL)

	S>F ( n -- f)
	convert single length number to float

	>FLOAT ( addr len -- 0 | f -1)
	convert string to floating point number
	special case: blank string returns fp zero

## Numeric output words

	F>D ( f -- d)
	convert floating point number to double length number

	F>S ( f -- n)
	convert floating point number to single length number


	PLACES ( n -- )
	specify the number of digits behind the decimal point


	(F.) ( f -- addr len)
	convert f to a formatted string using fixed-point notation

	F. ( f -- )
	display f in fixed format

	F.R ( f width -- )
	display f right justified in a field of specified width


	(FS.) ( f -- addr len)
	convert f to a formatted string using scientific notation

	FS. ( f -- )
	display f in scientific format

	FS.R ( f width -- )
	display f right justified in a field of specified width

## Basic stack operators

	FDROP ( f1 f2 -- f1)
	FDUP  ( f -- f f )
	FOVER ( f1 f2 -- f1 f2 f3)
	FSWAP ( f1 f2 -- f2 f1)
	FROT  ( f1 f2 f3 -- f2 f3 f1)

	F2DROP ( f1 f2 -- )
	F2DUP  ( f1 f2 -- f1 f2 f1 f2)
	F2OVER ( f1 f2 f3 f4 -- f1 f2 f3 f4 f1 f2)
	F2SWAP ( f1 f2 f3 f4 -- f3 f4 f1 f2)

## Comparison /1/

	F0=  ( f -- ?)
	F0<> ( f -- ?)
	F=   ( f1 f2 -- ?)

	F0< ( f -- ?)
	F0> ( f -- ?)

## Basic arithmetic

	FABS ( f -- f')
	absolute value of floating point number

	FNEGATE ( f -- f')
	negate floating point number

	F+ ( f1 f2 -- f3)
	add floating point numbers

	F- ( f1 f2 -- f3)
	subtract floating point numbers

	F* ( f1 f2 -- f3)
	multiply floating point numbers

	F/ ( f1 f2 -- f3)
	divide floating point numbers

	F10* ( f -- f')
	increase exponent by one (unless f=0)

	F10/ ( f -- f')
	decrease exponent by one (unless f=0)

## Comparison /2/

	F< ( f1 f2 -- ?)
	F> ( f1 f2 -- ?)  F- F0> ;
	compare floating point numbers

	FMAX ( f1 f2 -- f3)
	return greater number (more positive number)

	FMIN ( f1 f2 -- f3)
	return smaller number (more negative number)

## Functions

	FSQRT ( f -- f')
	square root of floating point number

	FLOG ( f -- f')
	decadic logarithm of floating point number

	FALOG ( f -- f')
	decadic exponential function of floating point number
