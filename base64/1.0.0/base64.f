\ BASE64 Encode/Decode
\ base64.f
\ version 1.0.0
\ Bob Dickow, March 29, 2018

BASE @

DECIMAL

\ Build a translation table data-smart word, defered so you can delegate 
\ your own words to map to and from streamed 6-bit tokens to printable 
\ characters:

DEFER >BASE64CHR  \ given 6-bit n index, returns base64 representation
DEFER BASE64CHR>  \ given chr , returns 6-bit representation

\ Compiling word to build standard base 64 6-bit chars lookup:

: BUILD-BASE64-ENCODING-LOOKUP: ( n-index <name> -- chr ) 
	CREATE
	'A' C, 'B' C, 'C' C, 'D' C, 'E' C, 'F' C, 
	'G' C, 'H' C, 'I' C, 'J' C, 'K' C, 'L' C, 
	'M' C, 'N' C, 'O' C, 'P' C, 'Q' C, 'R' C, 
	'S' C, 'T' C, 'U' C, 'V' C, 'W' C, 'X' C, 
	'Y' C, 'Z' C, 'a' C, 'b' C, 'c' C, 'd' C, 
	'e' C, 'f' C, 'g' C, 'h' C, 'i' C, 'j' C, 
	'k' C, 'l' C, 'm' C, 'n' C, 'o' C, 'p' C, 
	'q' C, 'r' C, 's' C, 't' C, 'u' C, 'v' C, 
	'w' C, 'x' C, 'y' C, 'z' C, '0' C, '1' C,
	'2' C, '3' C, '4' C, '5' C, '6' C, '7' C,
	'8' C, '9' C, '+' C, '/' C, DOES> + C@ ;

\ For decoding, caculate the output 6-bit value given an ASCII chr token
\ instead of reverse lookup table. This actually profiles as faster.

: STANDARD-BASE64CHR> ( base64chr -- n )
  DUP 96 > IF
    71 -
  ELSE
    DUP 64 > IF
      65 -
    ELSE
      DUP 47 > IF
        4 +
      ELSE \ handles the '+' or '/'
        DUP 47 = IF 
          DROP 63
        ELSE
          DROP 62
        THEN
      THEN
    THEN
  THEN  ;

\ Set the word to build lookup table above:

\ Compile the lookup word that, given a 6-bit indexer, 
\ returns a printable character for encoding:

BUILD-BASE64-ENCODING-LOOKUP: >BASE64CHR-LOOKUP \ the encoding lookup

' >BASE64CHR-LOOKUP IS >BASE64CHR \ set the vector for encoding
' STANDARD-BASE64CHR> IS BASE64CHR>  \ set the vector for decoding

\ padding characters (usually '=') are added to encoded strings
\ if they are not an even tetrad of 6-bit units

VARIABLE PADDING-CHR

'=' PADDING-CHR !  \ initialize default '=' padding at end of base64 string.

\ Use the PADDING? variable to set a global that will assume
\ padded ( if PADDING is TRUE) or non-padded (if PADDING? is FALSE) base64 result. 
\ Padding characters are the '=' or '==' string endings. Some environments assume
\ unpadded base64 strings, such as for e-mail HELO authentication dialogs etc.

VARIABLE PADDING? 
 
PADDING? ON \  initialize default to TRUE; use padded endings on encoded output strings.

\ BASE64-ENCODE-LEN -- Helper word. Use to return required buffer size for the encoded output given
\ length n of un-encoded input data in bytes.

: BASE64-ENCODE-LEN ( n -- n )
  1- 3 /MOD NIP 4 * 4 + 
  PADDING? @ FALSE = IF
    DUP
    3 /MOD DROP
    ?DUP IF
      3 SWAP - 1+ -
    THEN
  THEN ;

: BASE64-DECODE-LEN ( c-addr-encoded n -- n )
  2 0 DO
  	2DUP 1-  + C@ PADDING-CHR = 
  	+
  LOOP
  NIP
  6 * 8 / ;

\ Provided buffer and length, return adjusted length:

: TRIM-PADDING ( c-addr-encoded n -- c-addr-encoded n )
  1- 
  2 0 DO
  	2DUP  + C@ PADDING-CHR @ = 
  	+
  LOOP 1+ ;

