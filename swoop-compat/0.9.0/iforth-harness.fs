needs -toolbelt 

user 'THIS
user 'SELF

PACKAGE OOP

0 constant location

: CREATE-XT ( "name" -- xt )
  >in @ create >in !
  current @ >order ' previous ;

: /ALLOT ( n -- )    here swap  dup allot  erase ;
: LINKS ( a -- a' )  begin dup @ dup while nip repeat drop ;
: >LINK ( a -- )     here over @ ,  swap ! ;
: <LINK ( a -- )     LINKS >LINK ;

( arbitrary numbers )
771 constant IOR_OOP_NOTOBJ
772 constant IOR_OOP_NORESOLVE
773 constant IOR_OOP_NOSENDMSG
774 constant IOR_OOP_NOCALLING
775 constant IOR_OOP_NOTMEMBER

: ?throw ( -1 ior -- ??? )  ( 0 ior -- )
  swap if throw else drop then ;

: >name ( xt -- nt | 0 )
  >head head>name ;

\ contrary to iforth's included !+
\ this is the main reason for stuffing these words in OOP
: !+ ( a n -- a+cell )
  swap dup cell+ -rot ! ;

END-PACKAGE
