Recognizers
===========

Matthias Trute <mtrute@web.de>
Version 1.3.1 - 2016-10-10

This package is a collection of recognizer
examples. To play with them a simple implementation
for (old) gforth and VFX is included.
These words are not (yet) able to compile code
or are otherwise integrated into the underlying
system.

Many examples contain test units that illustrate what
the recognizer is supposed to do.

`Recognizer.4th`
----------------
This file in combination with `Stack.4th` gives a
playground for making experiments with recognizers. It
has been tested with gforth versions that currently
come with the linux distributions and MPE's vfxlin (a
random old version from 2014).

`rec-num.4th`
--------------

This file contains four recognizers. They deal with
numbers in various formats and use `>NUMBER` for the
actual number  conversion.

`rec:char ( addr len -- n r:num  | r:fail)`

  Forth 2012 defined the 'c' syntax for single characters.
  That means that `char c` or `[char] c` can be replaced
  with `'c'`.

`rec:snum ( addr len -- n r:num  | r:fail)`

  This recognizer can handle single cell numbers. 
  It honors the number prefixes and the sign characters + and -.

`rec:dnum  ( addr len -- d r:dnum  | r:fail)`

  This recognizer handles double cell numbers. It accepts
  only standard conforming numbers: digits with a trailing
  dot in addition to the prefix and sign character.

These three recognizers are combined in the `rec:num`
recognizer that may be used to handle all number formats
in one call.

`rec-word.4th`
--------------

This file contains a dictionary lookup recognizer. It uses
`FIND` for the actual work thus uses the search order if
present.

`rec-name.4th`
----------------

Another dictionary lookup recognizer. This one does not
depend on `FIND` and searches the standard forth wordlist
only. It returns name tokens instead of the usual 
execution tokens as well.

It requires `TRAVERSE-WORDLIST` and the `NAME>x` words
from Forth 2012 to work. From the future, quotations are 
used too.

`literacy.4th`
--------------

Simple formatting of source code in the
spirit von Don Knuth' literate programming. You can
combine the real source code and its documentation
in one file that the standard forth interpreter
can handle directly.

Actually testing this recognizer requires a Forth that
supports recognizers already.

Author: Julian Fondren, 2014
License: probably public domain.

`rec-time.4th`
--------------

check and convert for the hh:mm:ss notation returning
a double cell number for the number of seconds it
represents.
