\ synco.fs	Synchronous concurrency for RosettaCode
include co.fs

: STRING@	DUP CELL + SWAP @ ;

	2VARIABLE CHAN

\
\ * READER LEXEME
\ 
	4096 CONSTANT L#
	CREATE Line 0 , L# ALLOT
: READER
	CO:
	BEGIN
		Line cell+ L# STDIN read-line THROW
	WHILE
		Line !
		0 Line CHAN 2!
		CO		
	REPEAT	DROP
	Line DUP CHAN 2!

	\ -- Wait for report back
	BEGIN CO CHAN CHAN? UNTIL

	\ -- Have it, show and go
	CR S" -------" TYPE
	CR S" LINES: " TYPE CHAN @ ?
;
\
\ * WRITER LEXEME
\
	VARIABLE X
: WRITER
	CO:
	BEGIN
		CHAN CHAN?
	WHILE
		CHAN @ STRING@ TYPE CR
		1 X +!
		CO
	REPEAT

	\ -- Chance to stop other writers
	CO

	\ -- First of writers reports back
	\ -- the shared global counter 
	CHAN CHAN? 0=
	IF
		0 X CHAN 2!
		CO
	THEN
;
\
\ * RUNNER
\
0 X ! READER WRITER ( WRITER WRITER :-) GO CR BYE
