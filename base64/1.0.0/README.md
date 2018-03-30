Base64 Encoding/Decoding 
============================================
Robert Dickow <<dickow@turbonet.com>>
Package base64
Version 1.0.0 - 2018-03-30

### Description:

A simple lexicon to encode and decode strings or arbitrary
data in base64 format using most common (e.g. MIME) character
mapping and padding characters.

### Top level words:

\ N.B. For flexibility, the buffers are not delimited. Store your own counts as needed.

\ Given an output buffer, a source buffer holding un-encoded data, and its length

\ in bytes, returns addr of the output buffer holding encoded data and its length.

`>BASE64`  ( c-addr-output c-addr-source-data n-len -- c-addr-output n-len )


\ Given an output buffer, a source buffer holding encoded data, and its length

\ in bytes, returns address of the decoded output buffer and its length.

`BASE64>`  ( c-addr-output c-addr-source-data n-len -- c-addr-output n-len )


### Helper words:

\ given buffer and its length, returns bytes needed for encoded data.

`BASE64-ENCODE-LEN` ( n-decoded-len -- n ) 


\ given buffer addr and its length, returns bytes needed for decoded data.

`BASE64-DECODE-LEN` ( c-addr-encoded n-len -- n ) 


\ given buffer addr and its length, returns buffer addr and new length

\ trimming the count of padding characters, if present. The buffer is not

\ touched.

`TRIM-PADDING` ( c-addr-encoded n -- c-addr-encoded n ) 


### Configuration words:

`PADDING?`  variable, TRUE|FALSE to use padding or not.

`PADDING-CHR` variable, defaulted to the usual '='

### Include file

base64.f


### Dependencies

none


### Usage Example



\ *************************

\ Set up a buffer in heap memory based

\ on the storage needs of a string of

\ text to encode.

\ *************************

\ for storing the address of allocated memory:

VARIABLE output-buffer

\ the string to encode and later decode:

S" Hello World!!" DUP ( c-addr len len )

\ allocate len bytes, drop the Ior, and save address:

ALLOCATE DROP DUP output-buffer ! ( c-addr len c-addr-output )

\ set up the stack for encoding word:

ROT ROT  ( c-addr-output c-addr len )


\ *********************

\ Encode:

\ *********************

>BASE64  ( c-addr-output n-len )

2DUP CR TYPE  ( c-addr-output n-len )

\ displays: "SGVsbG8gV29ybGQhIQ=="


\ *********************

\ Decode:

\ *********************

\ Note: PAD works fine for small buffers.

\ The same buffer won't work for both output and 

\ input in the same operation, hence the allocated

\ memory buffer.

PAD  ROT ROT  ( addr-pad c-addr-output n-len ) 

BASE64> CR   ( -- addr-pad n-len )

TYPE

\ displays: "Hello World!!"

output-buffer @ FREE DROP  ( -- )

\ done



## Tests

DECIMAL

\ set up oversized buffers for the encoded and decoded data:

CREATE EncodedOutput-Buffer 50 ALLOT

CREATE DecodedOutput-Buffer 50 ALLOT

T{ EncodedOutput-Buffer S" Man is distinguished" >BASE64 S" TWFuIGlzIGRpc3Rpbmd1aXNoZWQ=" COMPARE -> 0 }T 
 
T{ DecodedOutput-Buffer S" TWFuIGlzIGRpc3Rpbmd1aXNoZWQ=" BASE64> S" Man is distinguished" COMPARE -> 0  }T 

T{ S" Hello world!" 2DUP EncodedOutput-Buffer -ROT >BASE64 DecodedOutput-Buffer -ROT BASE64> COMPARE -> 0 }T


## Changes

1.0.0 first version


## Bug Reports

Please send suggestions, comments, or bug reports Bob Dickow <<dickow@turbonet.com>>

## Compatibility

This lexicon was tested on SwiftForth 3.7.1


