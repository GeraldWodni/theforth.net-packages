BREAK/CONTINUE-Statements for Standard Forth
============================================

Ulrich Hoffmann <<uho@xlerb.de>>

Version 1.0.0 - 2017-07-25

This package provides an implementation of C like `BREAK` and `CONTINUE` statements
on top of Forth-94 (ANS Forth).

`BREAK` allows to exit the innermost textual enclosing loop. It works for
`BEGIN`-loops as well as for `DO`-loops. `CONTINUE` stops executing the current
loop cycle and restarts the loop in its next cycle.

If no surrounding loop is present then both BREAK and CONTINUE exit the current definition.

### Example

Display whether or not a given number is a prime number.

    : .prime ( n -- )
        dup  1 = 
        IF false swap
        ELSE dup 2 = 
        IF true swap
        ELSE dup  2 mod
        IF true swap 3 
          BEGIN ( f n u )
            2dup dup * >=
          WHILE ( f n u )
            2dup mod 0= IF >r >r drop false r> r> BREAK THEN
            2 +
          REPEAT ( f n u )
          drop
        ELSE
          false swap
        THEN THEN THEN
        . ." is " 0= IF ." not " THEN ." a prime number."
    ;

    1 .prime 1 is not a prime number. ok
    2 .prime 2 is a prime number. ok
    3 .prime 3 is a prime number. ok
    4 .prime 4 is not a prime number. ok
    5 .prime 5 is a prime number. ok
    6 .prime 6 is not a prime number. ok
    7 .prime 7 is a prime number. ok
    8 .prime 8 is not a prime number. ok
    9 .prime 9 is not a prime number. ok

### Background

Some people ask for definitions to provide such a `BREAK` feature for Forth:

>>> Newsgroups: comp.lang.forth  
>>> Date: Wed, 19 Jul 2017 10:22:39 -0700 (PDT)  
>>> In-Reply-To: <0e5dc25f-2fc5-4c27-8587-feb4e6b952e8@googlegroups.com>  
>>> NNTP-Posting-Host: 92.83.227.96  
>>> User-Agent: G2/1.0  
>>> Message-ID: <ac821e97-23ab-4edd-a741-a4429e3991cd@googlegroups.com>  
>>> Subject: Re: A Start With Forth 2017 – new eBook  
>>> From: Raimond Dragomir <raimond....@gmail.com>  
>>> Injection-Date: Wed, 19 Jul 2017 17:22:40 +0000  
>>> Content-Type: text/plain; charset="UTF-8"  
>>>   
>>> [...]  
>>> But I can propose onemyself: make a BREAK word in Swiftforth, VFX and gforth.
>>> a BREAK that's working for EVERY/ANY loop (including the DO LOOPs).
>>> It can be a primitive written in assembler or C or whatever. No need to
>>> be written in ANS forth (chicken or egg problem? no, make it a primitive).
>>> How hard is it? Really hard isn't it? Too hard to really DO IT ?.

So here it is - based on Forth-94 (ANS Forth).  
You can use this implementation as a guideline to incorporate `BREAK` and
`CONTINUE` into specific systems of your choice if your have "carnal knowledge" 
about their inner working.  
*This* implementation only assumes what is ensured by a standard system. 
See section *Implementation* below for details.

Others are not convinced that `BREAK` (and even less `CONTINUE`) is necessary and 
favor a style that leaves loops in definitions by exiting the definition
(via `EXIT` or `UNLOOP EXIT`). 

For example the above definition of `.prime` could have been (separating 
calculation and output) facorized as:

    : divides? ( n u -- f )  mod 0= ;
    : even? ( n -- f ) 2 divides? ;
    : square ( n -- n^2 ) dup * ;

    : prime? ( n -- f )
        dup 1 =   IF drop false EXIT THEN
        dup 2 =   IF drop true  EXIT THEN
        dup even? IF drop false EXIT THEN
        3 BEGIN ( n u )
           2dup square >=
        WHILE ( n u )
           2dup divides? IF 2drop false EXIT THEN
           2 +
        REPEAT ( n u )
        2drop true ;

      : .prime ( n -- ) dup . ." is " prime? 0= IF ." not " THEN ." a prime number" cr ;

