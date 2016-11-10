# Keccak: Hash and encryption

Keccak is the crypto primitive for SHA-3, and can be used as hash as
well as pseudo random number generator or as authenticated
encryption/decryption.

Keccak uses 64 bits by default, a 32 bit version will follow.

## User functions

### Crypto primitives

+ `st0 ( -- )` clear state
+ `keccakf ( -- )` the diffusion function
+ `>sponge ( addr u -- )` Absorb string into state (string must be cell-sized)
+ `>duplex ( addr u -- )` Absorb and encrypt string
+ `duplex> ( addr u -- )` Absorb and decrypt string
+ `padded ( addr1 u1 u2 -- addr2 u2 )` Pad string

### Usage examples

+ `hash256 ( addr u -- )` compute a 256 bit hash (not identical to sha-3)
    : hash256 ( addr u -- )
        st0  bounds ?DO
            I I' over - $88 umin
            dup $88 u< IF $88 padded  THEN  >sponge
            keccakf
        $88 +LOOP ;
+ `end256 ( addr u1 key u2 -- )` encode message with key
    : enc256 ( addr u1 key u2 -- )
        st0 >sponge keccakf
        bounds ?DO
            I I' over - $88 umin
            dup $88 u< IF
                2dup $88 padded >duplex
                kpad -rot move
            ELSE  >duplex  THEN
            keccakf
        $88 +LOOP ;
+ `dec256 ( addr u1 key u2 -- )` decode message with key
    : dec256 ( addr u1 key u2 -- )
        st0 >sponge keccakf
        bounds ?DO
            I I' over - $88 umin
            dup $88 u< IF
                2dup $88 padded >duplex
                kpad -rot move
            ELSE  >duplex  THEN
            keccakf
        $88 +LOOP ;