\ For flexibility, the encoding and decoding words do not assume
\ space for counts or zero-byte delimiters.

\ >BASE64 (say "TO BASE64") is the high level encoding word.
\ Creates base64 encoded string and places in buffer (c-addr-output).
\ To use, set up a buffer of size 3:4 input:output 
\ length proportions. (Use BASE64-ENCODE-LEN ( source-len -- result-len )
\ helper word for convenience in calculating storage bytes.)
\ The input string or data is a byte-aligned buffer.
\ n-len is the length in bytes of the buffer.

: >BASE64 ( c-addr-output c-addr-source-data n-len -- c-addr-output n-len ) 
  {: output-buffer source-data len | accum chr-index out-index  :}
  0 TO accum  0 TO chr-index  0 TO out-index
  len 0= IF output-buffer 0 EXIT THEN
  BEGIN  \ looping through each input byte, bit-twiddling and assembling output data as base64 characters.
     source-data chr-index + C@ DUP
     1 +TO chr-index
     $FC AND  2 RSHIFT
     >BASE64CHR output-buffer out-index + C!
     1 +TO out-index
     3 AND  4 LSHIFT  TO accum
     chr-index len >=  IF   
       accum 
       >BASE64CHR output-buffer out-index + C!
       1 +TO out-index
     THEN
	   chr-index len < IF
	     source-data chr-index + C@ DUP
	     1 +TO chr-index
	     $F0 AND  4 RSHIFT
	     accum OR 
	     >BASE64CHR output-buffer out-index + C!
	     1 +TO out-index
	     $0F AND 2 LSHIFT
	     TO accum
	     chr-index len >= IF
         accum  
         >BASE64CHR output-buffer out-index + C!
         1 +TO out-index
       THEN
	     chr-index len < IF
		     source-data chr-index + C@ DUP
		     1 +TO chr-index
		     $C0 AND 6 RSHIFT accum OR 
		     >BASE64CHR output-buffer out-index + C!
		     1 +TO out-index
		     $3F AND
		     >BASE64CHR output-buffer out-index + C!
		     1 +TO out-index
	     THEN
    THEN
    chr-index len >=
	UNTIL
  PADDING? @ IF
	  chr-index 3 /MOD DROP
		?DUP IF
		   3 SWAP -  0 DO 
			 	   PADDING-CHR @ output-buffer out-index + C!
			 	   1 +TO out-index
		   LOOP
		THEN
	THEN
	output-buffer out-index ;

\ BASE64> (say "BASE64 FROM") is the high level decoding word.
\ To use, set up a buffer (c-addr-output) of size 4:3 input:output 
\ length proportions. (Use BASE64-DECODE-LEN ( source-len -- target-len )
\ word for convenience.)
\ The input string or data is a byte-aligned buffer buffer.
\ n-len is the length in bytes of the buffer.

: BASE64> ( c-addr-output c-addr-encoded n-len  -- )
  {: output-buffer source-data len | accum chr-index out-index exit-flg :}
  0 TO accum   0 TO chr-index   0 TO out-index
  source-data len TRIM-PADDING TO len DROP
  FALSE TO exit-flg
  BEGIN
    source-data chr-index + C@  
    1 +TO chr-index
    BASE64CHR>                  
    2 LSHIFT          
    source-data chr-index + C@  
    1 +TO chr-index
    BASE64CHR>  DUP             
    $30 AND 4 RSHIFT ROT OR     
    output-buffer out-index + C! 
    1 +TO out-index
    chr-index len < IF
      $0F AND 4 LSHIFT          
      source-data chr-index + C@  
      BASE64CHR>   
      1 +TO chr-index
      DUP $3C AND 2 RSHIFT  ROT OR 
      output-buffer out-index + C!
		  1 +TO out-index
      chr-index len < IF
	      $3 AND 6 LSHIFT 
	      source-data chr-index + C@
	      1 +TO chr-index
	      BASE64CHR> OR
	      output-buffer out-index + C!
	      1 +TO out-index
      ELSE
        DROP 
        TRUE TO exit-flg
      THEN
    ELSE
      DROP
      TRUE TO exit-flg
    THEN
    chr-index len >= exit-flg OR
  UNTIL
  output-buffer out-index ;

BASE !