If you dare - consult the discussion on comp.lang.forth (Subject: BREAK proposal) of July 2017...

Your milage may vary. Choose wisely.


## Installation

To use the `BREAK` or `CONTINUE`, just `S" break.fs" INCLUDED` on any standard system. This makes
the new words available and redefines the existing control structures accordingly. After loading 
**you don't have a standard system anymore** as e.g. the compilation semantics of `IF` is no 
longer the standard effect on the control flow stack:

    Compilation: ( C: -- orig )

but is now:

    Compilation: ( C: orig_1 ... orig_u|dest -- orig orig_1 ... orig_u|dest )  ( u v loopID --  u v loopID )

to handle branches implied by `BREAK` and `CONTINUE` and to supply information about the surrounding loop.

The package redefines the standard CORE words `BEGIN` `UNTIL` `AGAIN` `WHILE` `REPEAT` `DO` `IF` 
`ELSE` `THEN` `:` `;`  `DOES>` in a non standard way. Compiler extensions that assume their standard
behavior are likely to fail. Their use in ordinary programs should however remain uneffected.

The package also redefines the standard CORE EXT words `:NONAME`  `?DO` `CASE` `OF` `ENDOF` `ENDCASE` and
`AHEAD` from the TOOLS EXT word set if they have already been defined before loading the package.

## Documentation

See the file [**glossary.md**](glossary.md) for a description of the defined words.

## Tests and more example usage

The file `break-tests.fs` contains test definitions based on John Hayes test framework `tester.fs`.
They show additional ways to use `BREAK` and `CONTINUE` and their expected results.

To run the test suite issue `S" break-tests.fs" INCLUDED`. The expected output should look like this

    S" break-tests.fs" INCLUDED  

*some messages warning about redefinitions of standard words*

    break control structure
    break tests done 
    ok

