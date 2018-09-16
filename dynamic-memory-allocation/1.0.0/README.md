# dynamic-memory-allocation
Am implementation of Knuth's dynamic memory allocation algorithm in Forth-94

Ulrich Hoffmann <<uho@xlerb.de>>

Version 1.0.0 - 2016-10-30

This package provides an implementation of a dynamic memory scheme as proposed
by Donald E. Knuth [1] and implemented in Forth(-83) by Klaush Schleisiek [2].
It has been updated to Forth-94 and augmented by Ulrich Hoffmann.

The package exposes the standard words `ALLOCATE`, `FREE`, `RESIZE`, and the
words `EMPTY-MEMORY` for initialization and `SIZE` for retrieving the size of 
an allocated block.

## Installation

To use dynamic memory, just `INCLUDE dynamic.fs` on any standard system. This makes
the memory allocation words available. After loading you still have a standard system.

## Documentation

See the file [**glossary.md**](doc/glossary.md) for a description of the defined words.

## Example usage

Initialize memory

    here  10000 dup allot   empty-memory

Allocate memory areas

    500 allocate .  ( -> 0 )
    700 allocate .  ( -> 0 )
    ( two addresses now on the stack )

Resize memory:

    over size .     ( -> 500 )
    dup size .      ( -> 700 )
    1000 resize .   ( -> 0 )  \ enlarge
      50 resize .   ( -> 0 )  \ shrink

Free memory:

    free . ( -> 0 )
    free . ( -> 0 )

## Bug Reports

Please send bug reports, improvements and suggestions to Ulrich Hoffmann <<uho@xlerb.de>>

## Conformance

This program conforms to Forth-94 and Forth-2012.

## References
[1] D. E. Knuth, "The Art of ComputerProgramming", Vol.1, Pg.442, Algorithm C  
[2] K. Schliesiek, ["Dynamic Memory Allocation"](doc/dynamic-memory-schleisiek-forml-88.pdf), FORML 88 Conference Proceedings, p.73ff


May the Forth be with you!
