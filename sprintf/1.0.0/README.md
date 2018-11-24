# Forth-sprintf

Many languages provide a family of PRINTF function either in a library or as part of the language. This package is an implementation of `SPRINTF, PRINTF and FPRINTF` in standard Forth 2012. The functionality is a substantial subset of C PRINTF as described at https://linux.die.net/man/3/printf with a few additions and differences. The detailed specification is in file `printf-spec.md` in this repository. A summary of the functionality provided follows.

It is assumed that the reader is familiar with `PRINTF`, if not there are tutorials and descriptions readily available on the internet.

## User words

`PRINTF ( arguments* format-string -- )` outputs the result to the user terminal

`SPRINTF ( arguments* format-string -- caddr u )` outputs the result into a buffer, returns the result as a string

`FPRINTF ( arguments* format-string fileid -- )` outputs the result into an opened file with identifier fileid.

`SET-SPRINTF-BUFFER ( caddr size -- )` Sets the output buffer for `SPRINTF` only. It is not needed for `PRINTF` or `FPRINTF`. `SET-SPRINTF-BUFFER` must be used before `SPRINTF` is called for the first time following loading - a default buffer is not provided by the system. Several buffers may be used  - it is the user's responsibility to manage multiple buffers

## Installation and testing

Download the files and unzip the files into a directory of your choice.

Following installation it is best to check that it runs successfully on your system by including the test program `sprintftests.fth` which will include the tester and `SPRINTF` source files. Note that if using SwiftForth please type this definition (see the Portability section below):

`create swiftforth`
   
Assuming the Forth system implements floating point, the test output should be:
```
Start of tests
**********************

Six error reports should be displayed:
------
Format string: "This specification %&d is bad"
                                    ^
SPRINTF error: Invalid character
------
Format string: "Not enough %d %d arguments"
                                         ^
SPRINTF error: Too few arguments on the stack
------
Format string: "%*.0u"
                    ^
SPRINTF error: Output buffer overflow
------
Format string: "Buffer not set"
                ^
SPRINTF error: No sprintf buffer set, use SET-SPRINTF-BUFFER
------
Format string: "Not enough %e FP arguments"
                                         ^
SPRINTF error: Too few arguments on the FP stack
------
Format string: "Too many fp formats %f %e %g"
                                           ^
SPRINTF error: FP-ARGS array too small
------
End of tests

-----[ Report ]-------
Stack empty
FP stack depth:      0
Number of tests:   461
Number of errors:    0
----------------------
```
## Usage

To use `sprintf.fth` simply include the file. Note that if your Forth system does not have the standard word `REPRESENT` then it is assumed that floating point has not been implemented and floating point functionality is not compiled.

Example
   `s" Mary" 23 s" My sister %s is %d years old." printf`

displays
   `My sister Mary is 23 years old.`

The arguments must be in the same order as the conversion specifications in the format string. The test program contains many other examples of usage.

## Configuration

There are some user configurable values that can be changed:

`MAX-PRECISION`  the number of digits to be generated by `REPRESENT`, initially set to 15 for 64 bit floating point.

`FP-SEP`  holds the character separating the integer and fractional parts of a floating point number. Initially set to '.'.

`MAX-FP-ARGS`  The maximum number of floating point arguments used in a single `PRINTF` call, initially set to 10.

`MAX-CONV-WIDTH` an upper limit to `PRINTF` field width.

`MAX-CONV-PREC` an upper limit to a conversion's precision.

Exception codes may be changed if they clash with user error codes.

These are Forth `VALUE`s and may be set to other values in a user program instead of changing the `sprintf.fth` source file e.g.
  `10 to MAX-PRECISION`

## Portability

The `SPRINTF` test program has run successfully under Windows 10 on 32 and 64 bit GForth and Win32 Forth with no errors. It runs on VFX Forth and SwiftForth with 1 insignificant error as those systems seem to be unable to handle floating point `-0`. In addition some tests are disabled for SwiftForth as it crashes if attempts are made to test floating point `NAN` or `INF` (hence the advice to create a swiftforth definition above).

## Conversion specifications

The following is just a summary of features, see file `printf-spec.md` for more details 

A conversion specification starts with the character % and takes this form:

   `%<flags><width><precision><length><conversion type>`

Except for the `%` character and `<conversion type>` the fields are optional.

The `<flags>` available are (the flags may be used in any order):.

`#`  an alternative form<br>
`0`  for left justified conversions the output is padded with 0 characters instead of spaces<br>
`-`  the conversion is left justified<br>
`+`  if a signed conversion positive numbers are preceded with a + character<br>
' '  (space character) if a signed conversion positive numbers are preceded with a space character<br>

`<width>` specifies the field width into which the conversion fits.<br>
`<precision>` specifies the minimum number of significant digits to be generated.

`<length>` specified by an l (lower case L) character means the argument is a double length integer. Ignored for floating point conversions<br>

The `<conversion types>` available in this implementation are:

d  for a signed decimal integer conversion<br>
u  for an unsigned decimal integer conversion<br>
x  for an unsigned hexadecimal integer conversion using the a to f characters<br>
X  as for x except that characters A to F are used in the result<br>
o  for an unsigned octal integer conversion<br> 
b  for an unsigned binary integer conversion<br>
r  for an integer conversion where a radix (base) value in the range 2 to 36 is used to convert the integer to a string.<br>
R  as for r except that characters A to Z are used for digits >9<br>
c  for a single character<br>
s  for a string<br>
%  for a % character i.e. the full conversion specification is %%<br>
e  for a floating point number in exponential form \[-\]d.dddde+/-dd where the d's are decimal digits<br>
E  as for e except that the form is \[-\]d.ddddE+/-dd<br>
f  for a floating point number in fractional format in the style \[-\]dddd.ddd<br>
g  for a floating point format where either the e or f type conversion is carried out.<br>
G  As for g except that style E or f is used.
