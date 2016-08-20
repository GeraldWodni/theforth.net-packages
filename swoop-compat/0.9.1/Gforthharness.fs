\ gforth harness for SWOOP
\ derived from VFXHarness

: create-xt ( "name" -- xt )
  create lastxt ;

0 constant location

: cell- ( x -- x' )  cell - ;

: @+		\ addr -- addr+cell x
  dup cell +  swap @  ;

: !+		\ addr x -- addr+cell
  over !  cell +  ;

: /ALLOT	\ n --
  HERE SWAP DUP ALLOT ERASE ;

: LINKS ( a -- a' )
  begin dup @ dup while nip repeat drop ;

: >LINK ( a -- )
  here over @ ,  swap ! ;

: <LINK ( a -- )   LINKS  >LINK ;

user 'This	\ -- addr
\ *G Holds the handle of the current class.
user 'Self	\ -- addr
\ *G Holds the handle of the current object.

s" Not an object" exception constant IOR_OOP_NOTOBJ
s" No member (resolve)" exception constant IOR_OOP_NORESOLVE
s" No member (sendmsg)" exception constant IOR_OOP_NOSENDMSG
s" No member (calling)" exception constant IOR_OOP_NOCALLING
s" Not a member" exception constant IOR_OOP_NOTMEMBER

: ?throw ( -1 ior -- ??? ) ( 0 ior -- )
  swap if throw else drop then ;
