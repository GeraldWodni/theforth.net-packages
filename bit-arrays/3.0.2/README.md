BIT ARRAYS - bit-packed array accessor words for Forth
============================================
Robert Dickow <<dickow@turbonet.com>>
Package bit-arrays
Version 3.0.2 - 2018-03-19

This is a simple word lexicon for accessing arrays of bits in memory buffers of arbitary length ( length >= CELL (1 addressing unit) ). 

The fetching words accept two values: the address of the buffer, and a bit-wise offset (index).

The storing words expect a bit value of 1 or 0 or TRUE or FALSE value, the address of the buffer, and a bit-wise offset. The buffer size should be at least CELL bytes.

### Top level words:

`BIT@`  ( addr n-index -- 0|1 ) \ given a buffer addr at offset n-index, returns a value of 1 or 0.

`BIT!`  ( n addr n-index -- ) \ given a TRUE|FALSE or 1|0 value for n, store the bit into buffer addr at offset n-index 

`BOOL@` ( addr n-index -- ) \ fetch a TRUE|FALSE value given buffer addr at offset n-index

`BOOL!` ( n addr n-index -- ) \ convenience word for BIT!, but accepts a value of TRUE as equally valid as a bit value 1. 

### Include file

bit_arrays.f

### Dependencies

none

### Internal public words:

`_BIT@`  \ a shared code factoring, probably only useful in the top-level words 

### Usage Example (shown for 32 bit address unit Forth)

Store a 0 into the 34th bit position in a 64 bit (2 CELLS) long array:

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
## Tests

DECIMAL

2VARIABLE buffer

0 0 buffer 2! \ 64 bits, all 0s

T{ -1 buffer 63 BIT! buffer 2@  -> 1 0 }T \ rightmost (64th) bit now 1

T{ 1 buffer 63 BIT! buffer 2@  -> 1 0 }T \ do again.

T{ buffer 63 BIT@   -> 1  }T  \ read the bit 

T{ 0 buffer 63 BIT! buffer 2@  -> 0 0 }T \ set the bit back to 0

0 0 buffer 2! \ 64 bits, all 0s

T{ -1 buffer 63 BIT! buffer 2@  -> 1 0 }T \ -1 value parameter ok, rightmost (64th) bit now 1

4294967295 buffer 2DUP CELL+ ! ! \ set 64 bits, all 1s

T{ FALSE buffer 0 BOOL! buffer 2@ -> -1 2147483647 }T \ leftmost bit off

T{ buffer 0 BOOL@ -> FALSE }T \ read the bit.


\ ************
## Changes

3.0.2 Patch to fix very bad bug.

3.0.1 Patch to make code work with 64 bit Forths. No affect on 32 bit systems.

(3.0.0) Simplified code by removing some internal words, inlining. Speed improvements and more memory efficient.
Added conditional compilation of NOOP as a do-nothing word if not found in dictionary.

## Bug Reports

Please send suggestions, comments, or bug reports Bob Dickow <<dickow@turbonet.com>>

## Compatibility

This lexicon is thought to conform to most Forth standards. It was tested on SwiftForth 3.7.1


