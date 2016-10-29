Recognizers
===========

Matthias Trute <<mtrute@web.de>>
Version 1.2.1 - 2016-10-09

This package is a collection of recognizer
examples. To play with them, simple implementations 
for (old) gforth and VFX are included.
These words are not (yet) able to compile code
or are otherwise integrated into the underlying
system.

Many examples contain test units that illustrate what
the recognizer is supposed to do.

`Recognizer*.4th`
----------------
These files in combination with `Stack.4th` give a
playground for making experiments with recognizers. They
have been tested with gforth versions that usually
come with the linux distributions and MPE's vfxlin (a
random old version from 2014).

The files `Recognizer-gforth.4th` and `Recognizer-vfx.4th`
differ in two aspects only. First is the tester framework.
Gforth supplies the `T{` `}T` words while vfx has the
older `{` `}` pair (and a slightly different filename
to be used). Second is the implementation of
the number recognizers which use existing words that
differ alot.

`rec-char.4th`
--------------

Forth 2012 defined the 'c' syntax for single characters.
That means that `char c` or `[char] c` can be replaced
with `'c'`.

Just load the file and put the `rec:char` at the right
place into the recognizer stack. 

Author: Matthias Trute, 2016
License: public domain.

``rec-num.4th`` and `rec-dnum.4th`
----------------------------------

Recognizer for numbers. They check for exactly one of 
the two cases: single cell or double cell numbers.
The double cell number recognizer strictly follows
the Forth 2012 spec and allows trailing dots only.

They use `>NUMBER` for the actual number conversion,
some features such as signs and base prefixes are
left out. Your system shall have better ones, these
are more educational.

Author: Matthias Trute, 2016
License: public domain.

`literacy.4th`
--------------

Simple formatting of source code in the
spirit von Don Knuth literate programming. You can
combine the real source code and its documentation
in one document that the standard forth interpreter
can handle directly.

Author: Julian Fondren, 2014
License: probably public domain.

`time-rec.4th`
--------------

check and convert for the hh:mm:ss notation returning
a double cell number for the number of seconds it
represents.

Author: Matthias Trute, 2013
License: public domain