Modules
=======

Ulrich Hoffmann <<uho@xlerb.de>>

Version 1.0.2 - 2016-04-17

This package provides an implementation of VFX Forth [1] like modules based on Forth-94 wordlists.

## Installation

To use the modules, just `INCLUDE modules.fs` on any standard system. This makes
the module definitions available. After loading you still have a standard system.

## Documentation

See the file [**glossary.md**](glossary.md) for a description of the defined words.

## Example usage

Here is an examples how to use modules:

    MODULE greet
      : hello ( -- )  ." Hello" ;
      : mods  ( -- )  ." Modules" ;

      : hi ( -- )  hello ." , " mods ." !" cr  ;

    EXPORT hi

    END-MODULE

Now only the exported definitions of the module are available.

    hi ( Hello, Modules! ) 
    hello ( not accessible: hello ? )

## Bug Reports

Please send bug reports, improvements and suggestions to Ulrich Hoffmann <<uho@xlerb.de>>

## Conformance

This program conforms to Forth-94 and Forth-2012

May the Forth be with you!

[1] http://www.mpeforth.com/vfxcom.htm
