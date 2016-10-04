# SFP

Software floating point package with decimal number base

Dr. Heinrich Hohl <<hohl@isartext.de>>

Version 1.0.0 - 2016-10-03

## Introduction

This package provides a compact software floating point package.

The floating point numbers used in this package are represented by a composite single length number. 24 bits are used for the significand, and the top 8 bits for the exponent. Both numbers are based on the decimal system.

The significand must be normalized in order to obtain a valid floating point number. It contains an implied decimal point five digits from the right. Valid significands are:

	Negative: -9.99999 ... -1.00000
	Zero:      0.00000
	Positive: +1.00000 ... +9.99999

This means that floating point numbers have a resolution of 6 decimal digits in total. Zero is always given by 0-sig 0-exp.

The exponent has a range of -128 ... +127.

Floating point numbers are recognized if their syntax is conform with the ANS Forth standard. See [The optional Floating-Point word set][1], in particular section "12.3.7 Text interpreter input number conversion". Examples of valid floating point numbers are:

	1E  1.E  1.E0  +1.23E-1  -1.23E+1

Decimal base is mandatory for input and output of floating point numbers. Note that a capital E is mandatory for the input number conversion. The string conversion routine `>FLOAT` is more tolerant and will recognize D, d, E, e as exponent identifiers.

The unified stack model is used, i.e. floating point numbers are put on the data stack. Stack manipulation and storage is the same as for single length numbers. Synonyms for the related operators have been provided for clarity.

## Decimal number base

Floating point packages are usually based on the binary numbers. This package uses the decimal number base for several reasons:

- I read Martin Tracy's article "Zen Floating Point" in Dr Dobb's Toolbook of Forth II. A floating point package in just one screen! I was impressed by this compact and simple solution. The file [**CHAP18.LST**](CHAP18.LST) contains the original listing that came with the book.

- I needed a small package. Four decimal digits for the significand were sufficient, and only basic arithmetic operations were required. This should be possible without going to binary.

- A small floating point package is easier to develop, test and understand if the used number base is decimal instead of binary. 

- Converting a number from decimal to binary and back may introduce small rounding errors (e.g. 0.100 ends up as 0.099). Because my application was intended to acquire and save data, rounding errors were not acceptable. So I had to stay in the decimal number base.
 
For an excellent discussion on binary vs. decimal floating point, read the following articles:

- [The Floating Point Guide][2]
- [Decimal Arithmetic FAQ][3]

## Versions

The package is available in versions for the following FORTH systems:

|System                  |Standard |Type  |Files                            |
|------------------------|---------|------|---------------------------------|
|PC/FORTH (LMI)          |Forth-83 |16-bit|[sfp16\_lmi.txt](sfp16_lmi.txt)  |
|PC/FORTH (LMI)          |Forth-83 |16-bit|[sfp24k\_lmi.txt](sfp24_lmi.txt) |
|SwiftForth (Forth, Inc.)|ANS Forth|32-bit|[sfp\_sf.f](sfp_sf.f)            |
|VFX Forth (MPE)         |ANS Forth|32-bit|[sfp\_vfx.fth](sfp_vfx.fth)      |

The package was developed under LMI PC/FORTH in 1992. The first version SFP16 used a 16-bit significand and a 16-bit exponent. It had a resolution of 4 decimal digits and was used to acquire, save and plot data in automated measurement systems.

The second version SFP24 was written in 1998 and used a 24-bit significand and an 8-bit exponent. This increased the resolution to 6 decimal digits but required the introduction of triple length number operators.

The LMI version is included for completeness and because someone might still want to use the package on a 16-bit system. It is also instructive to see how much simpler the SFP24 code became after rewriting the package for 32-bit systems.

The following description will concentrate on the 32-bit versions (SwiftForth, VFX Forth) of the package.

## Installation

Use the following commands to install the package:

- SwiftForth: `INCLUDE sfp_sf.f`
- VFX Forth: `INCLUDE sfp_vfx.fth`
 
This makes the fixed point words available. In addition, the number conversion routine of the Forth system is extended: If integer conversion has failed, the system attempts conversion to a floating point number.

## Glossary

The package adds the following words to the system:

	FLOATS FLOAT+
	FLITERAL FCONSTANT FVARIABLE
	F@ F!
	D>F S>F >FLOAT F>D F>S
	PLACES (F.) F. F.R (FS.) FS. FS.R
	FDROP FDUP FOVER FSWAP FROT F2DROP F2DUP F2OVER F2SWAP
	F0= F0<> F= F0< F0>
	FABS FNEGATE F+ F- F* F/ F10* F10/
	F< F> FMAX FMIN
	FSQRT FLOG FALOG

See [**glossary.md**](glossary.md) for stack comments and descriptions of the defined words.

## Usage

`DECIMAL` number base is mandatory for input and output of floating point numbers. Any base may be used for input and output of integers. However, this may cause confusion if numbers contain an "E".

Use `PLACES` to specify the number of places behind the decimal point. 

### Examples

	DECIMAL  5 PLACES
    
	834 .                         --> 834 ok
	22.537 D.                     --> 22537 ok
	17.483E F.                    --> 17.48300 ok
	17.483E FS.                   --> 1.74830E1 ok
	0.1E3 FS.                     --> 1.00000E2

	3.84E4 227.37E-6 F* FS.       --> 8.73100E0
	3.84E4 227.37E-6 F/ FS.       --> 1.68887E8

	947.84E-6 FLOG F.             --> -3.02326 ok

### Important rules

1. On 32-bit systems, fixed point numbers are represented by single length numbers. Although standard words could be used for storage and stack manipulation, you should always use the provided synonyms. This is important for clarity of the code.

2. This package is not intended for extensive number crunching. For these tasks you should rely on a package that utilizes the NDP (Numerical Data Processor) and provides a separate FP stack. 

## Conformance

This package largely conforms to Forth-83 (LMI) and ANS Forth (SwiftForth, VFX). Nonstandard words that should be mentioned:

- `DPL` contains the decimal point location after an integer number conversion has been performed
- `{ ... }` marks block comments in SwiftForth
- `(* ... *)` marks block comments in VFX Forth
- `PACKAGE PRIVATE PUBLIC END-PACKAGE` are used for information hiding in SwiftForth
- `MODULE EXPORT END-MODULE` are used for information hiding in VFX Forth
- `UPPER` converts a character to upper case in SwiftForth
- `UPC` converts a character to upper case in VFX Forth
- `AKA old new` creates a synonym in SwiftForth
- `SYNONYM new old` creates a synonym in VFX Forth

## Acknowledgments

I want to thank Stephen Pelc from MPE who informed me how to patch the floating point number conversion routine into VFX Forth.

[1]: http://forth-standard.org/standard/float

[2]: http://floating-point-gui.de

[3]: http://speleotrove.com/decimal/decifaq.html

