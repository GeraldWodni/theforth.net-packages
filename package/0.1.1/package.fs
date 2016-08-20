\ this is convoluted, but permits packages to have names
\ that show up in the prompt, ORDER, etc.
[UNDEFINED] WORDLIST: [IF]
: wordlist: ( "name" -- wid )
  >in @ vocabulary dup >in ! also ' execute
  get-order swap >r 1- set-order r>
  swap >in ! dup constant ;
[THEN]

: package ( "name" -- parent package )
  get-current >in @ bl word find if
    nip execute
  else
    drop >in !  wordlist:
  then dup set-current  dup +order ;

: end-package ( parent package -- )
  -order set-current ;

( parent package -- parent package )
: public  over set-current ;
: private dup  set-current ;


\\

: package ( "name" -- parent package )
  if NAME is an existing word, assume it's a package name and
  execute it to get the package wordlist.  Otherwise, create a
  new constant NAME with the value of a new wordlist.

  in either case, 'open' the package by putting package data on
  the stack, setting the current wordlist to the package
  wordlist, and by ensuring that the package wordlist is in the
  search order  ;

: end-package ( parent package -- )
  'close' the package, setting the current wordlist back to
  PARENT, clearing the stack of the package data, and by
  ensuring that the package wordlist is not in the search order ;

: public ( parent package -- parent package )
  set the current wordlist to PARENT - whatever wordlist was
  current when the current package was opened ;

: private ( parent package -- parent package )
  set the current wordlist to PACKAGE ;

\\

  PACKAGE example
  
  defer text
  : ex1  s" This is an example" ;
  ' ex1 is text
  
  PUBLIC
  
  : .example ( -- )  text cr type ;
  
  PRIVATE
  
  : ex2  s" This is an example (cont.)" ;
  
  END-PACKAGE

at this point, .EXAMPLE is a new word in whatever the current
wordlist was, and TEXT EX1 EX2 are all words in the EXAMPLE
wordlist.  EXAMPLE itself is created in the current wordlist if
it didn't already exist.  (if EXAMPLE exists and *isn't* a
package, this is an unchecked error which will probably be
revealed when PUBLIC runs.)

If this code is in a library, code including the library can
then run

  .example .example .example

If there's some need to reopen the package, this is easily
done:

  PACKAGE example

  :noname s" This is yet another example" ;
  is text

  END-PACKAGE

  .example

\\

Why packages?

Forths tend to support indefinite numbers of wordlists, while
having a fixed and limited search order.  So wordlists are
useful when never actually in the search order (as when a
wordlist is used as a data structure, for example as a list of
English words) or when only momentarily in the search order (as
when used by an OOP system to temporarily reveal method names,
or by PACKAGE ... END-PACKAGE where the private words are
temporarily revealed during package definition).

But wordlists are much less useful if you want to partition
your code into wordlists and then assemble all of them into the
search order for an application.  There is a tendency I think
to reach in this direction, get burned (either by system
limitations or by the unpleasantness of manipulating a deep
search order), and then give up on partitioning at all for
normal coding: "nevermind, everything in the FORTH wordlist."

With packages you can go back to the initial impulse and
actually follow it, without getting burned.   You're never
writing PREVIOUS PREVIOUS PREVIOUS PREVIOUS DEFINITIONS and
you're never regretting that you 'beheaded' some word.

A further benefit: if you need to load a package with some
alien definitions, you can put them in a package with the same
name before loading the code, and this will only affect that
package:

  PACKAGE Some-Package
  \ This package's code relies on PLACE appending a NUL byte
  : PLACE ( c-addr1 u c-addr2 -- )  PLACE 0 c, ;
  END-PACKAGE
  include some-lib.fs


PACKAGE comes from SwiftForth, and is also included in the
portability layers for Portable SWOOP.
