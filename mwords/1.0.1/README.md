mwords, voc-mwords
============

Martin Bitter <martin.bitter@forth-ev.de>

Version 1.0.0 - 2016-04-28

This package provides an implementation of two words *mwords* and *voc-mwords* for searching words that match a given string.



## Installation

To use *mwords* and *voc-mwords*, just `INCLUDE mwords.fs` on any **Forth-2012** system. After loading you still have a standard system.

## Documentation

Some Forthes like gforth come in the standard installation with a lot of words. In gforth the vocabulary *forth* holds about 2000 words. Not to mention other vocabularies like *assembler* or *environment*. 

It often happens to me that I remember only a part of a words name or that I don’t remember if some special flavour of a word exists in gforth. So I find it very handy to look in a vocabulary for all words that match a given string. Therefore I wrote the word *mwords*. You could read it as match-words. A step further is *voc-mwords* which does the same as *mwords* but looks in all vocabularies. For handiness reasons the given string is parsed, that means it comes behind the invocation of *mwords* or *voc-mwords*.

*mwords* and *voc-mwords* are caps-ignoring i.e. searching for dup, DUP, Dup, dUp, etc. give the same results.

*mwords* and *voc-mwords* find all instances of a matching word. If there is a word overwritten by newer definitions the older versions will be shown too.

## Example usage

Here are some examples how to use mwords:

Look for all words in the current wordlist that include `dup` in their names

`mwords dup`  

>>**?DUP-0=-IF ?DUP-IF fdup 2dup ?dup dup ?dup-0=-?branch ?dup-?branch  ok**

Don't remember if gforth has a words `?DO`? Just type:

`mwords ?do`  

>>**[?DO] ?DO ?do-like (?do)  ok** 

Is there a assembler version of `BEGIN`? Just type:

`voc-mwords begin`

>>**Vocabulary: assembler** 

>>>>**BEGIN**

>>**Vocabulary: Forth**

>>>>**begin-structure (begin-like) check-begin [BEGIN] BEGIN begin-like  ok**


## Bug Reports

Please send bug reports, improvements and suggestions especially of typos and crude using of English to Martin Bitter <martin.bitter@forth-ev.de>

## Conformance

This program is tested with gforth. It should conform to Forth-2012.

May the Forth be with you!
