BIT ARRAYS - Accessors for bit-packed arrays of bits for Forth
============================================
Robert Dickow <<dickow@turbonet.com>>
Package bit-arrays
Version 1.0.2 - 2018-03-02

This is a simple word lexicon for accessing arrays of bits. 

The fetching words accept two values, the address of the buffer, and a bit-wise index. The storing words accept a bit value or a boolean value, the address of the buffer, and a bit-wise index. The buffer size should be at least 1 CELLS long.

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

`2^`   ( n -- 2^n )   \ calculates the nth power of 2, used by the ^2MASKS compiling word, kept for consistency with earlier v 1.0.x


`^2MASKS` \ a  compiling word to build the bmask lookup table, used internally.

`bmask` \ a lookup table created by ^2MASKS, used internally in the top-level words

`_BIT@`  \ a shared code factoring, probably only useful in the top-level words 



### Usage Example (32 bit CELL machines)

store a 0 into the 34th bit position in a 64 bit bit array.

\ ************
DECIMAL
\ create the buffer:
CREATE bitbuffer 2 CELLS ALLOT 

\ initialize buffer to all on bits:
4294967295 DUP bitbuffer DUP ROT ROT ! CELL+ !

\ store a bit at position 34
0 bitbuffer 34 BIT!

\ test it:
bitbuffer 2@ binary du. decimal \ displays: 1111111111111111111111111111111111011111111111111111111111111111

\ ************
## Changes

2^ now uses bit shifts instead of a slower calculation in loops.
Stack comments and other minor typographical changes. 


## Bug Reports

Please send suggestions, comments, or bug reports Bob Dickow <<dickow@turbonet.com>>

## Compatibility

This lexicon is thought to conform to most Forth standards. It was tested on SwiftForth 3.7.1


