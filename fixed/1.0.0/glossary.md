# Glossary

## Implied decimal point

	PLACES ( n -- )
	specify the number of digits behind the decimal point

## Number conversion

	FIXED ( n|d -- f)
	convert single or double length number to fixed point number

## Numeric output words

	(F.) ( f -- addr len)
	convert a fixed point number to a formatted string

	F. ( f -- )
	display a fixed point number

	F.R ( f width -- )
	display a fixed point number right justified in a field of specified width
