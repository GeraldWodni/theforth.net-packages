\ linked list utilities

\ linked lists should be stored in a place it is
\ possible to get the address of, like a VARIABLE
\ this makes it easier to do things like insert an element at the start of the list

\ gforth extension, automatially allocate THROW code
[defined] exception [if]
s" linked list out-of-bounds" exception constant ll-oob
[then]

[defined] ll-oob [if] 
: ?ll-nil dup 0= if drop ll-oob throw then ;
[else]
: ?ll-nil dup 0= abort" linked list out-of-bounds" ;
-2 constant ll-oob
[then]

: ll-index ( ll u -- x ) 0 ?do ?ll-nil @ loop ;
: ll-length ( ll -- u ) 0 >r begin dup while r> 1+ >r @ repeat r> ;

: ll-insert ( elem ll -- ) 2dup @ swap ! ! ;
\ unlinks and returns the next element of the list,
\ pass the address of a variable containing the ll to insert at the start
: ll-shift ( ll -- elem ) dup @ dup >r @ swap ! r> ;
\ find the previous element, returns 0 if not found
: ll-find ( elem ll1 -- ll2 )
  begin dup while 2dup @ <> while @ repeat then nip ; 

\ find and remove specified element, returning 0 if the element was found
\ return value is suitable for throw
: ll-remove ( elem ll -- err )
  ll-find dup if ll-shift drop 0 else drop ll-oob then ;

\ create and link a new list element in data-space
: ll, ( ll -- ) here over @ , swap ll-insert ;

\ traverse a linked list.  xt has stack effect ( ... ll -- ... flag )
\ if xt returns false, traversal is halted.
: ll-traverse ( ... xt ll -- ... )
  2>r begin r@ while 2r@ swap execute while r> @ >r repeat then 2rdrop ;

	
