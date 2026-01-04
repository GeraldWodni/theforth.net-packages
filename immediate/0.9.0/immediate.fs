\ This file is in the public domain. NO WARRANTY.

\ Originally designed by Eric Blake, August 2025,
\ with revisions inspired by ruv.

\ Add the word [IMMEDIATE] which can be used to mark the intent of defining
\ an immediate word sooner than waiting until the closing ;.

\ The goal of this file is to permit the following:
\   : name [IMMEDIATE] ... ;
\ as syntax sugar for
\   : name ... ; IMMEDIATE
\ to satisfy the mantra "say what you are doing as soon as you can":
\ https://forth-standard.org/standard/core/IMMEDIATE#reply-313

\ First, note that there is an ambiguity observable between implementations
\ on the following code:
\    : foo ." foo " ;
\    : bar [ immediate ] ." bar " ;
\ where some implementations (gforth, SwitfForth, VFX) mark bar as
\ immediate, and others (iForth) mark foo as immediate.
\ https://forth-standard.org/standard/core/IMMEDIATE#contribution-112

\ Forth-2012 16.3.3 basically states that it is ambiguous if a program
\ modifies the compilation word list during compilation, but the purpose
\ of IMMEDIATE is to change the compilation list by making the latest
\ definition immediate.  So, regardless of whether : is required to make
\ the latest definition be the ongoing compilation, actually executing
\ IMMEDIATE before ; triggered ambiguous behavior.

\ At the same time, the standard requires this test to pass:
\   T{ : IW9 CREATE , DOES> @ 2 + IMMEDIATE ; -> }T
\   : FIND-IW BL WORD FIND NIP ;  ( -- 0 | 1 | -1 )
\   T{ 222 IW9 IW10 FIND-IW IW10 -> -1 }T   \ IW10 is not immediate
\   T{ IW10 FIND-IW IW10 -> 224 1 }T        \ IW10 becomes immediate
\ Basically, once the DOES> body is installed into iw10, then any future
\ execution of iw10 invokes IMMEDIATE on whatever happens to be the most
\ recently compiled word.  Furthermore, while not explicitly shown in
\ the test, it is worth noting that IW9 was not marked immediate; an
\ implementation where IMMEDIATE is immediate is unlikely to pass this
\ test, and an immediate word [IMMEDIATE] must be sure that actually
\ invoking IMMEDIATE does not happen before ; completes.
\ https://forth-standard.org/standard/testsuite#test:core:IMMEDIATE

\ Furthermore, the fact that IMMEDIATE has traditionally been non-immediate
\ means that there is an existing corpus of code that expects to be able
\ to build meta-programming words, such as:
\   : nop : POSTPONE ; IMMEDIATE ;
\   nop filler
\ which should make filler, rather than nop, be immediate.  This file does
\ not change that behavior.  Although this file does not declare imm:, it
\ also makes it easy to declare
\   : imm: ( "name" -- colon-sys ) : POSTPONE [IMMEDIATE] ;
\ as a way to write "imm: name" instead of ": name [IMMEDIATE]" for an
\ alternative way to declare intent of defining an immediate macro.

\ The standard is clear that IMMEDIATE is ambiguous if used when the last
\ definition was via :NONAME or SYNONYM; this file does not remove that
\ ambiguity when there is no current definition (doing so would require
\ wrapping every defining word, which does not scale), so [IMMEDIATE] is
\ likewise ambiguous in those situations.  However, this file does ensure
\ that [IMMEDIATE] between :NONAME and ; is well-defined to do nothing.
\ The reason for this is so that it becomes easier to copy and paste a
\ definition body without regards to whether the definition was started
\ by ": name" or ":NONAME".

\ Implementations that provide other modifiers that affect the most recent
\ definition, such as compile-only or restrict, should be able to do similar
\ wrappers for those words to declare intent at the name of a definition.
\ Likewise, if you rely on the implementation-defined behavior of CODE or
\ ;CODE, you may want those words to have similar treatment to what this
\ file does for :.

\ Standard forth does not provide an easy interface to see if a given nt or
\ xt is immediate, although several implementations provide a word
\ "immediate?" for that purpose.  For debugging the effects of this file,
\ it is possible to write a parsing word that is portable:
\   \g Parsing word to display whether the next word is immediate.
\   [DEFINED] immediate? [IF] : imm ( "word" -- ) ' immediate? . ;
\   [ELSE] : imm BL WORD FIND NIP 1 = . ; [THEN]
\ And implementations that support SEARCH-WORDLIST can avoid the need to parse:
\   t{ S" [IMMEDIATE]" GET-CURRENT SEARCH-WORDLIST NIP 1 = -> TRUE }t

\ Dependencies:
\ Requires the following words from the Core word set
\  ! ( : ; ['] 0< ?DUP EXECUTE EXIT IF IMMEDIATE POSTPONE SWAP THEN VARIABLE
\ Requires the following words from the Core Extension word set
\  \ TRUE
\ Requires the following words from the Tools Extension word set
\  [DEFINED] [IF] [THEN] [UNDEFINED]

\ Compatibility stuff, inspired by gforth

\ document a word that is ambiguous to use outside of compilation semantics
[UNDEFINED] compile-only [IF] : compile-only ; [THEN]

\ specialized tag to distinguish documentation strings from internal comments
[UNDEFINED] \g [IF] : \g ['] \ EXECUTE ; IMMEDIATE [THEN]

\ convenience for altering the contents of a variable
[UNDEFINED] off [IF] : off 0 SWAP ! ; [THEN]
[UNDEFINED] on [IF] : on TRUE SWAP ! ; [THEN]

\ Implementation

\ Integer tracking whether there is an ongoing definition body.  1 after
\ :NONAME, -1 after :, and 0 after ;.
VARIABLE (defining) 0 (defining) !
\ Flag set when ; needs to perform a delayed IMMEDIATE.
VARIABLE (needs-immediate) (needs-immediate) off

\ Wrap ; to honor (needs-immediate) and clear (defining).
: ; ( C: colon-sys -- )
  \g Complete a colon-sys after appending run-time semantics of
  \g ( R: nest-sys -- ) to the current definition.
  POSTPONE ;
  (needs-immediate) @ IF
    IMMEDIATE  \ uses original non-immediate word
    (needs-immediate) off
  THEN
  (defining) off
; IMMEDIATE compile-only

\ Wrap : to delay [IMMEDIATE] by setting (defining).
: : ( C: "<spaces>name" -- colon-sys )
  \g Begin a colon definition for /name/.
  :
  -1 (defining) !
  (needs-immediate) off \ resest the flag after errors, if any
;

\ Wrap :NONAME to ignore [IMMEDIATE] by setting (defining).
[DEFINED] :NONAME [IF]
: :NONAME ( -- xt colon-sys )
  \g Create an anonymous colon definition.
  :NONAME
  1 (defining) !
  (needs-immediate) off \ resest the flag after errors, if any
;
[THEN]

\ Provide [IMMEDIATE] which will trigger the effects of IMMEDIATE at the
\ next possible safe moment.
: [IMMEDIATE] ( -- )
  \g Make the most recent definition (whether a word currently being
  \g defined when between : and ;, or the word most recently defined
  \g when after ;) an immediate word.  Ignored during the body of
  \g :NONAME, otherwise ambiguous if the most recent definition does not
  \g have a name, or was defined as a SYNONYM.
  (defining) @ ?DUP IF  \ inside : or :NONAME
    0< IF (needs-immediate) on THEN  \ delay during :, ignore during :NONAME
    EXIT THEN
  IMMEDIATE  \ not currently defining, so safe to do now
; IMMEDIATE
