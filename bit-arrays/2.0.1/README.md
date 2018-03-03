BIT ARRAYS - Accessors for bit-packed arrays of bits for Forth
============================================
Robert Dickow <<dickow@turbonet.com>>
Package bit-arrays
Version 2.0.1 - 2018-03-02

This is a simple word lexicon for accessing arrays of bits. 

The fetching words accept two values: the address of the buffer, and a bit-wise index.

The storing words expect a bit value of 1 or 0 or TRUE or FALSE value, the address of the buffer, and a bit-wise offset. The buffer size should be at least 1 CELLS long.

### Top level words:

`BIT@`  ( caddr n-index -- n0|1 ) \ given a buffer caddr at offset n-index, returns a value of 1 or 0.

`BIT!`  ( n caddr n-index -- ) \ given a TRUE|FALSE or 1|0 value for n, store the bit into buffer caddr at offset n-index 

`BOOL@` ( caddr n-index -- ) \ fetch a TRUE|FALSE value given buffer caddr at offset n-index

`BOOL!` ( n caddr n-index -- ) \ convenience word for BIT!, but accepts a value of TRUE as equally valid as a bit value 1. 

### Include file

bit_arrays.f

### Dependencies

none

### Internal public words:

`^2MASKS` \ a  compiling word to build the bmask lookup table, used internally.

`bmask` \ a lookup table created by ^2MASKS, used internally in the top-level words

`_BIT@`  \ a shared code factoring, probably only useful in the top-level words 

`_HANDLE0` \ an internal word to BIT!

### Usage Example (32 bit CELL machines)

Store a 0 into the 34th bit position in a 64 bit bit array:

\ ************
DECIMAL
\ create the buffer:
CREATE bitbuffer 2 CELLS ALLOT 

\ initialize buffer to all on bits:
4294967295 DUP bitbuffer DUP ROT ROT ! CELL+ !

\ store a bit at position 34
0 bitbuffer 34 BIT!

\ test it: (DU. is unsigned double print )
bitbuffer 2@ BINARY DU. DECIMAL \ displays: 1111111111111111111111111111111111011111111111111111111111111111

\ ************
## Changes

Fixed bug in which ( 0 addr BIT! ) simply toggled the bit if executed a second time.
Simplified code a little bit.
Stack comments and other minor typographical changes. 

## Bug Reports

Please send suggestions, comments, or bug reports Bob Dickow <<dickow@turbonet.com>>

## Compatibility

This lexicon is thought to conform to most Forth standards. It was tested on SwiftForth 3.7.1


