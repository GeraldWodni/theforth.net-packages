\ FORTH BIT Arrays , by Bob Dickow dickow@turbonet.com
\ version 1.0.3 Mar 2, 2018
\ Notes:
\ endian agnostic, address unit agnostic (untested)
\ Vocabulary (internal dependencies) ^2MASKS bmask _BIT@
\ Vocabulary: 2^ BIT@ BIT! BOOL@ BOOL!
\ BOOL@ and BOOL! are convenience words to avoid converting FALSE to 1
\ 2^ may be handy outside the array access words. Included for compatibility with earlier versions
\ Buffers for a bit array should be a minimum of 1 CELL in size

DECIMAL

CELL 8 * CONSTANT AddressUnit \ 8 is bits in a byte

\ calulates the power of 2 ( n -- 2^n )

: 2^   ( n -- 2^n )
  1 swap lshift
;

\ compiling word, creates an array of CELL * 8 powers of 2 for masking use in the array fetch and store words. 
\ does: ( nindex -- nvalue  ) \\ nindex is 0, 1, 2 ... giving 2^31, 2^30, 2^29 ... 2^0

: ^2MASKS  ( <name> --  )
  CREATE
  0 AddressUnit 1-  DO 
   i 2^ 
   , -1 +LOOP  
  DOES>  SWAP CELLS + @ 
;

^2MASKS bmask \ lookup table of powers of 2 for the BIT@ and BOOL@ words

\ factored out, internal use by BIT@,  BOOL@

: _BIT@    ( caddr n-index -- n ) 
  AddressUnit /MOD 	( caddr n n )
  CELLS        ( caddr n n )
  ROT  +       ( n caddr )
  @ SWAP       ( nval n )
  bmask AND    ( n )
;


\ given a memory buffer address caddr and index n representing at bit-wise 
\ index, return the value of the bit at that index as 1 | 0.

: BIT@   ( caddr n-index -- n ) 
  _BIT@  ( n )
  0= NOT
  ABS
;

\ store a value TRUE|FALSE or 1|0, given the value (TRUE|FALSE or 1|0), an address, and a bit-wise index
\ (synonym for BOOL! below)

: BIT!   ( n-value caddr n-index -- )
  ROT ABS 1 AND        ( caddr n n ) \ bounds check
  IF [']  OR ELSE ['] XOR  THEN >R \ set masking op
  AddressUnit /MOD 		 ( caddr n n )
  CELLS                ( caddr n n )
  ROT  +  DUP          ( n caddr caddr )
  @ ROT                ( caddr caddr nval )
  bmask R> EXECUTE     ( caddr n )
  SWAP !
;


\ given a memory buffer address caddr and index n representing at bit-wise
\ offset, return or store the value of the bit as TRUE|FALSE values.

: BOOL@   ( caddr n-index -- flg )  
  _BIT@  			 ( n )
  0= NOT       ( n )
;

\  Synonym for BIT!
\  store a value TRUE|FALSE ( or 1|0 ), given the value n, a base address of the array, and a bit-wise index into it.

: BOOL!   ( n caddr n-index --  )  
  BIT!  
;





 
