# Screens.fs requirements documentation

### Standard conformant labeling

This is an ANS Forth Program with environmental dependencies, 

- Requiring ['] WHILE VARIABLE TYPE THEN SWAP SPACE REPEAT R@ R> OVER MOVE MAX LOOP IF I EXIT ELSE DUP DROP DOES> CREATE CR CONSTANT BEGIN @ >R ; : 2SWAP 2DUP 2DROP 2@ 2! 1+ 0= / ." . - , +! + - ! EVALUATE ABORT" ( from the Core word set.
- Requiring U.R PAD NIP ?DO .R \ from the Core Extensions word set.
- Requiring LOAD EVALUATE from the Block word set.
- Requiring THRU SCR LIST \ from the Block Extensions word set.
- Requiring 2VARIABLE from the Double-Number word set.
- Requiring THROW CATCH from the Exception word set.
- Requiring ABORT" from the Exception Extensions word set.
- Requiring PAGE from the Facility word set.
- Requiring READ-FILE R/O OPEN-FILE FILE-SIZE CLOSE-FILE BIN ( from the File Access word set.
- Requiring FREE ALLOCATE from the Memory-Allocation word set.
- Requiring [THEN] [IF] from the Programming-Tools Extensions word set.
- Requiring COMPARE /STRING from the String word set.

## Required program documentation

### Environmental dependencies
- This program has no known environmental dependencies.
- Requiring the following non-standard words:
     - `[unefined]` in order to check if a word is missing. `[undefined]` can be defined in Forth-94 as

```forth
            : undefined ( <name> -- f )  BL WORD FIND SWAP DROP 0= ;
```

     - `[defined]` in order to check for the existence of a word. `[defined]` can be defined in Forth-94 as

```forth
            : defined ( <name> -- f )  [undefined] 0= ;
```

- Using lower case for standard definition names.

### Other program documentation 

- After loading this program, a Standard System does not exist any longer as standard words from the Block word set are redefined in a non-standard way.

