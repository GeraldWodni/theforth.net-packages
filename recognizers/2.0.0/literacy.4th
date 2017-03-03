\ from Newsgroups: comp.lang.forth
\ Date: Sun, 28 Dec 2014 14:12:44 -0800 (PST)
\ Message-ID: <fdfa0f77-57f9-4ea6-b5bc-32d5651aabef@googlegroups.com>
\ Subject: String literacy
\ From: Julian Fondren <julian....@gmail.com>

\ Adapted to recognizer RFDv3 ff. by MT
\ License: probably public domain, contact author

\ Also, notice how I intend code by two spaces?  That makes it very
\ clear what's code and what's me talking about code, without the
\ reader having to keep switching between two files, say.  It also
\ allows me to tie documentation and source together in such a way
\ that one will seldom be supplied without the other.  You could
\ even organize your code into 'blocks', with corresponding 'shadow
\ blocks' ... well, once again, let's just do it:

\ This is the entire contents of literate.fs:

  ' noop ' noop ' noop dt-token: dt:noop
  : literacy-recognizer ( c-addr u -- dt:noop | dt:null )
    2drop source s"  " string-prefix? if dt:null else 0 parse 2drop dt:noop then ;

  \ place it at the top of the recognizer stack
  forth-recognizer get-recognizers 
  1+ ' literacy-recognizer swap 
  forth-recognizer set-recognizers

And the entire rest of my post will be the contents of a file
named hello.fs, which makes use of it:

--- hello.fs begins next line ---
  require literate.fs

Having required literate.fs, the rest of this file is commentary unless
intended by two spaces.

For example, Forth will pass over the following:

: hello ( -- )  cr ." Hello!" ;

But will compile and execute these indented statements:

  : goodbye ( -- )
    cr ." Good bye." ;

  goodbye bye bye bye

(This behavior is also seen interactively.)
