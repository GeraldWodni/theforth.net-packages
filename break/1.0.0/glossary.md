BREAK Glossary
==============

BREAK  ( -- )    
-----

**Run-time:** 

Immediately exit the innermost textual enclosing `BEGIN`- or
`DO`-loop (removing the loop's `loop-sys` from the return stack). 
If no surrounding loop is present, exit the current definition
(removing the definition's `nest-sys` from the return stack).

**Interpretation:** Interpretation semantics for this word are undefined.

**Compilation:** 

  - Within a `BEGIN`-loop ( C: dest -- orig dest ) ( u v loopID -- u+1 v loopID )

    Put the location of a new unresolved forward reference orig onto the control
    flow stack below an existing dest that specifies the beginning of the
    `BEGIN`-loop. Update u to reflect the new item on the control stack.

    Append the run-time semantics given above to the current definition. 

    The semantics are incomplete until orig is resolved (e.g., by `UNTIL`).

  - Within a `DO`-loop or outside any loop ( C: -- ) ( loopID -- loopID )

    Append the run-time semantics given above to the current definition.



CONTINUE    ( -- )
------------------
**Run-time:** 

Immediately start a new cycle of the innermost textual enclosing `BEGIN`- or
`DO`-loop: In a `BEGIN` loop transfer control directly to the
beginning of the loop. In a `DO`-loop transfer control directly to the 
corresponding `LOOP` or `+LOOP` skipping all remaining instructions. 
If no surrounding loop is present, exit the current definition
(removing the definition's `nest-sys` from the return stack).

**Interpretation:** Interpretation semantics for this word are undefined.

**Compilation:** 

   - Within a `BEGIN`-loop ( C: dest -- dest ) ( loopID -- loopID )

     Append the run-time semantics given above to the current definition, 
     resolving the backward reference dest. 

   - Whithin a `DO`-loop ( C: -- orig ) ( u v loopID -- u+1 v loopID )

     Put the location of a new unresolved forward reference orig onto the control
     flow stack. Update u to reflect the new item on the control stack.

     Append the run-time semantics given above to the current definition.

     The semantics are incomplete until orig is resolved (e.g., by ´LOOP´).

   - Outside any loop ( C: -- ) ( loopID -- loopID )

     Append the run-time semantics given above to the current definition.