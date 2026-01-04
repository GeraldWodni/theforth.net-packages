[IMMEDIATE] for Standard Forth
==============================

Eric Blake <eblake@redhat.com>

Version 0.9.0 - 2025-08-10

This package provides an implementation of `[IMMEDIATE]` on top of ANS
Forth-2012.  It is provided in the public domain.

### Example

Declare RDROP as an immediate word.

    : RDROP [IMMEDIATE] ( R: x -- )
      POSTPONE R> POSTPONE DROP ;

### Background

`[IMMEDIATE]` solves an ambiguity present in the use of `IMMEDIATE`.
In standard Forth, IMMEDIATE is generally non-immediate, and it is
ambiguous if you attempt to use it while a current definition is
underway (for example, ": foo ; : bar [ IMMEDIATE ] ;" differs between
implementations on whether foo or bar is made immediate).  However,
some other Forth variants (including JonesForth) have provided
IMMEDIATE as an immediate, and used the style ": name IMMEDIATE
body... ;", on the grounds that you want to declare intent as soon as
possible, where having to scroll to learn whether a word is immediate
goes against that design principle.

This package works around the ambiguity of IMMEDIATE by adding the
word [IMMEDIATE] which may be safely used within the body of : ;.  If
your Forth supports :NONAME, then [IMMEDIATE] is explicitly a no-op in
the body of :NONAME ;, in order to make it easier to copy-and-paste
definitions without regards to whether the definition will be named or
anonymous.  This package also makes it easy to declare a
meta-programming word ": imm: : POSTPONE [IMMEDIATE]" (although that
word is not provided here).

## Tests

The following tests, in the syntax of John Hayes test framework
`tester.fs`, show expected results.

    t{ : is-immediate ( "name" -- flag ) BL WORD FIND NIP 1 = ; -> }t
    t{ : foo [IMMEDIATE] ; -> }t
    t{ : bar ; -> }t
    t{ :NONAME [IMMEDIATE] ; EXECUTE -> }t
    t{ is-immediate foo -> -1 }t
    t{ is-immediate bar -> 0 }t
    t{ : baz ; [IMMEDIATE] -> }t
    t{ is-immediate baz -> -1 }t
    t{ : imm: ( "name" -- colon-sys ) : POSTPONE [IMMEDIATE] ; -> }t
    t{ imm: my-imm ; -> }t
    t{ is-immediate my-imm -> -1 }t

Tests have been run successfully on

   - [gforth](https://www.gnu.org/software/gforth/), 0.7.3 and 0.7.9
   - [SwiftForth](https://www.forth.com/swiftforth/), 3.12.0

## Bug Reports

Please send bug reports, improvements and suggestions to Eric Blake
<<eblake@redhat.com>>.  See also [this ForthHub
post](github.com/ForthHub/discussion/discussions/197).

## Conformance

This program conforms to Forth-2012

### Standard conformant labeling

---

This is an ANS Forth Program,

    - Requiring the Core word set.
    - Requiring `\ TRUE` from the Core Extensions word set.
    - Requiring `[DEFINED] [IF] [THEN] [UNDEFINED]` from the
      Programming-Tools Extensions word set.
    - Redefining `:NONAME` from the Core Extensions word set if
      available.

    - After loading this program, a Standard System still exists.
