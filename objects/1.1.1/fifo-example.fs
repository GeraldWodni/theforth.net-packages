\ Copyright 1998 Jean-Francois Brouillet
\ included in this package with permission
\ He cautions: "As I said, I don't think it qualifies for "production
\ qualtity" status (among other things, I'd define powers of two only
\ sizes so that my indices would "roll-over" with very little
\ overhead.)"

\ Article: 37100 of comp.lang.forth
\ Path: news.tuwien.ac.at!aconews.univie.ac.at!newscore.univie.ac.at!news-spur1.maxwell.syr.edu!news.maxwell.syr.edu!newsfeed.atl.bellsouth.net!uunet!uunet!in4.uu.net!news7-gui.server.ntli.net!news-feed.ntli.net!not-for-mail
\ From: "Jean-Francois Brouillet" <jean-francois.brouillet@virgin.net>
\ Newsgroups: comp.lang.forth
\ Subject: Anton Ertl's objects.fs's experiment
\ Date: Thu, 17 Sep 1998 23:41:27 +0100
\ Organization: Virgin News Service
\ Lines: 129
\ Message-ID: <6ts34s$o8d$1@nclient3-gui.server.virgin.net>
\ NNTP-Posting-Host: 194.168.123.41
\ Mime-Version: 1.0
\ Content-Type: text/plain; charset="US-ASCII"
\ Content-Transfer-Encoding: 7bit
\ X-Newsreader: Microsoft Outlook Express for Macintosh - 4.01 (295)
\ Xref: news.tuwien.ac.at comp.lang.forth:37100

\ Of all the available Forth OO models I've found on the net
\ so far, I'm beginning to favor Anton Ertl's objects.fs.

\ Here's a plain vanillia (non optimized, but the purpose was
\ more to experiment with Anton's syntax/semantics than to get
\ production quality code) Fifo class.

\ The only two comments I have up to now on this OO model is that

\ 1)  it doesn't seem possible to invoke a method before it is defined
\     -- see my other `FORWARD' thread --, practice wich is very common
\     in all (non Forth) OO languages I'm used to.
    
\ 2)  It seems to me that ;M is *always* followed by either METHOD
\     or OVERRIDE. If this is indeed the case, it could be worthwhile
\     to define (say) ;METHOD and ;OVERRIDE that would do both at once ?
    
    
\ For the following class to compile, you need, in addition to Anton's
\ struct.fs and object.fs the following definitions:

: AND! ( x addr ) DUP @ ROT AND SWAP ! ;
: OR! ( x addr ) DUP @ ROT OR SWAP ! ;
: XOR! ( x addr ) DUP @ ROT XOR SWAP ! ;
: INVERT! ( addr ) DUP @ INVERT SWAP ! ;


OBJECT CLASS

 1 CONSTANT  OVERRUN
 2 CONSTANT  UNDERRUN

 cell% INST-VAR mPutIndex
 cell% INST-VAR mGetIndex
 cell% INST-VAR mSizeMax
 cell% INST-VAR mCurrentSize
 cell% INST-VAR mBuffer
 cell% INST-VAR mFlags             \ only bits 0-1 are currently used

 M: ( -- )  0 mPutIndex !
            0 mGetIndex !
            0 mCurrentSize !
            0 mFlags !                            ;M METHOD clear

 M: ( buffer size -- )
           THIS clear mSizeMax ! mBuffer !        ;M OVERRIDES construct

 \ Adjusts mGetIndex so that the whole fifo becomes available for get.
 \ Used when an overrun occurs to discard all but the last received
 \ bytes (instead of the easier but naive strategy of keeping the oldest)
 M: ( -- )  mPutIndex @ 1 - mGetIndex !
                mGetIndex @ 0< IF
                mSizeMax @ mGetIndex +!
            THEN                                  ;M METHOD _pinGet
 
 M: ( b -- f )  mFlags @ AND 0= 0=                ;M METHOD _flag?
 M: ( b -- )    mFlags OR!                        ;M METHOD _flag!
 M: ( b -- )    INVERT mFlags AND!                ;M METHOD _flag0!

 M: ( -- )      OVERRUN THIS _flag!   
                THIS _pinGet                      ;M METHOD _overrun!
 M: ( -- )      OVERRUN THIS _flag0!              ;M METHOD _overrun0!
 M: ( -- )      UNDERRUN THIS _flag!              ;M METHOD _underrun!
 M: ( -- )      UNDERRUN THIS _flag0!             ;M METHOD _underrun0!

 M: ( -- f )    OVERRUN THIS _flag?               ;M METHOD overrun?
 M: ( -- f )    UNDERRUN THIS _flag?              ;M METHOD underrun?

 M: ( -- f )    mCurrentSize @ mSizeMax @ >=      ;M METHOD full?
 M: ( -- f )    mCurrentSize @ 0<=                ;M METHOD empty?

 M: ( c -- )    mBuffer @ mPutIndex @ + C!
                1 CHARS mCurrentSize +!
                1 CHARS mPutIndex +!
                mPutIndex @ mSizeMax @ >= IF
                    0 mPutIndex !
                THEN                              ;M METHOD _put

 M: ( c -- )    THIS full? IF
                    DROP
                    THIS _overrun!
                ELSE
                    THIS _overrun0!
                    THIS _put
                THEN                              ;M METHOD put

 M: ( -- c )    THIS empty? IF
                    THIS _underrun!
                    -1
                ELSE
                    THIS _underrun0!
                    mBuffer @ mGetIndex @ + C@
                    -1 CHARS mCurrentSize +!
                    1 CHARS  mGetIndex +!
                    mGetIndex @ mSizeMax @ >= IF
                        0 mGetIndex !
                    THEN
               THEN                               ;M METHOD get
END-CLASS Fifo

DECIMAL
CREATE buffer 256 CHARS ALLOT

buffer 16 Fifo heap-new CONSTANT myFifo

: test-fifo
    myFifo clear
    12 0 DO I myFifo put LOOP

    BEGIN myFifo empty? 0= WHILE
        myFifo get .
    REPEAT
;

: test2-fifo ( n -- )
     myFifo clear
 
     0 DO I myFifo put LOOP

     BEGIN myFifo empty? 0= WHILE
         myFifo get .
     REPEAT
;


\ --
\ jean-francois.brouillet@virgin.net
\ verec@sms.ndirect.co.uk
\ verec@micronet.fr


