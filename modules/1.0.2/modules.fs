\ VFX like modules based on Forth-94 wordlists      uho 2016-04-16
\ ----------------------------------------------------------------

: MODULE ( <name> -- old-current )
    GET-CURRENT   WORDLIST CREATE DUP >R , 
    GET-ORDER R@ SWAP 1+ SET-ORDER 
    R> SET-CURRENT ;

: EXPORT ( <name> old-current -- old-currrent ) >R
    >IN @  '  SWAP >IN !  GET-CURRENT    R@ SET-CURRENT  
    CREATE SWAP , SET-CURRENT R>
    DOES> @ EXECUTE ;

: EXPOSE-MODULE ( <name> -- )
    GET-ORDER  ' >BODY @  SWAP 1+ SET-ORDER ;

: END-MODULE ( old-current -- )
    SET-CURRENT   GET-ORDER NIP 1- SET-ORDER ;