Tests have been run successfully on

   - [gforth](https://www.gnu.org/software/gforth/), 0.7.3 and 0.7.9,
   - [SwiftForth](https://www.forth.com/swiftforth/) 3.6.3 and 
   - [VFX-Forth](http://www.mpeforth.com/software/pc-systems/) 4.7.2

which all use the data stack as control flow stack and also on

   - [FLK](https://github.com/uho/flk.git) 1.3.2

that has a separate control flow stack.

## Pitfalls

The following pitfalls have been identified:

**+LOOP**

When using `CONTINUE` inside `DO` ... `+LOOP` be aware that control flow is transfered directly 
from `CONTINUE` to `+LOOP` in order to start the next loop iteration. Any calculation for the 
loop increment value `n` (see 6.1.0140 +LOOP in the Forth-94 standards document) in front of `+LOOP`
is skipped. An appropriate calculation has to be supplied in front of `CONTINUE` already.

Example:

    : continue-+loop ( -- ) 
           10 0 DO  I 8 = IF BREAK THEN  
                    I 4 = IF 2 CONTINUE THEN
                    I
                2 +LOOP 99 ;
    t{ continue-+loop -> 0 2 6 99 }t

## Implementation

The core idea of this implementation is to hold appropriate branch origins for `BREAK`s and `CONTINUE`s as well as the branch destination
of the beginning of the loop (along with the already existing items there) on top of the control flow stack.

Additional information about the loop is put on top of the data stack. This information is

( u v loopID ) where 

  - u specifies the number of items additionally put on the control flow stack,

  - v specifies the number of used `OF`-`ENDOF` pairs when using a `CASE` structure, and

  - loopID is a loop identifier distinguishing between 
      - `BEGIN`-loops (loopID=1),
      - `DO`-loops (loopID=2), and
      - no loop (loopID=0).

Both `BREAK` and `CONTINUE` compile different code, depending on the kind of loop
they appear in.

`BREAK`

   - inside a `BEGIN`-loop `BREAK` compiles an unconditionals forward branch past the
     end of the loop.

   - inside a `DO`-loop `BREAK` compiles a `LEAVE` statement (which will unravel the
     loop parameters and branch past the particular `LOOP` or `+LOOP`).

   - outside of any loop `BREAK` compiles `EXIT` leaving the current definition.

`CONTINUE`

   - inside a `BEGIN`-loop `CONTINUE` compiles an unconditional branch to the beginning
     of the loop.

   - inside a `DO`-loop `CONTINUE` compiles an unconditional branch just before the
     corresponding `LOOP` or `+LOOP`.

   - outside of any loop `CONTINUE` compiles `EXIT` leaving the current definition.

The package assumes that branches are handled by the underlying standard system:

   - unconditional forward branches by `AHEAD` (resolved by `THEN`)
   - unconditional backward branches by `AGAIN` (to location of `BEGIN`)

As both `BREAK` and `CONTINUE` can occur nested inside (nested) `IF` or `CASE` structures
the information about the surrounding loop must be moved to the top of control flow and 
data stack even inside these structures.

So in essence the package 

   - modifies the behavior of `:` `:noname` `DOES>` `BEGIN`  `DO` and `?DO` to put
     appropriate loop information on the data stack,

   - modifies the behavior of `;` `UNTIL` `AGAIN` `LOOP` `+LOOP` to resolve 
     `BREAK` and `CONTINUE` branches and to clean up loop information,

   - modifies the behavior of `IF` `ELSE` `THEN` `WHILE` `REPEAT` `AHEAD` and redefines 
     `CASE` `OF` `ENDOF` `ENDCASE` so they can handle the additional
     items on the control flow and data stack,

   - defines `BREAK` and `CONTINUE` with the compilation semantics described above.

During compilation of control structures a standard system uses the control flow stack.
It might use the data stack as control flow stack or a separate stack for this purpose. 

Thus a standard *program* (such as this package) must assume the control flow stack 
could be either. It must clear the data stack of any items it puts there by itself 
before using control flow stack dependent words such as the control structures themselves 
or the control flow stack manipulation words `CS-ROLL` and `CS-PICK`.

Note that `CS-ROLL` or `CS-PICK` can only work on `dest` or `orig` items on 
the control flow stack but `DO`-loops also put `do-sys` items there that `CS-ROLL` 
and `CS-PICK` cannot handle. 
This effectively also inhibits access to items below `do-sys`. The same holds for
`CASE`/`OF`and `case-sys`/`of-sys` items. This restricts the manipulation that you can
do on the control flow stack in presence of `DO` or `CASE`.

Please consult the source code `break.fs` for exact details.

## Bug Reports

Please send bug reports, improvements and suggestions to Ulrich Hoffmann <<uho@xlerb.de>>

## Conformance

This program conforms to Forth-94 and Forth-2012

### Standard conformant labeling

---

This is an ANS Forth Program with the environmental dependency of using lower case for standard definition names,

   - Requiring 
     `] [ WORD WHILE UNTIL THEN SWAP REPEAT R@ R> POSTPONE OVER LOOP LEAVE IMMEDIATE IF EXIT ELSE` 
     `DUP DROP DOES> DO CR BL BEGIN >R = ; : 2DROP 1- 1+ 0= +LOOP FIND (` from the Core word set.
   - Requiring `NIP 0<> .( \ ` from the Core Extensions word set.
   - Requiring `[THEN] [IF] CS-ROLL CS-PICK AHEAD` from the Programming-Tools Extensions word set.
   - Redefining `OF ENDOF ENDCASE CASE AGAIN ?DO :NONAME` from the Core Extensions word set if available.

   - **After loading this program, a Standard System does no longer exist**: 
     The program redefines `BEGIN` `UNTIL` `AGAIN` `WHILE` `REPEAT` `DO` `LOOP` `+LOOP` `IF` 
     `ELSE` `THEN` `:` `;`  `DOES>` and possibly `:NONAME` `AHEAD` `?DO` `CASE` `OF` `ENDOF` `ENDCASE`
     in a non standard way adding additional information to the data stack and the control flow stack 
     during compilation to reflect the uses of `BREAK` and `CONTINUE`. Programs that explicitly access the
     control flow stack or use these words in compiler extensions assuming their standard compilation 
     semantics will most likely fail. Programs that just use the control flow structures will remain uneffected.

---

May the Forth be with you!
